//
//  BodyGenerator.swift
//  cloudcoin
//
//  Created by Moumita China on 12/03/22.
//

import Foundation

class BodyGenerator: NSObject{
    static func generateBody(coins: [CoinsBinary]) -> ([UInt8], [UInt8]){
        var allCoin = [UInt8]()
        var challenge = CoinLogic.generateCryptoString(count: 12).stringToUInt8Array()
        let crc32 = CRC32.checksum(bytes: challenge).convertUint32ToUint8()
        challenge.append(contentsOf: crc32)
        
        for coin in coins{
            allCoin.append(contentsOf: coin.SNO)
            allCoin.append(contentsOf: coin.AN)
            if coin.PAN != nil{
                allCoin.append(contentsOf: coin.PAN!)
            }
        }
        return (challenge, allCoin)
    }
}
