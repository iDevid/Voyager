import Foundation

public typealias CachePolicy = URLRequest.CachePolicy

public protocol NetworkService<ResponseModel> {

    associatedtype ResponseModel: Decodable
    associatedtype QueryRequestModel: NetworkRequest = Never
    associatedtype BodyRequestModel: NetworkRequest = Never
    associatedtype EndpointParameters: Any = Never
    
    typealias FullResponseModel = NetworkResponse<ResponseModel>
    typealias ErrorType = NetworkError
    typealias ResultType = Result<ResponseModel, ErrorType>
    typealias ResultCompletion = (ResultType) -> Void
    typealias FullResultType = Result<FullResponseModel, ErrorType>
    typealias FullResultCompletion = (FullResultType) -> Void
    
    var acceptedStatusCodes: Set<Int> { get }

    var additionalHeaders: [String: String] { get }
    
    var cachePolicy: CachePolicy { get }

    var jsonDecoder: JSONDecoder { get }
    
    var rootEndpoint: String { get }

    var method: HTTPMethod { get }

    var sessionConfiguration: URLSessionConfiguration { get }

    var shouldReturnCachedResponseOnError: Bool { get }
    
    var timeoutInterval: TimeInterval { get }

    func endpoint() -> String

    func endpoint(parameters: EndpointParameters) -> String

    func log(request: URLRequest?, result: FullResultType)

    func getCachedResponse(queryRequest: QueryRequestModel?, bodyRequest: BodyRequestModel?, endpointParameters: EndpointParameters?) -> ResponseModel?

    func perform(
        queryRequest: QueryRequestModel?,
        bodyRequest: BodyRequestModel?,
        endpointParameters: EndpointParameters?,
        queue: DispatchQueue,
        completion: ResultCompletion?
    )

    func performFullRequest(
        queryRequest: QueryRequestModel?,
        bodyRequest: BodyRequestModel?,
        endpointParameters: EndpointParameters?,
        queue: DispatchQueue,
        completion: FullResultCompletion?
    )
}

public extension NetworkService {
    private func catchError(_ error: Error, urlRequest: URLRequest, response: HTTPURLResponse?) -> FullResultType {
        if
          shouldReturnCachedResponseOnError,
          let cachedData = URLCache.shared.cachedResponse(for: urlRequest)?.data {
            return decodeData(cachedData, response: response, wasCached: true)
        } else {
            return .failure(.networkingError(error))
        }
    }
    
    private func manageResponseData(
        data: Data?,
        oldData: Data?,
        response: HTTPURLResponse?,
        error: Error?,
        request: URLRequest,
        completion: @escaping (FullResultType) -> Void
    ) {
        if let error = error {
            completion(self.catchError(error, urlRequest: request, response: response))
            return
        }
        guard let response = response else {
            return
        }
        guard acceptedStatusCodes.contains(response.statusCode) else {
            completion(self.catchError(
                NetworkError.invalidStatusCode(response.statusCode),
                urlRequest: request,
                response: response
            ))
            return
        }
        guard let data = data else {
            completion(self.catchError(NetworkError.noData, urlRequest: request, response: response))
            return
        }
        completion(self.decodeData(data, response: response, wasCached: oldData == data))
    }
    

    public func _performDataTask(
        queryRequest: QueryRequestModel?,
        bodyRequest: BodyRequestModel?,
        endpointParameters: EndpointParameters?,
        completion: @escaping (FullResultType, URLRequest?) -> Void
    ) {
        do {
            let urlRequest = try asURLRequest(queryRequest: queryRequest, bodyRequest: bodyRequest, endpointParameters: endpointParameters)
            let oldData = URLCache.shared.cachedResponse(for: urlRequest)?.data
            let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                self.manageResponseData(
                    data: data,
                    oldData: oldData,
                    response: response as? HTTPURLResponse,
                    error: error,
                    request: urlRequest
                ) { result in
                    completion(result, urlRequest)
                }
            }
            dataTask.resume()
        } catch let error as NetworkError {
            completion(.failure(error), nil)
        } catch {}
    }
}
