//
//  PownHeaderGenerator.swift
//  cloudcoin
//
//  Created by Moumita China on 25/11/21.
//

import CoreGraphics
import Foundation
import CryptoKit
import UIKit
/*1. First calculate no of requests —> first change
 
 2. Recalculate header and body together on one go instead of breaking it like before this is required for refer below
 ￼
 
 3. Break requests into multiple packets
 
 4. Decide pass fail or whatever and save coins as required
 
 5. If request > 1 go to step 2*/


class PownHeaderGenerator: NSObject{
    private var totalAmoumt = 0
    
    private var hostModelArray: [HostModel]?
    private var uintArray = [UInt8]()
    private var totalArray = [UInt8]()
    
    private var finalCoinArrray = [UInt8]()
    //private var pownResponseBinary = PownResponseModel()
    
    private var pownRequests = [PownRequestModel]()
    
    private let packetSize = 22 + 16 + (35 * Constants.maxCoins) + 2
    
    private var numCoin = 0
    
    private var noOfResponse = 0
    
    private var activeRaida = 0
    
    private var delegate: PownDelegate?
    
    convenience init(hostModelArray: [HostModel]?, uintArray: [UInt8]?=nil, activeRaida: Int, delegate: PownDelegate?) {
        self.init()
        self.hostModelArray = hostModelArray
        self.activeRaida = activeRaida
        self.delegate = delegate
        if let uintArray = uintArray {
            self.totalArray = uintArray
            self.numCoin = self.totalArray.count / Constants.unitPerCoin
            //self.pownResponseBinary.coin = [PownResponseBinaryCoin](repeating: PownResponseBinaryCoin(), count: self.totalArray.count/448)
            //processCoinForPowning(command: Commands.POWN)
            calculateRequests()
        }
    }
    //MARK: 1. First calculate no of requests
    private func calculateRequests(){
        //let max = (Constants.maxCoins * Constants.maxPackets * Constants.unitPerCoin)
        
        let maxCoinCount = Constants.maxCoins * Constants.maxPackets
        
        var noOfReq =  CGFloat(self.numCoin)/CGFloat(maxCoinCount)
        noOfReq = noOfReq.rounded(.up)
        
        var i = 0
        repeat{
            let newIndex = i * Constants.maxCoins * Constants.unitPerCoin
            let maxIndex = Swift.min(newIndex +  (Constants.maxCoins * Constants.unitPerCoin), totalArray.count)//x.rounded(.up))
            
            self.pownRequests.append(PownRequestModel(command: Commands.Pown, totalCoins: Array(totalArray[newIndex..<maxIndex]), pownResponseBinary: PownResponseModel()))
            self.pownRequests[i].pownResponseBinary.coin = [PownResponseBinaryCoin](repeating: PownResponseBinaryCoin(), count: self.pownRequests[i].totalCoins.count/Constants.unitPerCoin)
            processCoinForPowning(requestNo: i)
            i += 1
        }while i < Int(noOfReq)
    }
    //MARK: 2. Calculate PANs
    private func processCoinForPowning(requestNo: Int){//(command: Commands, totalCoins: [UInt8]){
        for i in 0..<25{
            var SNO = [UInt8](), PAN: [UInt8]?, AN = [UInt8]()
            var coins = [CoinsBinary]()
            for j in stride(from: 0, to: pownRequests[requestNo].totalCoins.count, by: 448) {//totalArray.count, by: 448) {
                self.uintArray = Array(pownRequests[requestNo].totalCoins[j...(j+448-1)])//Array(self.totalArray[j...(j+448-1)])
                let arraySlice = uintArray[32...34]
                SNO = Array(arraySlice)
                let arraySlice1 = uintArray[48...(448 - 1)]
                let array1 = Array(arraySlice1)
                let newIndex = i * 16
                let newArraySlice1 = array1[newIndex...(newIndex + 15)]
                AN = Array(newArraySlice1)
                if pownRequests[requestNo].command == .Pown{
                    PAN = [UInt8]()
                    PAN = CoinLogic.generateCryptoString(count: 16, an: Data(AN).hexEncodedString()).stringToUInt8Array()
                    pownRequests[requestNo].pownResponseBinary.coin[j/Constants.unitPerCoin].pan[i] = PAN ?? [UInt8]()
                }
                coins.append(CoinsBinary(SNO: SNO, AN: AN, PAN: PAN))
            }
            //pownAction(index: i, coins: coins, requestNo: requestNo)
            calculateConcreteHeaderBody(index: i, coins: coins, requestNo: requestNo)
        }
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.decidePassFailBinary(requestNo: requestNo)
        })*/
    }
    //MARK: 3. Calculate concrete header and body
    private func calculateConcreteHeaderBody(index: Int, coins: [CoinsBinary], requestNo: Int){
        var udpNo = coins.count/Constants.maxCoins
        udpNo = udpNo == 0 ? 1 : udpNo
       // var uintArray = [UInt8]()
        //calculate header
        var header = HeaderGenerator.generateHeader(index: UInt8(index), commandType: UInt8(Commands.Pown.magicFunction()), udpNo: UInt8(udpNo))
        
        //calculate body
        let (challenge, allCoins) = BodyGenerator.generateBody(coins: coins)
        
        //if packet is > 1 then create CRC32 checksum and include first byte in header index 6
        if udpNo > 1{
            let crc32 = CRC32.checksum(bytes: challenge + allCoins).convertUint32ToUint8()
            header[6] = crc32[0]
        }
        let requestPacket = RequestPacket(header: header, challenge: challenge, coins: allCoins)
        /*uintArray.append(contentsOf: header)
        uintArray.append(contentsOf: body)
        uintArray.append(contentsOf: Constants.trailing)*/
        breakPackets(index: index, requestNo: requestNo, udpNo: udpNo, requestPacket: requestPacket)
    }
    //MARK: 4. Break packets
    private func breakPackets(index: Int, requestNo: Int, udpNo: Int, requestPacket: RequestPacket){
        var byteArr = [UInt8]()
        var i = 0
        repeat{
            if i == 0{
                byteArr = requestPacket.header + requestPacket.challenge + requestPacket.coins[0..<Swift.min((Constants.maxCoins * 35), requestPacket.coins.count)]
            }else{
                let newIndex = i * Constants.maxCoins * 35
                byteArr = Array(requestPacket.coins[newIndex..<Swift.min(newIndex + newIndex, requestPacket.coins.count)])
            }
            if i == udpNo - 1{
                byteArr.append(contentsOf: Constants.trailing)
            }
            print("REQUEST \(byteArr)")
            let _ = APIManager(hostModel: hostModelArray?[index], dataArray: byteArr, completion: { uintArr in
                print("POWN RESPONSE \(uintArr)")
                self.noOfResponse += 1
                if !uintArr.isEmpty && uintArr[2] == 241{
                    let returnIndex = Int(uintArr[0])
                    self.pownRequests[requestNo].pownResponseBinary.pownResponse[returnIndex] = uintArr[2]
                }
                DispatchQueue.main.async {
                    if self.noOfResponse == self.activeRaida{
                        self.decidePassFailBinary(requestNo: requestNo)
                    }
                }
            })
            i += 1
        }while i < udpNo
       
        
        /*if udpNo > 1{
        }else{
            byteArr = totalPackets
        }
        let _ = APIManager(hostModel: hostModelArray?[index], dataArray: byteArr, completion: { uintArr in
            print("POWN RESPONSE \(uintArr)")
            if !uintArr.isEmpty && uintArr[2] == 241{
                let returnIndex = Int(uintArr[0])
                self.pownRequests[requestNo].pownResponseBinary.pownResponse[returnIndex] = uintArr[2]
            }
        })*/
    }
    /*private func pownAction(index: Int, coins: [CoinsBinary], requestNo: Int){
        var udpNo = coins.count/Constants.maxCoins
        udpNo = udpNo == 0 ? 1 : udpNo
        
        for i in stride(from: 0, through: coins.count, by: Constants.maxCoins){
            let newIndex = i * Constants.maxCoins
            let newCoins = Array(coins[newIndex..<Swift.min(newIndex + Constants.maxCoins, coins.count)])
            let isTrailing = i == (udpNo - 1) ? true : false
            let isFirst = i == 0 ? true : false
            let uintArray = generatePownBinary(index: index, coins: newCoins, udpNo: udpNo, isTrailing: isTrailing, isFirst: isFirst)
            let _ = APIManager(hostModel: hostModelArray?[index], dataArray: uintArray, completion: { uintArr in
                print("POWN RESPONSE \(uintArr)")
                if !uintArr.isEmpty && uintArr[2] == 241{
                    let returnIndex = Int(uintArr[0])
                    self.pownRequests[requestNo].pownResponseBinary.pownResponse[returnIndex] = uintArr[2]
                }
            })
        }
    }*/
    private func decidePassFailBinary(requestNo: Int){
        for i in 0..<pownRequests[requestNo].pownResponseBinary.coin.count{
            var pass = 0, fail = 0
            let coinIndex = i * 448
            self.uintArray = Array(self.pownRequests[requestNo].totalCoins[coinIndex...(coinIndex+448-1)])
            let arraySlice1 = uintArray[48...(448 - 1)]
            var newArray = Array(arraySlice1)
            for j in 0..<25{
                let pownResponse = pownRequests[requestNo].pownResponseBinary.pownResponse[j]
                if pownResponse == nil{
                    
                }else if pownResponse == 241{
                    pass += 1
                    let newIndex = j * 16
                    newArray.replaceSubrange(Range(newIndex...(newIndex + 15)), with: pownRequests[requestNo].pownResponseBinary.coin[i].pan[j])
                    
                }else if pownResponse == 242{
                    fail += 1
                }else if pownResponse == 243{
                    
                }
            }
            uintArray.replaceSubrange(Range(48...(448 - 1)), with: newArray)
            if pass < 16{
                //save in counterfeit folder
                saveBinaryCoins(newCoin: uintArray, directory: CreateDirectory.counterfeitName)
            }
            if pass >= 16{
                //save in fracked folder and fix it
                saveBinaryCoins(newCoin: uintArray, directory: CreateDirectory.frackedName)
            }
            if pass == 25{
                //save in Bank folder
                saveBinaryCoins(newCoin: uintArray, directory: CreateDirectory.bankName)
            }
        }
    }
    private func saveBinaryCoins(newCoin: [UInt8], directory: String){
        let array = Array(newCoin[32...34])
        let data = Data(array)
        let hexString = data.hexEncodedString()
        let value = UInt64(hexString, radix: 16)
        //let value = UInt32(bigEndian: data.withUnsafeBytes { $0.pointee })*/
        
        let directoryModel = DirectoryBinaryModel(fileName: "\(value ?? 0)", fileExt:  CreateDirectory.binName, data: newCoin, directory: directory)
        
        if directory != CreateDirectory.counterfeitName{
            RealmManager.addCoinRModel(directoryModel: directoryModel) { completed, coin in
                let _ = CreateDirectory(directoryModel: directoryModel)
                self.delegate?.pownIsSuccessfull(bool: true)
            }
        }else{
            let _ = CreateDirectory(directoryModel: directoryModel)
            self.delegate?.pownIsSuccessfull(bool: true)
        }
    }
    /*private func generatePownBinary(index: Int, coins: [CoinsBinary], udpNo: Int, isTrailing: Bool?=nil, isFirst: Bool?=nil) -> [UInt8]{
        var uintArray = [UInt8]()
        if isFirst ?? false{
            uintArray = HeaderGenerator.generateHeader(index: UInt8(index), commandType: UInt8(Commands.Pown.magicFunction()), udpNo: UInt8(udpNo))
        }
        uintArray.append(contentsOf: BodyGenerator.generateBody(coins: coins))
        if isTrailing ?? false{
            uintArray.append(contentsOf: Constants.trailing)
        }
        print("HEADER \(uintArray[0...21]) CHALLENGE \(uintArray[22...37]) SN \(uintArray[38...40]) AN \(uintArray[41...56]) PAN \(uintArray[57...72]) TRAILING \(uintArray[73...74])")
        return uintArray
    }*/
}
