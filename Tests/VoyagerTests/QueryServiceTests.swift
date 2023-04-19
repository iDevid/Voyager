import XCTest
@testable import Voyager

class QueryServiceTests: XCTestCase {
    
    func testSimpleQueryPath() {
        let service = HTTPBinQueryService()
        let url = service.getURL(queryRequest: .init(testString: "Hey!", testStringArray: nil, queryRequestArrayEncoding: .default))
        XCTAssertEqual(url?.absoluteString, "https://httpbin.org/anything?testString=Hey!")
    }
    
    func testArrayQueryPathWithParenthesisEncoding() {
        let service = HTTPBinQueryService()
        let url = service.getURL(queryRequest: .init(testString: "Hey!", testStringArray: ["Hello", "World"], queryRequestArrayEncoding: .parenthesis))
        guard let url else {
            XCTFail("Should be not nil")
            return
        }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertTrue(components?.queryItems?.contains(where: { $0.name == "testString" && $0.value == "Hey!"}) ?? false)
        XCTAssertTrue(components?.queryItems?.contains(where: { $0.name == "testStringArray[]" && $0.value == "Hello"}) ?? false)
        XCTAssertTrue(components?.queryItems?.contains(where: { $0.name == "testStringArray[]" && $0.value == "World"}) ?? false)
    }
    
    func testArrayQueryPathWithDefaultEncoding() {
        let service = HTTPBinQueryService()
        let url = service.getURL(queryRequest: .init(testString: "Hey!", testStringArray: ["Hello", "World"]))
        guard let url else {
            XCTFail("Should be not nil")
            return
        }
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        XCTAssertTrue(components?.queryItems?.contains(where: { $0.name == "testString" && $0.value == "Hey!"}) ?? false)
        XCTAssertTrue(components?.queryItems?.contains(where: { $0.name == "testStringArray" && $0.value == "Hello"}) ?? false)
        XCTAssertTrue(components?.queryItems?.contains(where: { $0.name == "testStringArray" && $0.value == "World"}) ?? false)
    }
    
    func testQueryServiceResponse() {
        let service = HTTPBinQueryService()
        let expectation = XCTestExpectation()
        let query = HTTPBinQueryQueryRequest(testString: "Hello!", testStringArray: ["Foo", "Bar"])
        service.perform(queryRequest: query) { result in
            switch result {
            case .failure:
                XCTFail()
            case .success(let model):
                XCTAssertEqual(model.args, query)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    
}
