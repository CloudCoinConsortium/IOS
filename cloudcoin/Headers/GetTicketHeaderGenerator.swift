//
//  GetTicketHeaderGenerator.swift
//  cloudcoin
//
//  Created by Moumita China on 25/11/21.
//

import Foundation

class GetTicketHeaderGenerator: NSObject{
    private var totalAmoumt = 0
    
    private var importedCoins = [CoinModelData]()
    private var pownResponse = PownResponseModel()
    private var hostModelArray: [HostModel]?
    private var uintArray = [UInt8]()
    private var totalArray = [UInt8]()
    
    //private var panArray = [[UInt8]]()
    private var finalCoinArrray = [UInt8]()
    private var pownResponseBinary = PownResponseBinaryModel()
    
    convenience init(importedCoins: [CoinModelData]?=nil, hostModelArray: [HostModel]?, uintArray: [UInt8]?=nil) {
        self.init()
        self.hostModelArray = hostModelArray
        if let importedCoins = importedCoins {
            self.importedCoins = importedCoins
            self.pownResponse.coin = [PownResponseCoin](repeating: PownResponseCoin(), count: self.importedCoins.count)
            //self.generateHeader()
        }
        if let uintArray = uintArray {
            self.totalArray = uintArray
            self.pownResponseBinary.coin = [PownResponseBinaryCoin](repeating: PownResponseBinaryCoin(), count: self.totalArray.count/448)
            generateHeaderBinaryFiles()
        }
    }
    private func generateHeaderBinaryFiles(){
        for i in 0..<25{
            var SNO = [UInt8](), AN = [UInt8]()
            var coins = [CoinsWOPanBinary]()
            
            for j in stride(from: 0, to: totalArray.count, by: 448) {
                self.uintArray = Array(self.totalArray[j...(j+448-1)])
                let arraySlice = uintArray[32...34]
                SNO = Array(arraySlice)
                let data = Data(bytes: SNO)
                let arraySlice1 = uintArray[48...(448 - 1)]
                let array1 = Array(arraySlice1)
                let newIndex = i * 16
                let newArraySlice1 = array1[newIndex...(newIndex + 15)]
                AN = Array(newArraySlice1)
                let data1 = Data(bytes: AN)
                coins.append(CoinsWOPanBinary(SNO: SNO, AN: AN))
            }
            let uintArray = generatePownHeaderForBinary(index: i, coins: coins)
            //print("GENERATED ARRAY \(uintArray)")
            
        }
    }
    private func generateOnlyHeader(index: Int) -> [UInt8]{
        var header: PownHeaderConstantsBinary!
        if index < 10{
            header = PownHeaderConstantsBinary(RI: "0\(index)")
        }else{
            // Decimal to hexadecimal
            header = PownHeaderConstantsBinary(RI: "".indexGenerator(index: index))
        }
        let mirror = Mirror(reflecting: header!)
        var uintArray = [UInt8]()
        for each in mirror.children{
            if let newStr = each.value as? String{
                uintArray.append(contentsOf: newStr.stringToUInt8Array())
            }
        }
        uintArray[14] = 0
        uintArray[15] = 1
        //print("generateOnlyHeader \(uintArray)")
        return uintArray
    }
    private func generatePownBody(coins: [CoinsWOPanBinary]) -> [UInt8]{
        var body: GetTicketBody!
        body = GetTicketBody(coins: coins)
        let mirror = Mirror(reflecting: body!)
        var uintArray = [UInt8]()
        for each in mirror.children{
            if let newVal = each.value as? [CoinsWOPanBinary]{
                for each1 in newVal{
                    uintArray.append(contentsOf: each1.mirrorSelf())
                }
            }else if let newStr = each.value as? String{
                uintArray.append(contentsOf: newStr.stringToUInt8Array())
            }
        }
        let crc32 = CRC32.checksum(bytes: Array(uintArray[0...11]))
        uintArray.replaceSubrange(12...15, with: crc32.convertUint32ToUint8())
        return uintArray
    }
    private func generatePownHeaderForBinary(index: Int, coins: [CoinsWOPanBinary]) -> [UInt8]{
        var uintArray = generateOnlyHeader(index: index)
        uintArray.append(contentsOf: generatePownBody(coins: coins))
        print("HEADER + BODY \(index) \(uintArray)")
        print("HEADER \(uintArray[0...21]) CHALLENGE \(uintArray[22...37]) SN \(uintArray[38...40]) AN \(uintArray[41...56]) PAN \(uintArray[57...72]) TRAILING \(uintArray[73...74])")
        return uintArray
    }
}
