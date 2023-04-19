@testable import Voyager

class HTTPBinGetClassService: HTTPBinService {
    
    typealias ResponseModel = HTTPBinModel<Empty, Empty>
    
    var method: HTTPMethod { .get }

    func endpoint() -> String {
        "/get"
    }
}
