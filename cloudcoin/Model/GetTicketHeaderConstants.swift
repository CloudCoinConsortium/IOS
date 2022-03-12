//
//  GetTicketHeaderConstants.swift
//  cloudcoin
//
//  Created by Moumita China on 11/03/22.
//

import Foundation

struct GetTicketBody{
    //Body
    //0,0,0,0,0,0,0,0,0,0,0,0,22,22,0,1,0,0,0,0,0,1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,62,62
    var CH0 = "01"
    var CH1 = "02"
    var CH2 = "03"
    var CH3 = "04"
    var CH4 = "05"
    var CH5 = "06"
    var CH6 = "07"
    var CH7 = "08"
    var CH8 = "09"
    var CH9 = "10"
    var CH10 = "11"
    var CH11 = "12"
    var CH12 = "13"
    var CH13 = "14"
    var CH14 = "15"
    var CH15 = "16"
    var coins: [CoinsWOPanBinary]
    //Tail
    let TC = "3e" //Trailing character not written in DOC but it is required
    let TC1 = "3e" //Trailing character not written in DOC but it is required
    
    init(coins: [CoinsWOPanBinary]){
        self.coins = coins
    }
}

struct CoinsWOPanBinary{
    var SNO = [UInt8](repeating: 0, count: 3)
    var AN = [UInt8](repeating: 0, count: 384)
}
extension CoinsWOPanBinary{
    func mirrorSelf() -> [UInt8]{
        let mirror = Mirror(reflecting: self)
        var uintArray = [UInt8]()
        for each in mirror.children{
            if let newArray = each.value as? [UInt8]{
                uintArray.append(contentsOf: newArray)
            }
        }
        return uintArray
    }
}
