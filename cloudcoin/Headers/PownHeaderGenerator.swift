//
//  PownHeaderGenerator.swift
//  cloudcoin
//
//  Created by Moumita China on 25/11/21.
//

import Foundation
import CryptoKit

class PownHeaderGenerator: NSObject{
    private var totalAmoumt = 0
    
    private var hostModelArray: [HostModel]?
    private var uintArray = [UInt8]()
    private var totalArray = [UInt8]()
    
    private var finalCoinArrray = [UInt8]()
    private var pownResponseBinary = PownResponseBinaryModel()
    
    convenience init(hostModelArray: [HostModel]?, uintArray: [UInt8]?=nil) {
        self.init()
        self.hostModelArray = hostModelArray
        if let uintArray = uintArray {
            self.totalArray = uintArray
            self.pownResponseBinary.coin = [PownResponseBinaryCoin](repeating: PownResponseBinaryCoin(), count: self.totalArray.count/448)
            generateHeaderBinaryFiles(command: Commands.POWN)
        }
    }
    private func generateHeaderBinaryFiles(command: Commands){
        for i in 0..<25{
            var SNO = [UInt8](), PAN: [UInt8]?, AN = [UInt8]()
            var coins = [CoinsBinary]()
            for j in stride(from: 0, to: totalArray.count, by: 448) {
                self.uintArray = Array(self.totalArray[j...(j+448-1)])
                let arraySlice = uintArray[32...34]
                SNO = Array(arraySlice)
                let arraySlice1 = uintArray[48...(448 - 1)]
                let array1 = Array(arraySlice1)
                let newIndex = i * 16
                let newArraySlice1 = array1[newIndex...(newIndex + 15)]
                AN = Array(newArraySlice1)
                if command == .POWN{
                    PAN = [UInt8]()
                    PAN = CoinLogic.generateCryptoString(count: 16).stringToUInt8Array()
                    self.pownResponseBinary.coin[j].pan[i] = PAN ?? [UInt8]()
                }
                coins.append(CoinsBinary(SNO: SNO, AN: AN, PAN: PAN))
            }
            pownAction(index: i, coins: coins)
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.decidePassFailBinary()
        })
    }
    private func pownAction(index: Int, coins: [CoinsBinary]){
        var udpNo = coins.count/Constants.maxCoins
        udpNo = udpNo == 0 ? 1 : udpNo
        
        for i in stride(from: 0, through: coins.count, by: Constants.maxCoins){
            let newIndex = i * Constants.maxCoins
            let newCoins = Array(coins[newIndex..<Swift.min(newIndex + Constants.maxCoins, coins.count)])
            let uintArray = generatePownHeaderForBinary(index: index, coins: newCoins, udpNo: udpNo)
            let _ = APIManager(hostModel: hostModelArray?[index], dataArray: uintArray, completion: { uintArr in
                print("POWN RESPONSE \(uintArr)")
                if !uintArr.isEmpty && uintArr[2] == 241{
                    let returnIndex = Int(uintArr[0])
                    self.pownResponseBinary.pownResponse[returnIndex] = uintArr[2]
                }
            })
        }
    }
    private func decidePassFailBinary(){
        for i in 0..<pownResponseBinary.coin.count{
            var pass = 0, fail = 0
            let coinIndex = i * 448
            self.uintArray = Array(self.totalArray[coinIndex...(coinIndex+448-1)])
            let arraySlice1 = uintArray[48...(448 - 1)]
            var newArray = Array(arraySlice1)
            for j in 0..<25{
                let pownResponse = pownResponseBinary.pownResponse[j]
                if pownResponse == nil{
                    
                }else if pownResponse == 241{
                    pass += 1
                    let newIndex = j * 16
                    newArray.replaceSubrange(Range(newIndex...(newIndex + 15)), with: pownResponseBinary.coin[i].pan[j])
                    
                }else if pownResponse == 242{
                    fail += 1
                }
            }
            uintArray.replaceSubrange(Range(48...(448 - 1)), with: newArray)
            if pass == 25{
                saveBinaryCoins(newCoin: uintArray)
            }
        }
    }
    private func saveBinaryCoins(newCoin: [UInt8]){
        let array = Array(newCoin[32...34])
        let data = Data(array)
        let value = UInt32(bigEndian: data.withUnsafeBytes { $0.pointee })
        
        let directoryModel = DirectoryBinaryModel(fileName: "\(value)", fileExt:  CreateDirectory.binName, data: newCoin, directory: CreateDirectory.bankName)
        RealmManager.addCoinRModel(fileName: "\(value)") { completed, coin in
            let _ = CreateDirectory(directoryModel: directoryModel)
        }
    }
    private func generatePownHeaderForBinary(index: Int, coins: [CoinsBinary], udpNo: Int) -> [UInt8]{
        var uintArray = HeaderGenerator.generateHeader(index: UInt8(index), commandType: UInt8(Commands.POWN.magicFunction()), udpNo: UInt8(udpNo))
        uintArray.append(contentsOf: BodyGenerator.generateBody(coins: coins))
        uintArray.append(contentsOf: Constants.trailing)
        print("HEADER \(uintArray[0...21]) CHALLENGE \(uintArray[22...37]) SN \(uintArray[38...40]) AN \(uintArray[41...56]) PAN \(uintArray[57...72]) TRAILING \(uintArray[73...74])")
        return uintArray
    }
}
