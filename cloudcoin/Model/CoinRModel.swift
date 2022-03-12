//
//  CoinRModel.swift
//  cloudcoin
//
//  Created by Moumita China on 30/12/21.
//

import Foundation
import RealmSwift

class CoinRModel: Object {
    @objc dynamic var id = 0
    @objc dynamic var amount = ""
    @objc dynamic var file_name = ""
    @objc dynamic var denomination = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
