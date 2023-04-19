import Voyager

protocol HTTPBinPutAnythingServiceInterface: HTTPBinService where
    ResponseModel == HTTPBinModel<HTTPBinPutAnythingBodyRequest>,
    BodyRequestModel == HTTPBinPutAnythingBodyRequest {}

extension HTTPBinPutAnythingServiceInterface {

    var method: HTTPMethod { .post }
    func endpoint(parameters: EndpointParameters?) -> String {
        "anything"
    }
}

struct HTTPBinPutAnythingService: HTTPBinPutAnythingServiceInterface {}

struct HTTPBinPutAnythingBodyRequest: NetworkRequest, Decodable {
    let test: String
}
