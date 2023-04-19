import Voyager

protocol HTTPBinGetServiceInterface: HTTPBinService where ResponseModel == HTTPBinModel<Empty> {}

extension HTTPBinGetServiceInterface {
    var method: HTTPMethod { .get }
    func endpoint(parameters: EndpointParameters?) -> String {
        "get"
    }
}

struct HTTPBinGetService: HTTPBinGetServiceInterface {}

struct HTTPBinModel<JSONModel: Decodable>: Decodable {
    let origin: String
    let url: String
    
    let json: JSONModel?
}

struct Empty: Decodable {}
