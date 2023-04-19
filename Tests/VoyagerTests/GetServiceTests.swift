import XCTest
@testable import Voyager

class GetServiceTests: XCTestCase {
    
    func testGetService() {
        let expectation = XCTestExpectation()
        let service: some HTTPBinGetServiceInterface = HTTPBinGetService()
        service.perform { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(model.url, service.getURLPath())
            case .failure(let error):
                XCTFail("Network Perform should not fail with \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testFullResponseGetService() {
        let expectation = XCTestExpectation()
        let service: some HTTPBinGetServiceInterface = HTTPBinGetService()
        service.performFullRequest { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.model.url, service.getURLPath())
                XCTAssertEqual(response.headers["Content-Type"] as? String, "application/json")
            case .failure(let error):
                XCTFail("Network Perform should not fail with \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testGetServiceWithBody() {
        let expectation = XCTestExpectation()
        let service: some HTTPBinGetServiceWithBodyInterface = HTTPBinGetServiceWithBody()
        service.perform(bodyRequest: GetServiceBody(value: "Hello!")) { result in
            switch result {
            case .success:
                XCTFail("Should not succed")
            case .failure(let error):
                XCTAssertEqual(error, .invalidMethod("GET Method could not be used with a Body Request"))
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
    
    func testGetClassService() {
        let expectation = XCTestExpectation()
        let service: HTTPBinGetClassService = HTTPBinGetClassService()
        service.perform { result in
            switch result {
            case .success(let model):
                XCTAssertEqual(model.url, service.getURLPath())
            case .failure(let error):
                XCTFail("Network Perform should not fail with \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
