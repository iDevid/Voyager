import Voyager

class HTTPBinGetService: NetworkService {
    
    typealias ResponseModel = HTTPBinModel
    
    var rootEndpoint: String { "https://httpbin.org" }
    
    func endpoint() -> String {
        "/get"
    }
}

