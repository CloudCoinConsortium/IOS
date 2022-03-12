//
//  AES.swift
//  cloudcoin
//
//  Created by Moumita China on 11/03/22.
//

import Foundation
import CryptoKit

class AESEncrypt{
    private var key: SymmetricKey!
    func encryptAESGSM(key: [UInt8], array: [UInt8]){
        //let message = Data(base64Encoded: Data(array))//(String(bytes: array, encoding: .utf8) ?? "").data(using: .utf8)
        self.key = SymmetricKey(data: Data(key))
        print("KEY BITS \(self.key.bitCount)")
            let encrypt = try! AES.GCM.seal( Data(array), using: self.key)//AES.GCM.Nonce())
            print("\(encrypt.ciphertext.base64EncodedString()) \(encrypt.nonce.withUnsafeBytes({ Data(Array($0)).base64EncodedString() })) \(encrypt.tag.base64EncodedString())")
        
        // Decrypt
        let sealedBoxRestored = try! AES.GCM.SealedBox(nonce: encrypt.nonce, ciphertext: encrypt.ciphertext, tag: encrypt.tag)
        let decrypted = try! AES.GCM.open(sealedBoxRestored, using: self.key)

        
        print("cryptoDemoCipherText Crypto Demo I\n••••••••••••••••••••••••••••••••••••••••••••••••••\n")
        print("Combined:\n\(encrypt.combined!.base64EncodedString())\n")
        print("Cipher:\n\(encrypt.ciphertext.base64EncodedString())\n")
        print("Nonce:\n\(encrypt.nonce.withUnsafeBytes { Data(Array($0)).base64EncodedString() })\n")
        print("Tag:\n\(encrypt.tag.base64EncodedString())\n")
        print("Decrypted:\n\([UInt8](decrypted))\n")

    }
  
}
