//
//  PNGDisplayModel.swift
//  cloudcoin
//
//  Created by Moumita China on 09/04/22.
//

import Foundation

struct PNGDisplayModel{
    let shortCC = "CC"
    let longCC = "CloudCoin"
    var deno: Int!
    var denoWord: String!
    var dateString: String!
    let uploadTxt = "Upload this file to your Skywallet \n or POWN it and keep it wherever you want"
    let infoTxt = "More info on Cloudcoin.global"
    
    init(deno: Int){
        self.deno = deno
        self.denoWord = deno.spellOutNumber()
        self.dateString = getDate()
    }
    private func getDate() -> String{
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM/dd/yyyy"
        return dateFormatterPrint.string(from: Date())
    }
}
