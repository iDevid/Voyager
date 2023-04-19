import Voyager

protocol HTTPBinService: NetworkService {}
extension HTTPBinService {
    var rootEndpoint: String { "https://httpbin.org/" }
}
