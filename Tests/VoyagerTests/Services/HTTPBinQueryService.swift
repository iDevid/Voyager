@testable import Voyager

protocol HTTPBinQueryServiceInterface: HTTPBinService<HTTPBinModel<Empty, HTTPBinQueryQueryRequest>> where
    QueryRequestModel == HTTPBinQueryQueryRequest {}

extension HTTPBinQueryServiceInterface {

    var method: HTTPMethod { .get }

    func endpoint() -> String {
        "/anything"
    }
}

struct HTTPBinQueryService: HTTPBinQueryServiceInterface {}

struct HTTPBinQueryQueryRequest: NetworkRequest, Decodable, Equatable {
    let testString: String
    let testStringArray: [String]?

    @IgnoreCoding var queryRequestArrayEncoding: QueryRequestArrayEncoding?
    
    static func == (lhs: HTTPBinQueryQueryRequest, rhs: HTTPBinQueryQueryRequest) -> Bool {
        lhs.testString == rhs.testString &&
        lhs.testStringArray == rhs.testStringArray
    }
}
