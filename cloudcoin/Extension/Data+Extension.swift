//
//  Data+Extension.swift
//  cloudcoin
//
//  Created by Moumita China on 12/11/21.
//

import Foundation

extension Data {
    var hexDescription: String {
        return reduce("") {$0 + String(format: "%02x", $1)}
    }
}
