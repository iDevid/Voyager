@testable import Voyager

protocol HTTPBinService<ResponseModel>: NetworkService {}

extension HTTPBinService {
    var rootEndpoint: String { "https://httpbin.org" }
}
