import Foundation

@available(macOS 10.15, *)
@available(iOS 13.0, *)
public extension NetworkService {
    func perform(
        queryRequest: QueryRequestModel? = nil,
        bodyRequest: BodyRequestModel? = nil,
        endpointParameters: EndpointParameters? = nil,
        queue: DispatchQueue = .main
    ) async -> ResultType {
        await withCheckedContinuation { continuation in
            perform(queryRequest: queryRequest, bodyRequest: bodyRequest, endpointParameters: endpointParameters, queue: queue) { result in
                continuation.resume(returning: result)
            }
        }
    }
    
    func performFullRequest(
        queryRequest: QueryRequestModel? = nil,
        bodyRequest: BodyRequestModel? = nil,
        endpointParameters: EndpointParameters? = nil,
        queue: DispatchQueue = .main
    ) async -> FullResultType {
        await withCheckedContinuation { continuation in
            performFullRequest(queryRequest: queryRequest, bodyRequest: bodyRequest, endpointParameters: endpointParameters, queue: queue) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
