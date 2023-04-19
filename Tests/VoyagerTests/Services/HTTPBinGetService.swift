@testable import Voyager

protocol HTTPBinGetServiceInterface: HTTPBinService<HTTPBinModel<Empty, Empty>> {}

extension HTTPBinGetServiceInterface {

    var method: HTTPMethod { .get }

    func endpoint() -> String {
        "/get"
    }
}

struct HTTPBinGetService: HTTPBinGetServiceInterface {}


protocol HTTPBinGetServiceWithBodyInterface: HTTPBinGetServiceInterface where BodyRequestModel == GetServiceBody {}
struct HTTPBinGetServiceWithBody: HTTPBinGetServiceWithBodyInterface {}

struct GetServiceBody: NetworkRequest {
    let value: String
}
