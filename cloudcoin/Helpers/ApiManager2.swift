//
//  ApiManager2.swift
//  cloudcoin
//
//  Created by Moumita China on 20/11/21.
//

import Foundation

class APIManager2{
    var client: UDPClient?
    
    init(hostModel: HostModel?=nil) {
        //print("IP ADDRESS \(hostModel?.ipAddress ?? NWEndpoint.Host.init("")) \(hostModel?.portNumber ?? NWEndpoint.Port.init("") ?? 0)")
        //self.hostUDP = hostModel?.ipAddress ?? NWEndpoint.Host.init("")
        //self.portUDP = hostModel?.portNumber ?? NWEndpoint.Port.init("") ?? 0
        //connectToUDP(self.hostUDP, self.portUDP)
        client = UDPClient(address: "87.120.8.249", port: 30000)
        let cmd: [UInt8] = [0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3e, 0x3e]
        // let result = client?.send(data: cmd)
        //result.
        
        switch client?.send(data: cmd) {
        case .success:
            //return readResponse(from: client)
            print("SUCCESS BLOCK \(readResponse(from: client!))")
        case .failure(let error):
            //appendToTextField(string: String(describing: error))
            print("ERROR BLOCK \(error)")
        default:
            print("DEFAULT BLOCK")
        }
    }
    private func readResponse(from client: UDPClient) -> String? {
//        guard let response = client.recv(<#T##expectlen: Int##Int#>) else { return nil }
        
       // return String(bytes: response, encoding: .utf8)
        return nil
    }
}
