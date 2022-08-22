//
//  HostExtractRepo.swift
//  cloudcoin
//
//  Created by Moumita China on 01/11/21.
//

import Network
import Foundation

class HostExtractRepo{
     
    
    static func getHostArray() -> [HostModel]?{
        if let url = URL(string: Constants.hostArray[Int.random(in: 0..<Constants.hostArray.count)]){
            print("URL HERE \(url.absoluteString)")
            do {
                let contents = try String(contentsOf: url, encoding: .utf8)
                return contents.stringHelper()
            } catch {
                // contents could not be loaded
                print("contents could not be loaded")
                return getHostArray()
            }
        } else {
            // the URL was bad!
            print("the URL was bad!")
            return getHostArray()
        }
    }
}
