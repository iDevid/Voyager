@testable import Voyager
import Foundation

protocol HTTPBinRemoteCachedServiceInterface: HTTPBinService<HTTPBinModel<Empty, Empty>> {}

extension HTTPBinRemoteCachedServiceInterface {

    func endpoint() -> String {
        "/cache"
    }
}

struct HTTPBinRemoteCachedService: HTTPBinRemoteCachedServiceInterface {}
