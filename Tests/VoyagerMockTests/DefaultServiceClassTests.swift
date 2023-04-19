import XCTest
import Voyager
import VoyagerMock

class DefaultServiceClassTests: XCTestCase {
    
    func testNonMockedClassResult() {
        let nonMockedService = HTTPBinGetService()
        let exp = XCTestExpectation()
        nonMockedService.perform { result in
            switch result {
            case .failure(let error):
                XCTFail("Should not fail with error: \(error)")
            case .success(let model):
                XCTAssertEqual(model.url, "https://httpbin.org/get")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }
    
    func testMockedClassResult() {
        let mockedService = HTTPBinGetMockedService()
        mockedService.setNextResponse(.model(.init(origin: "", url: "")))
        let exp = XCTestExpectation()
        mockedService.perform { result in
            switch result {
            case .failure(let error):
                XCTFail("Should not fail with error: \(error)")
            case .success(let model):
                XCTAssertEqual(model.url, "")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10)
    }
}
