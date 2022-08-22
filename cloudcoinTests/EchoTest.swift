//
//  EchoTest.swift
//  cloudcoinTests
//
//  Created by Moumita China on 30/05/22.
//

import XCTest
@testable import cloudcoin

class EchoTest: XCTestCase {
    
    private let hostModelArray: [HostModel] = HostExtractRepo.getHostArray() ?? [HostModel]()
    private let networkMonitor = NetworkMonitor.shared
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        if !networkMonitor.isReachable{
            XCTFail("Network connectivity needed for this test.")
        }
        if hostModelArray.isEmpty{
            XCTFail("Host endpoints could not be retrieved")
        }
        let promise = expectation(description: "Echo is complete")
        let promiseNotMet = expectation(description: "Echo is not complete")
        promiseNotMet.isInverted = true
        
        var p = 0, f = 0, n = 0
        let group = DispatchGroup()
        
        for i in 0..<25{
            group.enter()
            let arr = HeaderGenerator.generateHeader(index: UInt8(i), commandType: UInt8(Commands.Echo.magicFunction()), udpNo: 1)
            _ = APIManager(hostModel: self.hostModelArray[i], dataArray: arr, completion: { uintArr in
                if uintArr.isEmpty{
                   n += 1
                }else{
                    if uintArr[2] == 250{
                        p += 1
                    }else{
                        f += 1
                    }
                }
                group.leave()
            })
        }
        group.notify(queue: DispatchQueue.global()) {
            if p == 25{
                promise.fulfill()
            }else if f > 0{
                promiseNotMet.fulfill()
            }else if n > 0{
                promiseNotMet.fulfill()
            }
            print("INSIDE PASS \(p) FAIL \(f) NO ANSWER \(n)")
        }
        
        print("PASS \(p) FAIL \(f) NO ANSWER \(n)")
        wait(for: [promise, promiseNotMet], timeout: 10.0)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
