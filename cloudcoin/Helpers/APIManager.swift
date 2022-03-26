//
//  APIManager.swift
//  cloudcoin
//
//  Created by Moumita China on 01/11/21.
//

import Network
import Foundation

class APIManager{
    private var connection: NWConnection?
    private var hostUDP: NWEndpoint.Host!
    private var portUDP: NWEndpoint.Port!
    private var dataArray: [UInt8] = []
    
    
    init(hostModel: HostModel?=nil, /*sendString: String,*/ dataArray: [UInt8], completion: @escaping ([UInt8]) -> ()) {
        // Hack to wait until everything is set up
        //print("IP ADDRESS \(hostModel?.ipAddress ?? NWEndpoint.Host.init("")) \(hostModel?.portNumber ?? NWEndpoint.Port.init("") ?? 0)")
        self.hostUDP = hostModel?.ipAddress ?? NWEndpoint.Host.init("")
        self.portUDP = hostModel?.portNumber ?? NWEndpoint.Port.init("") ?? 0
        self.dataArray = dataArray
        connectToUDP(self.hostUDP, self.portUDP, completion: { str in
            completion(str)
        })
    }
    
    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port, completion: @escaping ([UInt8]) -> ()) {
        // Transmited message:
        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
        
        self.connection?.stateUpdateHandler = { (newState) in
            switch (newState) {
            case .ready:
                self.sendUDP(Data(self.dataArray))
                self.receiveUDP(completion: { uintArr in
                    completion(uintArr)
                })
            case .setup:
                print("State: Setup\n")
            case .cancelled:
                print("State: Cancelled\n")
            case .preparing:
                print("State: Preparing\n")
            default:
                print("ERROR! State not defined!\n")
            }
        }
        
        self.connection?.start(queue: .global())
    }
    
    func sendUDP(_ content: Data) {
        self.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                //print("Data was sent to UDP")
            } else {
                //print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }
    func receiveUDP(completion: @escaping ([UInt8]) -> ()) {
        self.connection?.receiveMessage { (data, context, isComplete, error) in
            if error != nil{
                print("HERE1")
                completion([UInt8]())
            }
            if (isComplete) {
                //print("Receive is complete")
                if (data != nil) {
                    let hexEncodedStr = data?.hexEncodedString() ?? ""
                    //print("RESPONSE HEX STR \(hexEncodedStr) IP ADDRESS \(self.hostUDP ?? NWEndpoint.Host.init("")) \(self.portUDP ?? NWEndpoint.Port.init("") ?? 0)") // ==> 2525
                    print("HERE2")
                    completion(hexEncodedStr.stringToUInt8Array())
                } else {
                    //print("Data == nil")
                    print("HERE3")
                    completion([UInt8]())
                }
            }else{
                //print("\(error)")
                print("HERE4")
                completion([UInt8]())
            }
        }
        
    }
}
extension Data {
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return self.map { String(format: format, $0) }.joined()
    }
}
extension String{
    func stringToUInt8Array() -> [UInt8]{
        let newString = self.replacingOccurrences(of: " ", with: "")
        let strArray = Array(newString)
        var uintArray = [UInt8]()
        var i = 0
        while i < strArray.count {
            var str = ""
            if (i + 1) < strArray.count{
                str = "\(strArray[i])\(strArray[i+1])"
            }else{
                str = "\(strArray[i])"
            }
            let byte = UInt8(str, radix: 16) ?? 0
            uintArray.append(byte)
            let remaining = strArray.count - i
            if remaining > 1{
                i += 2
            }else{
                i += 1
            }
        }
        return uintArray
    }
}
extension String{
    func convertTo3ByteArray(_ s: Int)-> [UInt8]{
        var ret: [UInt8] = Array(repeating: 0, count: 3)
        ret[0] = UInt8((s & 255))
        ret[1] = UInt8(((s >> 8) & 255))
        ret[2] = UInt8((0))
        return ret
    }
}
