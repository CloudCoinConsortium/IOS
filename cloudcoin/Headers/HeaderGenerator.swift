//
//  HeaderGenerator.swift
//  cloudcoin
//
//  Created by Moumita China on 20/11/21.
//

import Foundation

class HeaderGenerator: NSObject{
    static func generateHeader(index: UInt8, commandType: UInt8, udpNo: UInt8, nonce: [UInt8]?=nil, serialNo: [UInt8]?=nil) -> [UInt8]{
        var header = [UInt8](repeating: 0, count: 22)
        let command = Commands(rawValue: Int(commandType))
        header[0] = 0
        header[1] = 0
        header[2] = index
        header[3] = 0
        header[4] = 0
        header[5] = commandType
        header[6] = 0
        header[7] = 0
        header[8] = 0
        header[9] = nonce?[0] ?? 0
        header[10] = nonce?[1] ?? 0
        header[11] = nonce?[2] ?? 0
        header[12] = 255
        header[13] = 255
        header[14] = 0
        header[15] = udpNo
        header[16] = serialNo?.count == 3 && nonce?.count == 3 ? 1 : 0
        header[17] = 0
        header[18] = 0
        header[19] = serialNo?[0] ?? 0
        header[20] = serialNo?[1] ?? 0
        header[21] = serialNo?[2] ?? 0
        if command == .Echo{
            header.append(contentsOf: Constants.trailing)
        }
        return header
    }
}

