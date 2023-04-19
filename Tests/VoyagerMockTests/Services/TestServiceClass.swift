@testable import Voyager
@testable import VoyagerMock

class TestServiceClass: NetworkService {

    typealias ResponseModel = TestModel
    
    var rootEndpoint: String { "http://google.it" }
    
    func endpoint() -> String { "/test" }
}

class TestServiceClassMock: TestServiceClass, MockedService {}
