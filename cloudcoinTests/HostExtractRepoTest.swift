//
//  HostExtractRepoTest.swift
//  cloudcoinTests
//
//  Created by Moumita China on 30/05/22.
//

import XCTest
@testable import cloudcoin

class HostExtractRepoTest: XCTestCase {
    private let networkMonitor = NetworkMonitor.shared

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        try super.tearDownWithError()
    }

    func testHostExtraction() throws {
        if !networkMonitor.isReachable{
            XCTFail("Network connectivity needed for this test.")
        }
        let promise = expectation(description: "All endpoints retrieved")
        let promiseNotMet = expectation(description: "Failure in retieving url's")
        promiseNotMet.isInverted = true
       
        if fetchFromUrl(){
            promise.fulfill()
        }else{
            promiseNotMet.fulfill()
        }
        wait(for: [promise, promiseNotMet], timeout: 5)
    }
    func fetchFromUrl() -> Bool{
        if let url = URL(string: Constants.hostArray[Int.random(in: 0..<Constants.hostArray.count)]){
            print("URL HERE \(url.absoluteString)")
            do {
                _ = try String(contentsOf: url, encoding: .utf8)
                return true
            } catch {
                // contents could not be loaded
                return fetchFromUrl()
            }
        } else {
            // the URL was bad!
            return fetchFromUrl()
        }
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
