//
//  TransactionRModel.swift
//  cloudcoin
//
//  Created by Moumita China on 30/12/21.
//

import Foundation
import RealmSwift

class TransactionRModel: Object {
    @objc dynamic var id = 0
    @objc dynamic var date: TimeInterval = 0.0
    @objc dynamic var memo = ""
    @objc dynamic var type = 0
    @objc dynamic var amount = ""
    
    override static func primaryKey() -> String? {
            return "id"
        }
}
