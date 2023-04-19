//
//  DemoTests.swift
//  DemoTests
//
//  Created by Davide Sibilio on 27/10/22.
//

import Voyager
import XCTest
@testable import Demo

//final class DemoTests: XCTestCase {
//
//    var service: (any DemoService)!
//    
//    override func setUp() {
//        super.setUp()
//        service = DemoServiceMock2()
//    }
//    
//    func testService() {
//        print("hey")
//        let a = XCTestExpectation(description: "test")
//        service.perform { result in
//            switch result {
//            case .success(let model):
//                print(model.model)
//            case .failure(let error):
//                print(error)
//            }
//            a.fulfill()
//        }
//    }
//}
//
//protocol MockService: NetworkService {
//    var jsonFile: String { get }
//}
//
//struct DemoServiceMock2: DemoService {
//
//    var jsonFile: String = "test.json"
//    
//    var request: DemoRequest?
//
//    func perform(queue: DispatchQueue, _ completion: (((ResultType)) -> Void)?) {
//        print("MockedTest")
//    }
//}
