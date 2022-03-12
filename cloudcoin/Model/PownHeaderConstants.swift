//
//  PownHeaderConstants.swift
//  cloudcoin
//
//  Created by Moumita China on 21/12/21.
//

import Foundation

struct PownHeaderConstants{
    //0,0,0,0,0,0,0,0,0,0,0,0,22,22,0,1,0,0,0,0,0,1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,
    //0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    //62,62
    //0,0,0,0,0,0,0,0,0,0,0,0,22,22,0,1,0,0,0,0,0,1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,62,62
    //Header
    let CL = "00" //Cloud id
    let SP = "00" //Split ID
    var RI = "00" //RAIDA ID it will change according to index
    let SH = "00" //SHARD ID
    let CM = "00" //Command
    let CM1 = "00"//"04" //Command 2
    let CVE = "00" //Command Version
    let ID = "00" //Coin ID 1
    let ID2 = "00"//"01" //Coin ID 2
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
    var coins: [Coins]
    /*var SNO = "" //Serial no of coin
    var AN = "" //AN of coin
    var PAN = ""//PAN of coin*/
    //Tail
    let TC = "3e" //Trailing character not written in DOC but it is required
    let TC1 = "3e" //Trailing character not written in DOC but it is required
    
    init(RI: String, coins: [Coins]/*, SNO: String, AN: String, PAN: String*/){
        self.RI = RI
        self.CH0 = self.CH0.indexGenerator(index: 1)
        self.CH1 = self.CH1.indexGenerator(index: 2)
        self.CH2 = self.CH2.indexGenerator(index: 3)
        self.CH3 = self.CH3.indexGenerator(index: 4)
        self.CH4 = self.CH4.indexGenerator(index: 5)
        self.CH5 = self.CH5.indexGenerator(index: 6)
        self.CH6 = self.CH6.indexGenerator(index: 7)
        self.CH7 = self.CH7.indexGenerator(index: 8)
        self.CH8 = self.CH8.indexGenerator(index: 9)
        self.CH9 = self.CH9.indexGenerator(index: 10)
        self.CH10 = self.CH10.indexGenerator(index: 11)
        self.CH11 = self.CH11.indexGenerator(index: 12)
        self.CH12 = self.CH12.indexGenerator(index: 13)
        self.CH13 = self.CH13.indexGenerator(index: 14)
        self.CH14 = self.CH14.indexGenerator(index: 15)
        self.CH15 = self.CH15.indexGenerator(index: 16)
        self.coins = coins
        /*self.SNO = SNO
        self.AN = AN
        self.PAN = PAN*/
    }
   }
struct Coins{
    var SNO = "" //Serial no of coin
    var AN = "" //AN of coin
    var PAN = ""//PAN of coin

    init(SNO: String, AN: String, PAN: String){
        self.SNO = SNO
        self.AN = AN
        self.PAN = PAN
    }
}
struct PownHeaderConstantsBinary{
    //0,0,0,0,0,0,0,0,0,0,0,0,22,22,0,1,0,0,0,0,0,1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,
    //0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    //62,62
    //0,0,0,0,0,0,0,0,0,0,0,0,22,22,0,1,0,0,0,0,0,1,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,62,62
    //Header
    let CL = "00" //Cloud id
    let SP = "00" //Split ID
    var RI = "00" //RAIDA ID it will change according to index
    let SH = "00" //SHARD ID
    let CM = "00" //Command
    let CM1 = "00"//"04" //Command 2
    //let CVE = "00" //Command Version
    let CS = "00" //Check Sum
    let ID = "00" //Coin ID 1
    let ID2 = "01"//"00"//"01" //Coin ID 2
    /*let RE = "00" //Reserved 1
    let RE1 = "00" //Reserved 2
    let RE2 = "00" //Reserved 3*/
    let NO1 = "00"
    let NO2 = "00"
    let NO3 = "00"

    let EC = "ff" //Echo 1
    let EC1 = "ff" //Echo 2
    
    /*let UD = "00" //UDP packet Number 1
    let UD1 = "01" //UDP packet Number 2 ////it will change according to index*/
    
    //total no of UDP packets
    var UD = "00" //UDP packet Number 1
    var UD1 = "01" //UDP packet Number 2 ////it will change according to index

    
    let EN = "00" //Encryption
    let CID = "00" //Coin ID 1
    let CID1 = "00" //Coin ID 1
    let SN = "00" //Serial Number 1
    let SN1 = "00" //Serial Number 2
    let SN2 = "00" //Serial Number 3
    
    init(RI: String){
        self.RI = RI
    }
   }
struct PownBodyGenerator{
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
    var coins: [CoinsBinary]
    //Tail
    let TC = "3e" //Trailing character not written in DOC but it is required
    let TC1 = "3e" //Trailing character not written in DOC but it is required
    
    init(coins: [CoinsBinary]){
        self.coins = coins
    }
}
struct CoinsBinary{
    var SNO = [UInt8](repeating: 0, count: 3)
    var AN = [UInt8](repeating: 0, count: 384)
    var PAN = [UInt8]()
}
extension CoinsBinary{
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
extension Coins{
    func mirrorSelf() -> String{
        let mirror = Mirror(reflecting: self)
        var newStr = String()
        for each in mirror.children{
            newStr.append("\(each.value)")
        }
        return newStr
    }
    func mirrorSelf1() -> [UInt8]{
        let mirror = Mirror(reflecting: self)
        var uintArray = [UInt8]()
        for each in mirror.children{
            if let newStr = each.value as? String{
                if each.label ?? "" == "SNO"{
                    var result = byteArray(from: UInt16(26103))
                    let element : UInt8 = 0
                     while(result.count<3){
                         result.insert(element, at: 0)
                         //result.append(element)
                     }
                    uintArray.append(contentsOf: result)//.reversed())
                }else{
                    uintArray.append(contentsOf: newStr.stringToUInt8Array())
                }
            }
        }
        return uintArray
    }
    func byteArray<T>(from value: T) -> [UInt8] where T: FixedWidthInteger {
        withUnsafeBytes(of: value.littleEndian, Array.init)
    }
}
