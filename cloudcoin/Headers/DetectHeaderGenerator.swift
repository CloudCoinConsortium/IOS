//
//  DetectHeaderGenerator.swift
//  cloudcoin
//
//  Created by Moumita China on 25/11/21.
//

import Foundation

class DetectHeaderGenerator: NSObject{
    
    static func generateDetectHeader(index: Int, coins: [CoinsWOPan]) -> String?{
        var header: DetectHeaderConstants!
        if index < 10{
            header = DetectHeaderConstants(RI: "0\(index)", coins: coins)
        }else{
            // Decimal to hexadecimal
            let h1 = String(index, radix: 16)
            var newH1 = ""
            if h1.count < 2{
                newH1 = "0\(h1)"
            }else{
                newH1 = h1
            }
            //print("INDEX HERE \(index) \(newH1)") // "3d"
            header = DetectHeaderConstants(RI: newH1, coins: coins)//"0\(index)")*/
        }
        let mirror = Mirror(reflecting: header!)
        var newStr = String()
        for each in mirror.children{
            if let newVal = each.value as? [CoinsWOPan]{
                for each1 in newVal{
                    newStr.append(each1.mirrorSelf())
                }
            }else{
                newStr.append("\(each.value)")
            }
        }
        return newStr
    }
}
struct DetectHeaderConstants{
    //Header
    let CL = "00" //Cloud id
    let SP = "00" //Split ID
    var RI = "00" //RAIDA ID it will change according to index
    let SH = "00" //SHARD ID
    let CM = "00" //Command
    let CM1 = "04" //Command 2
    let CVE = "00" //Command Version
    let ID = "00" //Coin ID 1
    let ID2 = "01" //Coin ID 2
    let RE = "00" //Reserved 1
    let RE1 = "00" //Reserved 2
    let RE2 = "00" //Reserved 3
    let EC = "ff" //Echo 1
    let EC1 = "ff" //Echo 2
    let UD = "00" //UDP packet Number 1
    let UD1 = "01" //UDP packet Number 2 ////it will change according to index
    let EN = "00" //Encryption
    let CID = "00" //Coin ID 1
    let CID1 = "00" //Coin ID 1
    let SN = "00" //Serial Number 1
    let SN1 = "00" //Serial Number 2
    let SN2 = "00" //Serial Number 3
    //Body
    //0,0,0,0,0,0,0,0,0,0,0,0,22,22,0,1,0,0,0,0,0,1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,62,62
    let CH0 = "00"
    let CH1 = "00"
    let CH2 = "00"
    let CH3 = "00"
    let CH4 = "00"
    let CH5 = "00"
    let CH6 = "00"
    let CH7 = "00"
    let CH8 = "00"
    let CH9 = "00"
    let CH10 = "00"
    let CH11 = "00"
    /*var SNO = "" //Serial no of coin
    var AN = "" //AN of coin*/
    var coins: [CoinsWOPan]
    //Tail
    let TC = "3e" //Trailing character not written in DOC but it is required
    let TC1 = "3e" //Trailing character not written in DOC but it is required
    
    init(RI: String, coins: [CoinsWOPan]){//: String, AN: String){
        self.RI = RI
        self.coins = coins
    }
}
struct CoinsWOPan{
    var SNO = "" //Serial no of coin
    var AN = "" //AN of coin

    init(SNO: String, AN: String){
        self.SNO = SNO
        self.AN = AN
    }
}
extension CoinsWOPan{
    func mirrorSelf() -> String{
        let mirror = Mirror(reflecting: self)
        var newStr = String()
        for each in mirror.children{
            newStr.append("\(each.value)")
        }
        return newStr
    }
}
