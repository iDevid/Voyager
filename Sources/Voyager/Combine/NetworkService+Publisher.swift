import Combine
import Foundation

@available(iOS 13.0, *)
@available(macOS 10.15, *)
public extension NetworkService {
    
    func publisher(
        queryRequest: QueryRequestModel? = nil,
        bodyRequest: BodyRequestModel? = nil,
        endpointParameters: EndpointParameters? = nil,
        queue: DispatchQueue = .main
    ) -> some Publisher<ResponseModel, ErrorType> {
        fullResponsePublisher(
            queryRequest: queryRequest,
            bodyRequest: bodyRequest,
            endpointParameters: endpointParameters,
            queue: queue
        ).map { $0.model }
    }

    func fullResponsePublisher(
        queryRequest: QueryRequestModel? = nil,
        bodyRequest: BodyRequestModel? = nil,
        endpointParameters: EndpointParameters? = nil,
        queue: DispatchQueue = .main
    ) -> some Publisher<FullResponseModel, ErrorType> {
        let consumer = PassthroughSubject<FullResponseModel, ErrorType>()
        performFullRequest(queryRequest: queryRequest, bodyRequest: bodyRequest, endpointParameters: endpointParameters, queue: queue) { result in
            switch result {
            case .failure(let error):
                consumer.send(completion: .failure(error))

            case .success(let response):
                consumer.send(response)
            }
            consumer.send(completion: .finished)
        }
        return consumer
    }
}
