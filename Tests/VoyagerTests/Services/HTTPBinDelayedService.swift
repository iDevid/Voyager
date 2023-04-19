import Foundation
@testable import Voyager

protocol HTTPBinDelayedServiceInterface: HTTPBinService<HTTPBinModel<Empty, Empty>> where
    EndpointParameters == HTTPBinDelayedServiceParameters {}

extension HTTPBinDelayedServiceInterface {

    var method: HTTPMethod { .get }

    func endpoint(parameters: HTTPBinDelayedServiceParameters) -> String {
        "/delay/\(parameters.delay)"
    }
}

struct HTTPBinDelayedServiceParameters {
    let delay: Int
}

struct HTTPBinDelayedService: HTTPBinDelayedServiceInterface {
    let timeoutInterval: TimeInterval
}
