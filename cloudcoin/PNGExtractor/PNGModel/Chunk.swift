//
//  Chunk.swift
//  cloudcoin
//
//  Created by Moumita China on 27/02/22.
//

import Foundation

struct Chunk{
    var length: Int
    var ctType: String
    var data: [UInt8]
    var crc32: [UInt8]
}
