//
//  DirectoryModel.swift
//  cloudcoin
//
//  Created by Moumita China on 18/12/21.
//

import Foundation

struct DirectoryModel{
    var fileName: String
    var fileExt: String
    var data: CoinModel
    var directory: String
}
struct DirectoryBinaryModel{
    var fileName: String
    var fileExt: String
    var data: [UInt8]
    var directory: String
}
