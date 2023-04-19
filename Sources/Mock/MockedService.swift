import Foundation
import Voyager

public protocol MockedService: NetworkService, AnyObject {
    func setNextResponse(_ mockType: MockType<ResponseModel, ErrorType>)
}

public extension NetworkService where Self: AnyObject {
    func perform(
        queryRequest: QueryRequestModel?,
        bodyRequest: BodyRequestModel?,
        endpointParameters: EndpointParameters?,
        queue: DispatchQueue,
        completion: ResultCompletion?
    ) {
        if let model = getResponse()?.getModel() {
            queue.async {
                completion?(model)
            }
        } else {
            self._performDataTask(queryRequest: queryRequest, bodyRequest: bodyRequest, endpointParameters: endpointParameters) { result, urlRequest in
                self.log(request: urlRequest, result: result)
                queue.async {
                    completion?(result.getModel())
                }
            }
        }
    }
    
    func performFullRequest(
        queryRequest: QueryRequestModel?,
        bodyRequest: BodyRequestModel?,
        endpointParameters: EndpointParameters?,
        queue: DispatchQueue,
        completion: FullResultCompletion?
    ) {
        if let model = getResponse() {
            queue.async {
                completion?(model)
            }
        } else {
            self._performDataTask(queryRequest: queryRequest, bodyRequest: bodyRequest, endpointParameters: endpointParameters) { result, urlRequest in
                self.log(request: urlRequest, result: result)
                queue.async {
                    completion?(result)
                }
            }
        }
    }
    
    private func getResponse() -> FullResultType? {
        guard
          let mockedService = self as? (any MockedService),
          let mockedResponse = mockedService.mockedResponse,
          let response = getResultType(from: mockedResponse) else {
            return nil
        }
        return response
    }
    
    private func getResultType(from result: Result<NetworkResponse<Decodable>, NetworkError>) -> FullResultType? {
        switch result {
        case .success(let value):
            guard let model = value.model as? ResponseModel else {
                return .failure(.genericError(MockedServiceError.mockInjectionError))
            }
            return .success(.init(model: model))
        case .failure(let error):
            return .failure(error)
        }
    }
}

private var currentMockTypeKey: String = "mockType"

public extension MockedService {
    
    private var currentMockType: MockType<ResponseModel, ErrorType>? {
        get {
            objc_getAssociatedObject(self, &currentMockTypeKey) as? MockType
        }
        set {
            objc_setAssociatedObject(self, &currentMockTypeKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    func setNextResponse(_ mockType: MockType<ResponseModel, ErrorType>) {
        currentMockType = mockType
    }
    
    func perform(
        queryRequest: QueryRequestModel?,
        bodyRequest: BodyRequestModel?,
        endpointParameters: EndpointParameters?,
        queue: DispatchQueue,
        completion: ResultCompletion?
    ) {
        queue.async {
            completion?(self.getMockedResponse().getModel())
        }
    }
    
    func performFullRequest(
        queryRequest: QueryRequestModel?,
        bodyRequest: BodyRequestModel?,
        endpointParameters: EndpointParameters?,
        queue: DispatchQueue,
        completion: FullResultCompletion?
    ) {
        queue.async {
            completion?(self.getMockedResponse())
        }
    }
    
    var mockedResponse: Result<NetworkResponse<Decodable>, NetworkError>? {
        switch getMockedResponse() {
        case .success(let value):
            return .success(.init(model: value.model as Decodable))
        case .failure(let error):
            return .failure(error)
        }
    }
    
    fileprivate func getMockedResponse() -> FullResultType {
        switch currentMockType {
        case .none:
            return .failure(.genericError(MockedServiceError.mockTypeNotSetted))
        case let .json(name, bundle):
            guard let path = bundle.path(forResource: name, ofType: "json") else {
                return .failure(.genericError(MockedServiceError.jsonPathNotFounded))
            }
            let url = URL(fileURLWithPath: path)
            
            do {
                let jsonData = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode(ResponseModel.self, from: jsonData)
                return .success(NetworkResponse(model: decodedData))
            } catch let error {
                return .failure(.decodingError(error))
            }
        case let .model(model):
            return .success(NetworkResponse(model: model))

        case let .failure(error):
            return .failure(error)
        }
    }
}
