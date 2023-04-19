import Foundation

extension NetworkService {

    func getURLPath(parameters: EndpointParameters? = nil) -> String {
        if let parameters = parameters {
            return rootEndpoint + endpoint(parameters: parameters)
        } else {
            return rootEndpoint + endpoint()
        }
    }

    func getURL(queryRequest: QueryRequestModel? = nil, parameters: EndpointParameters? = nil) -> URL? {
        let path = getURLPath(parameters: parameters)
        guard let queryRequest = queryRequest else {
            return URL(string: path)
        }
        var components = URLComponents(string: path)
        components?.queryItems = queryRequest.asQueryItems
        return components?.url
    }

    func asURLRequest(queryRequest: QueryRequestModel?, bodyRequest: BodyRequestModel?, endpointParameters: EndpointParameters?) throws -> URLRequest {
        guard let url = getURL(queryRequest: queryRequest, parameters: endpointParameters) else {
            throw NetworkError.invalidURL(getURLPath(parameters: endpointParameters))
        }
        var urlRequest = URLRequest(url: url)
        if let bodyRequest = bodyRequest {
            if method == .get {
                throw NetworkError.invalidMethod("GET Method could not be used with a Body Request")
            }
            urlRequest.httpBody = try bodyRequest.getData()
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
        }
        for header in additionalHeaders {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        urlRequest.cachePolicy = cachePolicy
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = timeoutInterval
        return urlRequest
    }
}
