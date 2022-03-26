//
//  PownResponseModel.swift
//  cloudcoin
//
//  Created by Moumita China on 13/12/21.
//

import Foundation

struct PownResponseModel{
    var pownResponse = [UInt8?](repeating: nil, count: 25)
    var coin = [PownResponseBinaryCoin]()
}
struct PownResponseBinaryCoin{
    var pan = [[UInt8]](repeating: [UInt8](), count: 25)
    var pown = ""
}
struct PownRequestModel{
    var command = Commands.Pown
    var totalCoins = [UInt8]()
    var pownResponseBinary = PownResponseModel()
}
struct RequestPacket{
    var header = [UInt8]()
    var challenge = [UInt8]()
    var coins = [UInt8]()
}
