//
//  NSObject+Extension.swift
//  cloudcoin
//
//  Created by Moumita China on 21/12/21.
//

import Foundation

extension NSObject{
    func createFileName(cloudcoin: CoinModelData) -> String{
        let result = "\(cloudcoin.sn?.getDenomination() ?? "").CloudCoin.\(cloudcoin.nn ?? "").\(cloudcoin.sn ?? "")"
        return result
    }
}
