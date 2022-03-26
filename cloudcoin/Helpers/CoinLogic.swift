//
//  CoinLogic.swift
//  cloudcoin
//
//  Created by Moumita China on 26/11/21.
//

import Foundation

class CoinLogic: NSObject{

    static let letters = "abcdefghijklmnopqrstuvwxyz0123456789"

    static func randomString(length: Int = 32) -> String {
        return String((0..<length).map{ _ in CoinLogic.letters.randomElement()! })
    }
    
    static func generateCryptoString(count: Int) -> String{
        var randomBytes = [UInt8](repeating: 0, count: 16)
        let result = Int(SecRandomCopyBytes(kSecRandomDefault, count, &randomBytes))
        if result == 0 {
            var uuidStringReplacement = ""
            for index in 0..<count {
                uuidStringReplacement += String(format: "%02x", randomBytes[index])
            }
            //print("uuidStringReplacement is \(uuidStringReplacement) \(uuidStringReplacement.count)")
            if count == 12{
                return "aaaaaaaaaaaaaaaaaaaaaaaa"
            }
            return "bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb"//"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"//uuidStringReplacement//"bbbaaaaaaaaabbbbbbbbbbbbbbbbbbb"//"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"//uuidStringReplacement //"00000000000000000000000000000000"
        } else {
            print("SecRandomCopyBytes failed for some reason")
            return ""
        }
    }
    
}
