//
//  PownImageHeaderGenerator.swift
//  cloudcoin
//
//  Created by Moumita China on 20/02/22.
//

import Foundation

class PownImageHeaderGenerator: NSObject{
    private var totalAmoumt = 0
    
    private var pownResponse = PownResponseModel()
    private var hostModelArray: [HostModel]?
    private var uintArray = [UInt8]()
    private var totalArray = [UInt8]()
    
    //private var panArray = [[UInt8]]()
    private var finalCoinArrray = [UInt8]()
    private var pownResponseBinary = PownResponseBinaryModel()

    convenience init(hostModelArray: [HostModel]?, uintArray: [UInt8]?=nil) {
        self.init()
        self.hostModelArray = hostModelArray
        if let uintArray = uintArray {
            self.totalArray = uintArray
            self.pownResponseBinary.coin = [PownResponseBinaryCoin](repeating: PownResponseBinaryCoin(), count: self.totalArray.count/448)
            generateHeaderBinaryFiles()
        }
    }
    private func generateHeaderBinaryFiles(){
        for i in 0..<25{
            var SNO = [UInt8](), PAN = [UInt8](), AN = [UInt8]()
            var coins = [CoinsBinary]()
            //var coinsWOpan = [CoinsWOPan]()
            
            //for j in stride(from: 0, to: totalArray.count, by: 448) {
                self.uintArray = self.totalArray//Array(self.totalArray[(j+448-1)])
                let arraySlice = uintArray[32...47]
                SNO = Array(arraySlice)
                let data = Data(bytes: SNO)
                /*let arraySlice1 = uintArray[48...(448 - 1)]//432]
                let array1 = Array(arraySlice1)
                let newIndex = i * 16
                let newArraySlice1 = array1[newIndex...(newIndex + 15)]
                AN = Array(newArraySlice1)
                let data1 = Data(bytes: AN)
                PAN = CoinLogic.generateCryptoString().stringToUInt8Array()
                self.pownResponseBinary.coin[j].pan[i] = PAN
                let data2 = Data(bytes: PAN)*/
            print("SN HERE \(SNO) \(data.hexEncodedString())")//\(data.hexEncodedString())")
                //print("AN HERE\(data1.hexEncodedString())")
                //print("PAN HERE\(data2.hexEncodedString())")
                //coins.append(CoinsBinary(SNO: SNO, AN: AN, PAN: PAN))
            //}
            /*let uintArray = generatePownHeaderForBinary(index: i, coins: coins)
            let _ = APIManager(hostModel: hostModelArray?[i], sendString: "", dataArray: uintArray, completion: { returnStr in
                let uintArr = returnStr.stringToUInt8Array()
                print("POWN RESPONSE \(uintArr)")
                //self.pownResponse.pownResponse[i] = returnStr
                if uintArr[2] == 241{
                    //self.pownPass += 1
                    let returnIndex = Int(uintArr[0])
                    self.pownResponseBinary.pownResponse[returnIndex] = uintArr[2]
                }
            })*/
        }
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.decidePassFailBinary()
        })*/
    }
    private func decidePassFailBinary(){
        for i in 0..<pownResponseBinary.coin.count{
            var pass = 0
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
                    
                }
            }
            uintArray.replaceSubrange(Range(48...(448 - 1)), with: newArray)
            //uintArray[48...(448 - 1)] = arraySlice1
            //finalCoinArrray.append(contentsOf: self.uintArray)
            if pass > 16{
                saveBinaryCoins(newCoin: uintArray)
            }
        }
    }
    private func saveBinaryCoins(newCoin: [UInt8]){
        let directoryModel = DirectoryBinaryModel(fileName: "HelloWorld", fileExt:  CreateDirectory.binName, data: newCoin, directory: CreateDirectory.bankName)
        let _ = CreateDirectoryBinary(directoryModel: directoryModel)
    }
}
