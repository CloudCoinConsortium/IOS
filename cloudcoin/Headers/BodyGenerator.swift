//
//  BodyGenerator.swift
//  cloudcoin
//
//  Created by Moumita China on 12/03/22.
//

import Foundation

class BodyGenerator: NSObject{
    static func generateBody(coins: [CoinsBinary]) -> [UInt8]{
        var body = [UInt8]()
        body.append(contentsOf: CoinLogic.generateCryptoString(count: 12).stringToUInt8Array())
        let crc32 = CRC32.checksum(bytes: Array(body[0...11])).convertUint32ToUint8()
        body.append(contentsOf: crc32)
        for coin in coins{
            body.append(contentsOf: coin.SNO)
            body.append(contentsOf: coin.AN)
            if coin.PAN != nil{
                body.append(contentsOf: coin.PAN!)
            }
        }
        return body
    }
}
