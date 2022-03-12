//
//  PNG.swift
//  cloudcoin
//
//  Created by Moumita China on 27/02/22.
//

import Foundation

class PNG{
    private let first8Bytes: [UInt8] = [137, 80, 78, 71, 13, 10, 26, 10]
    
    init(pngData: [UInt8]){
        if pngData.count > 33 && Array(pngData[0...7]) == first8Bytes{
            print("IT IS PNG ignore next 25 bytes which is IHDR")
            //print("HELLO TYPE \(depictTypes(data: pngData))")
            
        }else{
            print("IT IS NOT PNG")
        }
    }
    private func checkForCldc(data: [UInt8]){
        var i = 0
        repeat{
            /*if let lenArray = Array(data[i...(i+3)]){
                
            }*/
            
        } while i < data.count
    }
    private func depictTypes(data: [UInt8]) -> String{
        let abc = String(data: Data(data), encoding: .ascii)
        return abc ?? ""
        /*var char = [Character]()
        for each in data{
            let hex = String(each, radix: 16)
            let ascii = Character(Unicode.Scalar(hex) ?? Unicode.Scalar(0))
            char.append(ascii)
            //newStr.append(contentsOf: "\u{\(str)}")
        }
        return String(char)*/
    }
}
