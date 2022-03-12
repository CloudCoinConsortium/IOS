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
    private var hostUDP: NWEndpoint.Host!// = "iperf.volia.net"
    private var portUDP: NWEndpoint.Port!// = 5201
    private var sendString: String = ""
    private var dataArray: [UInt8] = []
    
    init(hostModel: HostModel?=nil, sendString: String, dataArray: [UInt8], completion: @escaping (String) -> ()) {
        // Hack to wait until everything is set up
        //print("IP ADDRESS \(hostModel?.ipAddress ?? NWEndpoint.Host.init("")) \(hostModel?.portNumber ?? NWEndpoint.Port.init("") ?? 0)")
        self.hostUDP = hostModel?.ipAddress ?? NWEndpoint.Host.init("")
        self.portUDP = hostModel?.portNumber ?? NWEndpoint.Port.init("") ?? 0
        self.sendString = sendString
        self.dataArray = dataArray
        connectToUDP(self.hostUDP, self.portUDP, completion: { str in
            completion(str)
        })
    }
    
    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port, completion: @escaping (String) -> ()) {
        // Transmited message:
        let cmd: [UInt8] = [0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xff, 0xff, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x3e, 0x3e]
        let str = "000000000004000000000000ffff00010000000000003e3e"
        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
                
        self.connection?.stateUpdateHandler = { (newState) in
            //print("This is stateUpdateHandler:")
            switch (newState) {
            case .ready:
                //print("State: Ready\n")
                if self.sendString != ""{
                    //print("HEADER HERE\(self.sendString.stringToUInt8Array())")
                    self.sendUDP(Data(self.sendString.stringToUInt8Array()))
                }else{
                    //print("AFTER CONVERSION\(Data(self.dataArray).hexEncodedString())")
                    self.sendUDP(Data(self.dataArray))
                }
                self.receiveUDP(completion: { str in
                    completion(str)
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
    
    func sendUDP(_ content: String) {
        let contentToSendUDP = content.data(using: String.Encoding.utf8)
        self.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                //print("Data was sent to UDP")
            } else {
               // print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }
    
    func receiveUDP(completion: @escaping (String) -> ()) {
        self.connection?.receiveMessage { (data, context, isComplete, error) in
            if (isComplete) {
                //print("Receive is complete")
                if (data != nil) {
                    let hexEncodedStr = data?.hexEncodedString() ?? ""
                    //print("RESPONSE HEX STR \(hexEncodedStr) IP ADDRESS \(self.hostUDP ?? NWEndpoint.Host.init("")) \(self.portUDP ?? NWEndpoint.Port.init("") ?? 0)") // ==> 2525
                    completion(hexEncodedStr)
                } else {
                    //print("Data == nil")
                    completion("")
                }
            }else{
                //print("\(error)")
                completion("notComplete")
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
        /*if strArray.count % 2 == 0{
            for i in stride(from: 0, to: (strArray.count - 1), by: 2) {
                let str = "\(strArray[i])\(strArray[i+1])"
                let byte = UInt8(str, radix: 16) ?? 0
                uintArray.append(byte)
            }
        }else{*/
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
        //}
        //print("UINT ARRAY \(uintArray)")
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
