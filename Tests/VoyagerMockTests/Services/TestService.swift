@testable import Voyager
@testable import VoyagerMock

protocol TestServiceInterface: NetworkService<TestModel> {}

extension TestServiceInterface {
    var rootEndpoint: String { "http://google.it" }
    
    func endpoint() -> String { "/test" }
}

class TestServiceMock: TestServiceInterface, MockedService {}
