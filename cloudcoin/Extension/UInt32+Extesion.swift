//
//  UInt32+Extesion.swift
//  cloudcoin
//
//  Created by Moumita China on 10/03/22.
//

import UIKit
import Foundation

extension UInt32{
    func convertUint32ToUint8() -> [UInt8]{
        let byteArray = withUnsafeBytes(of: self.bigEndian) {
            Array($0)
        }
        return byteArray
        /*var result = [UInt8](repeating: 0, count: 4)

        result[0] = UInt8((self & 0x000000ff))
        result[1] = UInt8((self & 0x0000ff00) >> 8)
        result[2] = UInt8((self & 0x00ff0000) >> 16)
        result[3] = UInt8((self & 0xff000000) >> 24)
        
        return result*/
    }
}
