import Foundation

public extension NetworkService {
    
    func perform(
        queryRequest: QueryRequestModel?,
        bodyRequest: BodyRequestModel?,
        endpointParameters: EndpointParameters?,
        queue: DispatchQueue,
        completion: ResultCompletion?
    ) {
        performFullRequest(queryRequest: queryRequest, bodyRequest: bodyRequest, endpointParameters: endpointParameters, queue: queue) { result in
            completion?(result.getModel())
        }
    }
    
    func performFullRequest(
        queryRequest: QueryRequestModel?,
        bodyRequest: BodyRequestModel?,
        endpointParameters: EndpointParameters?,
        queue: DispatchQueue,
        completion: FullResultCompletion?
    ) {
        _performDataTask(
            queryRequest: queryRequest,
            bodyRequest: bodyRequest,
            endpointParameters: endpointParameters
        ) { result, urlRequest in
            log(request: urlRequest, result: result)
            queue.async {
                completion?(result)
            }
        }
    }

    func perform(
        queryRequest: QueryRequestModel? = nil,
        bodyRequest: BodyRequestModel? = nil,
        endpointParameters: EndpointParameters? = nil,
        queue: DispatchQueue = .main,
        _ completion: ResultCompletion?
    ) {
        perform(
            queryRequest: queryRequest,
            bodyRequest: bodyRequest,
            endpointParameters: endpointParameters,
            queue: queue,
            completion: completion
        )
    }
    
    func performFullRequest(
        queryRequest: QueryRequestModel? = nil,
        bodyRequest: BodyRequestModel? = nil,
        endpointParameters: EndpointParameters? = nil,
        queue: DispatchQueue = .main,
        _ completion: FullResultCompletion?
    ) {
        performFullRequest(
            queryRequest: queryRequest,
            bodyRequest: bodyRequest,
            endpointParameters: endpointParameters,
            queue: queue,
            completion: completion
        )
    }
}
