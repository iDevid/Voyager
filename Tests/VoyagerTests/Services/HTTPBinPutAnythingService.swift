@testable import Voyager

protocol HTTPBinPutAnythingServiceInterface: HTTPBinService<HTTPBinModel<HTTPBinPutAnythingBodyRequest, Empty>> where
    BodyRequestModel == HTTPBinPutAnythingBodyRequest {}

extension HTTPBinPutAnythingServiceInterface {

    var method: HTTPMethod { .post }

    func endpoint() -> String {
        "/anything"
    }
}

struct HTTPBinPutAnythingService: HTTPBinPutAnythingServiceInterface {}

struct HTTPBinPutAnythingBodyRequest: NetworkRequest, Decodable, Equatable {
    let test: String
}
