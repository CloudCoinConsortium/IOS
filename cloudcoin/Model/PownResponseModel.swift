//
//  PownResponseModel.swift
//  cloudcoin
//
//  Created by Moumita China on 13/12/21.
//

import Foundation

struct PownResponseModel{
    var pownResponse = [String?](repeating: nil, count: 25)
    var coin = [PownResponseCoin]()
}
struct PownResponseCoin{
    var pan = [String](repeating: "", count: 25)
    var pown = ""
}


struct PownResponseBinaryModel{
    var pownResponse = [UInt8?](repeating: nil, count: 25)
    var coin = [PownResponseBinaryCoin]()
}
struct PownResponseBinaryCoin{
    var pan = [[UInt8]](repeating: [UInt8](), count: 25)
    var pown = ""
}
