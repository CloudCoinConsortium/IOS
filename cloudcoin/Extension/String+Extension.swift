//
//  String+Extension.swift
//  cloudcoin
//
//  Created by Moumita China on 18/12/21.
//

import Foundation

extension String{
    func getDenomination() -> String {
        let digit = Int(self) ?? 0
        if (digit < 1 ){
            return "0"
        }
        else if (digit < 2097153){
            return "1"
        }
        else if (digit < 4194305){
            return "5"
        }
        else if (digit < 6291457){
            return "25"
        }
        else if (digit < 14680065){
            return "100"
        }
        else if (digit < 16777217){
            return "250"
        }
        return "0"
    }
    func generateSN() -> String {
        let denomination = Int(self) ?? 0
        switch denomination {
        case 1:
            return String(Int.random(in: 1..<2097153))
        case 5:
            return String(Int.random(in: 2097153..<4194305))
        case 25:
            return String(Int.random(in: 4194305..<6291457))
        case 100:
            return String(Int.random(in: 6291457..<14680065))
        case 250:
            return String(Int.random(in: 14680065..<16777217))
        default:
            return "0"
        }
    }
}
extension String{
    func indexGenerator(index: Int) -> String{
        let h1 = String(index, radix: 16)
        var newH1 = ""
        if h1.count < 2{
            newH1 = "0\(h1)"
        }else{
            newH1 = h1
        }
        return newH1
    }
}
