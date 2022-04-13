//
//  Int+Extension.swift
//  cloudcoin
//
//  Created by Moumita China on 09/04/22.
//

import Foundation

extension Int{
    func spellOutNumber() -> String{
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.spellOut
        return formatter.string(for: self) ?? ""
    }
}
