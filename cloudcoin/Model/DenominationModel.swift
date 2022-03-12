//
//  DenominationModel.swift
//  cloudcoin
//
//  Created by Moumita China on 30/12/21.
//

import Foundation

class DenominationModel: Codable{
    var deno: Int?
    var amount: Int?
    var selfAmount: Int?
    
    init(deno: Int, amount: Int, selfAmount: Int?=nil){
        self.deno = deno
        self.amount = amount
        self.selfAmount = amount
    }
}
