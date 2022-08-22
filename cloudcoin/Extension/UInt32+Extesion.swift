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
    }
}
