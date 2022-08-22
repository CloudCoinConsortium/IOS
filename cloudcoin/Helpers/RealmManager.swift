//
//  RealmManager.swift
//  cloudcoin
//
//  Created by Moumita China on 30/12/21.
//

import Foundation
import RealmSwift

class RealmManager: NSObject{
    private static let realm = try! Realm()
    
    private static func nextId() -> Int {
        return (RealmManager.realm.objects(CoinRModel.self).map{$0.id}.max() ?? 0) + 1
        
    }
    private static func nextIdTrans() -> Int {
        return (RealmManager.realm.objects(TransactionRModel.self).map{$0.id}.max() ?? 0) + 1
        
    }
    static func addCoinRModel(directoryModel: DirectoryBinaryModel, completionHandler: @escaping(Bool?, CoinRModel?) -> ()){
        do{
            try realm.safeWrite { // 2
                let coinRdata = CoinRModel()// 3
                coinRdata.id = RealmManager.nextId() // 4
                coinRdata.amount = "1"
                coinRdata.denomination = 1
                coinRdata.file_name = directoryModel.fileName
                coinRdata.directory_name = directoryModel.directory
                realm.add(coinRdata) // 5
                completionHandler(true, coinRdata)
            }
        }catch{
            completionHandler(false, nil)
        }
    }
    static func addTransactionRModel(amount: String?, memo: String?, completionHandler: @escaping(Bool?) -> ()){
        do{
            try realm.safeWrite { // 2
                let coinRdata = TransactionRModel() // 3
                coinRdata.id = nextIdTrans() // 4
                coinRdata.date = Date().timeIntervalSince1970
                coinRdata.memo = memo ?? "Amount deposited"
                coinRdata.type = 1
                coinRdata.amount = amount ?? "1"
                realm.add(coinRdata) // 5
            }
            completionHandler(true)
        }catch{
            completionHandler(false)
        }
    }
    static func deleteAllTransactionRModel(){
        do{
            try realm.safeWrite { // 2
                if let transaction = getAllTransactionRModel(){
                    realm.delete(transaction)
                }
            }
        }catch{
            
        }
    }
    static func getAllTransactionRModel() -> Results<TransactionRModel>?{
        let transactionData = realm.objects(TransactionRModel.self)
        return transactionData
    }
    static func getAllCoinRModel() -> [DenominationModel?]?{
        return RealmManager.separateAllDenomination(results: realm.objects(CoinRModel.self))
    }
    private static func separateAllDenomination(results: Results<CoinRModel>) -> [DenominationModel?]?{
        var denoArry : [DenominationModel?] = [DenominationModel(deno: 1, amount: 0), DenominationModel(deno: 5, amount: 0), DenominationModel(deno: 25, amount: 0, selfAmount: 0), DenominationModel(deno: 100, amount: 0), DenominationModel(deno: 250, amount: 0)]
        var a0 = 0, a1 = 0, a2 = 0, a3 = 0, a4 = 0

        for i in 0..<results.count{
            if results[i].denomination == 1{
                a0 += 1
                denoArry[0] = DenominationModel(deno: 1, amount: a0)
            }else if results[i].denomination == 5{
                a1 += 1
                denoArry[1] = DenominationModel(deno: 5, amount: a1)
            }else if results[i].denomination == 25{
                a2 += 1
                denoArry[2] = DenominationModel(deno: 25, amount: a2)
            }else if results[i].denomination == 100{
                a3 += 1
                denoArry[3] = DenominationModel(deno: 100, amount: a3)
            }else if results[i].denomination == 250{
                a4 += 1
                denoArry[4] = DenominationModel(deno: 250, amount: a4)
            }
        }
        return denoArry
    }
    static func getFileName(denoModel: [DenominationModel?]) -> [CoinRModel]?{
        var coins = [CoinRModel]()
        for i in 0..<denoModel.count{
            if denoModel[i]?.selfAmount ?? 0 > 0{
                let coin = realm.objects(CoinRModel.self).filter("denomination == %@", denoModel[i]?.deno ?? 0)
                let array : [CoinRModel] = Array(coin[0..<(denoModel[i]?.selfAmount ?? 0)])
                coins.append(contentsOf: array)
            }
        }
        return coins
    }
    static func getStackFilename(denoModel: [DenominationModel?]) -> [[CoinRModel]]?{
        var coins = [[CoinRModel]]()
        coins.reserveCapacity(5)
        for i in 0..<denoModel.count{
            coins.append([])
            if denoModel[i]?.selfAmount ?? 0 > 0{
                let coin = realm.objects(CoinRModel.self).filter("denomination == %@", denoModel[i]?.deno ?? 0)
                let array : [CoinRModel] = Array(coin[0..<(denoModel[i]?.selfAmount ?? 0)])
                if denoModel[i]?.deno == 1{
                    coins[0].append(contentsOf: array)
                }else if denoModel[i]?.deno == 5{
                    coins[1] = array
                }else if denoModel[i]?.deno == 25{
                    coins[2] = array
                }else if denoModel[i]?.deno == 100{
                    coins[3] = array
                }else if denoModel[i]?.deno == 250{
                    coins[4] = array
                }
            }
        }
        return coins
    }
    static func deleteCoinRModel(coin: CoinRModel){
        do{
            try realm.safeWrite { // 2
                realm.delete(coin) // 5
            }
        }catch{
            print(error)
        }
    }
}
extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
