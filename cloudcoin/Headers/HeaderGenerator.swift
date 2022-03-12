//
//  HeaderGenerator.swift
//  cloudcoin
//
//  Created by Moumita China on 20/11/21.
//

import Foundation

class HeaderGenerator: NSObject{
    
    static func generateEchoHeader(index: Int) -> String?{
        var header: HeaderConstants!
        if index < 10{
            header = HeaderConstants(RI: "0\(index)")
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
            header = HeaderConstants(RI: newH1)//"0\(index)")*/
        }
        let mirror = Mirror(reflecting: header!)
        var newStr = String()
        for each in mirror.children{
            newStr.append("\(each.value)")
        }
        //print("NEW STRING \(newStr)")
        return newStr
    }
}
struct HeaderConstants{
    let CL = "00" //Cloud id
    let SP = "00" //Split ID
    var RI = "00" //RAIDA ID it will change according to index
    let SH = "00" //SHARD ID
    let CM = "00" //Command
    let CM1 = "04" //Command 2
    
    let CVE = "00" //Command Version
    
    let ID = "00" //Coin ID 1
    let ID2 = "00" //Coin ID 2
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
    let TC = "3e" //Trailing character not written in DOC but it is required
    let TC1 = "3e" //Trailing character not written in DOC but it is required
    
    init(RI: String){
        self.RI = RI
    }
   }
