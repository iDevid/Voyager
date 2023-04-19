import XCTest
import Voyager

class DelayedServiceTests: XCTestCase {
    
    func testDelayedResponseWithError() {
        let expectation = XCTestExpectation()
        let service: some HTTPBinDelayedServiceInterface = HTTPBinDelayedService(timeoutInterval: 1)
        service.perform(endpointParameters: .init(delay: 10)) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual((error.wrappedError as? NSError)?.code, NSURLErrorTimedOut)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
    }
}
