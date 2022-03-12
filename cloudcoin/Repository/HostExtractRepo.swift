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
        if let url = URL(string: Constants.API.hostTxt){
            do {
                let contents = try String(contentsOf: url, encoding: .utf8)
                return HostExtractRepo.stringHelper(contents: contents)
            } catch {
                // contents could not be loaded
                print("contents could not be loaded")
                return nil
            }
        } else {
            // the URL was bad!
            print("the URL was bad!")
            return nil
        }
    }
    private static func stringHelper(contents: String) -> [HostModel]{
        var hostModels = [HostModel]()
        let lines = contents.split(whereSeparator: \.isNewline)
        for i in 2..<27{
            let (host, port) = HostExtractRepo.stringSplitSubHelper(text: String(lines[i]))
            hostModels.append(HostModel(ipAddress: host, portNumber: port))
        }
        return hostModels
    }
    private static func stringSplitSubHelper(text: String)-> ( NWEndpoint.Host,  NWEndpoint.Port){
        let arrayString = text.components(separatedBy: ":")
        let secSubArray = arrayString[1].components(separatedBy: " ")
        return (NWEndpoint.Host.init(arrayString[0]), NWEndpoint.Port.init(secSubArray[0]) ?? 0)
       // return (arrayString[0], secSubArray[0])
    }
}
