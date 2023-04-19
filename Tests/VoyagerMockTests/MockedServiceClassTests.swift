import XCTest
@testable import Voyager
@testable import VoyagerMock

class MockedServiceClassTests: XCTestCase {
    
    var service: TestServiceClassMock!
    
    override func setUp() {
        super.setUp()
        service = TestServiceClassMock()
    }
    
    func testInjectability() {
        let exp = XCTestExpectation()
        service.setNextResponse(.json(name: "test_1", bundle: Bundle.module))
        let handler: (_ service: TestServiceClass) -> Void = { handlerService in
            handlerService.perform { result in
                switch result {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                case .success(let model):
                    XCTAssert(model.identifier == "Hello!")
                }
                exp.fulfill()
            }
        }
        handler(service)
        wait(for: [exp], timeout: 2)
    }

    func testNextResultJSON() {
        service.setNextResponse(.json(name: "test_1", bundle: Bundle.module))
        
        let exp = XCTestExpectation()
        service.perform { result in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
            case .success(let model):
                XCTAssert(model.identifier == "Hello!")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
    
    func testNextResultJSONError() {
        service.setNextResponse(.json(name: "hello", bundle: Bundle.module))
        
        let exp = XCTestExpectation()
        service.perform { result in
            switch result {
            case .failure(let error):
                guard let error = error.wrappedError as? MockedServiceError else {
                    return
                }
                XCTAssertTrue(error == MockedServiceError.jsonPathNotFounded)

            case .success:
                XCTFail("Impossible")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
    
    func testNextResultError() {
        service.setNextResponse(.failure(NetworkError.genericError(MockError.test)))

        let exp = XCTestExpectation()
        service.perform { result in
            switch result {
            case .failure(let error):
                guard let error = error.wrappedError as? MockError else {
                    XCTFail("Not specific error")
                    return
                }
                XCTAssert(error == MockError.test)
            case .success:
                XCTFail("Should return error")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
    
    func testNextResultModel() {
        let model = TestModel(identifier: "Test")
        service.setNextResponse(.model(model))
        
        let exp = XCTestExpectation()
        service.perform { result in
            switch result {
            case .failure(let error):
                XCTFail(error.localizedDescription)
    
            case .success(let resultModel):
                XCTAssertEqual(resultModel, model)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 2)
    }
    
    func testConsecutiveDifferentResultTypes() {
        service.setNextResponse(.model(TestModel(identifier: "1")))
        let modelExp = XCTestExpectation()
        service.perform { result in
            switch result {
            case .failure:
                XCTFail("Not expected")
            case .success(let model):
                XCTAssertTrue(model == .init(identifier: "1"))
            }
            modelExp.fulfill()
        }
        
        service.setNextResponse(.failure(.genericError(MockError.test)))
        let errorExp = XCTestExpectation()
        service.perform { result in
            switch result {
            case .failure(let error):
                guard let error = error.wrappedError as? MockError else {
                    XCTFail("Not specific error")
                    return
                }
                XCTAssert(error == MockError.test)
            case .success:
                XCTFail("Not Expected")
            }
            errorExp.fulfill()
        }

        service.setNextResponse(.json(name: "test_1", bundle: .module))
        let jsonExp = XCTestExpectation()
        service.perform { result in
            switch result {
            case .failure:
                XCTFail("Not expected")
            case .success(let networkResult):
                XCTAssertTrue(networkResult == .init(identifier: "Hello!"))
            }
            jsonExp.fulfill()
        }

        wait(for: [modelExp, errorExp, jsonExp], timeout: 2, enforceOrder: true)
    }
    
    @available(iOS 13.0, *)
    func testAwaitPerform() async {
        service.setNextResponse(.model(.init(identifier: "2")))
        let result = await service.perform()
        switch result {
        case .success(let resultModel):
            XCTAssertEqual(resultModel.identifier, "2")

        case .failure(let error):
            XCTFail("Should not give an error: \(error)")
        }
    }
}
