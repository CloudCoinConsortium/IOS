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
            self.generateHeader()
        }
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
            
            for j in stride(from: 0, to: totalArray.count, by: 448) {
                self.uintArray = Array(self.totalArray[j...(j+448-1)])
                let arraySlice = uintArray[32...34]
                SNO = Array(arraySlice)
                let data = Data(bytes: SNO)
                let arraySlice1 = uintArray[48...(448 - 1)]//432]
                let array1 = Array(arraySlice1)
                let newIndex = i * 16
                let newArraySlice1 = array1[newIndex...(newIndex + 15)]
                AN = Array(newArraySlice1)
                let data1 = Data(bytes: AN)
                PAN = CoinLogic.generateCryptoString().stringToUInt8Array()
                self.pownResponseBinary.coin[j].pan[i] = PAN
                let data2 = Data(bytes: PAN)
                //print("SN HERE \(SNO)")
                //print("AN HERE\(AN)")
                //print("PAN HERE\(data2.hexEncodedString())")
                coins.append(CoinsBinary(SNO: SNO, AN: AN, PAN: PAN))
            }
            let uintArray = generatePownHeaderForBinary(index: i, coins: coins)
            //print("GENERATED ARRAY \(uintArray)")
            let _ = APIManager(hostModel: hostModelArray?[i], sendString: "", dataArray: uintArray, completion: { returnStr in
                let uintArr = returnStr.stringToUInt8Array()
                print("POWN RESPONSE \(uintArr)")
                //self.pownResponse.pownResponse[i] = returnStr
                if uintArr[2] == 241{
                    //self.pownPass += 1
                    let returnIndex = Int(uintArr[0])
                    self.pownResponseBinary.pownResponse[returnIndex] = uintArr[2]
                }
            })
            
            /*PAN = CoinLogic.generateCryptoString()
             AN = importedCoins[j].an?[i] ?? ""
             coins.append(Coins(SNO: SNO, AN: AN, PAN: PAN))
             coinsWOpan.append(CoinsWOPan(SNO: SNO, AN: AN))
             self.pownResponse.coin[j].pan[i] = PAN*/
            
            
            /*let uintArray = self.generatePownHeader1(index: i, coins: coins)
             let _ = APIManager(hostModel: hostModelArray?[i], sendString: "", dataArray: uintArray, completion: { returnStr in
             let uintArr = returnStr.stringToUInt8Array()
             print("POWN RESPONSE \(uintArr)")
             self.pownResponse.pownResponse[i] = returnStr
             if uintArr[2] == 241{
             //self.pownPass += 1
             }
             })*/
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0, execute: {
            self.decidePassFailBinary()
        })
    }
    private func generateHeader(){
        //pownPass = 0
        for i in 0..<25{
            var SNO = "", PAN = "", AN = ""
            var coins = [Coins]()
            var coinsWOpan = [CoinsWOPan]()
            for j in 0..<importedCoins.count{
                SNO = importedCoins[j].sn ?? ""
                PAN = CoinLogic.generateCryptoString()
                AN = importedCoins[j].an?[i] ?? ""
                coins.append(Coins(SNO: SNO, AN: AN, PAN: PAN))
                coinsWOpan.append(CoinsWOPan(SNO: SNO, AN: AN))
                self.pownResponse.coin[j].pan[i] = PAN
            }
            let uintArray = self.generatePownHeader1(index: i, coins: coins)
            let _ = APIManager(hostModel: hostModelArray?[i], sendString: "", dataArray: uintArray, completion: { returnStr in
                let uintArr = returnStr.stringToUInt8Array()
                print("POWN RESPONSE \(uintArr)")
                self.pownResponse.pownResponse[i] = returnStr
                
            })
        }
        
        
        //replacePanOnSuccess()
        
        
        /*if let str = PownHeaderGenerator.generatePownHeader(index: i, coins: coins){
         //print("POWN HEADER \(i) \(str)")
         let _ = APIManager(hostModel: hostModelArray?[i], sendString: str, completion: { returnStr in
         let uintArr = returnStr.stringToUInt8Array()
         //print("POWN RESPONSE \(uintArr)")
         if uintArr[2] == 250{
         self.pownResponse[i] = returnStr
         self.pownPass += 1
         }
         //get ticket to fix it
         DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
         if i == 24 && self.pownPass < 25{
         for i in 0..<self.pownResponse.count{
         if self.pownResponse[i] == nil{
         self.findNeighbours(position: i)
         }
         }
         }
         })
         })
         }*/
        //if not getting any response from server then put it in fracked folder
        /*if let str1 = DetectHeaderGenerator.generateDetectHeader(index: i, coins: coinsWOpan){
         print("DETECT HEADER \(i) \(str1)")
         }*/
        
        /*if let str2 = GetTicketHeaderGenerator.generateGetTicketHeader(index: i, coins: coinsWOpan){
         print("GET TICKET HEADER \(i) \(str2)")
         self.getTicket.insert(str2, at: i)
         if self.getTicket.count <= 24{
         
         }
         }
         if let str3 = FindHeaderGenerator.generateFindHeader(index: i, coins: coins){
         // print("FIND HEADER \(i) \(str3)")
         _ = APIManager(hostModel: self.hostModelArray?[i], sendString: str3, completion: { returnStr in
         //print("\(index) \(returnStr)")
         let uintArr = returnStr.stringToUInt8Array()
         print("FIND RECEIVED \(i) \(uintArr)")
         })
         }*/
        
    }
    /*private func replacePanOnSuccess(){
     DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
     if self.pownPass >= 16{
     for i in 0..<self.importedCoins.count{
     self.importedCoins[i].pan = self.pownResponse.coin[i].pan
     }
     }
     })
     }*/
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
            //uintArray[48...(448 - 1)] = arraySlice1
            //finalCoinArrray.append(contentsOf: self.uintArray)
            if pass == 25{
                saveBinaryCoins(newCoin: uintArray)
            }
        }
    }
    private func saveBinaryCoins(newCoin: [UInt8]){
        let array = Array(newCoin[32...34])
        let data = Data(bytes: array)
        let value = UInt32(bigEndian: data.withUnsafeBytes { $0.pointee })

        let directoryModel = DirectoryBinaryModel(fileName: "\(value)", fileExt:  CreateDirectory.binName, data: newCoin, directory: CreateDirectory.bankName)
        RealmManager.addCoinRModel(fileName: "\(value)") { completed, coin in
            let _ = CreateDirectoryBinary(directoryModel: directoryModel)
        }
    }
    private func decidePassFail(){
        for i in 0..<pownResponse.coin.count{
            //p --> pass, f --> fail, e --> error, u --> unknown, n --> no response
            var p = 0, f = 0, e = 0, u = 0, n = 0, passFailStatus = ""
            for j in 0...24{
                let pownResponse = pownResponse.pownResponse[j]?.stringToUInt8Array()
                if pownResponse == nil{
                    n += 1
                    passFailStatus.append("f")
                }else if pownResponse?[2] == 241{
                    p += 1
                    passFailStatus.append("p")
                }else if pownResponse?[2] == 242{
                    f += 1
                    passFailStatus.append("f")
                }else if pownResponse?[2] == 243{
                    /*let messageArray = responseArray[j]?.message?.components(separatedBy: ",")
                     if messageArray?[i] == "pass"{
                     p += 1
                     passFailStatus.append("p")
                     }else if messageArray?[i] == "fail"{
                     f += 1
                     passFailStatus.append("f")
                     }
                     */
                }else{//} if ((responseArray[j]?.status?.contains("param")) != nil){
                    e += 1
                    passFailStatus.append("f")
                }
            }
            pownResponse.coin[i].pown = passFailStatus
            //return transaction amount from processSubData method and save it to Transaction model in Realm
            processSubData(p: p, f: f, e: e, u: u, n: n, coinIndex: i)//, responseArray: responseArray)
        }
        //decideProcessTransaction()
    }
    private func processSubData(p: Int, f: Int, e: Int, u: Int, n: Int, /*cloudcoin: CoinModelData, passFailStatus: String,*/ coinIndex: Int){//}, responseArray: [DepositModel?]){
        //status.append(passFailStatus)
        //let pan = segregatePans(pans: pans, coinIndex: coinIndex)
        let cloudcoin = importedCoins[coinIndex]
        var directoryModel: DirectoryModel!
        let fileName = createFileName(cloudcoin: cloudcoin)
        if f > 0 && p > 0{/*} && !frackedCalled{*/ //put the coin in the fracked folder and fix fracked, for fix_raida api
            /*isFracked = true
             cloudcoin.pan = pownResponse.coin[coinIndex].pan//pans
             cloudcoin.pown = pownResponse.coin[coinIndex].pown
             CreateDirectory.createAndWriteFile(fileName: fileName, fileExt: CreateDirectory.cloudcoinName, data:  CoinModel(cloudcoin: [cloudcoin]), directory: CreateDirectory.frackedName)
             let serverIndex = getIndexFromStatus(passFailStatus: passFailStatus)
             for each in serverIndex{
             /*if frackedModel.count == 0{
              frackedModel.append(FrackedModel(frackedIndex: each, cloudcoin: [cloudcoin], responseArray: responseArray, pan: pans))
              }else{*/
             if let firstIndex = frackedModel.firstIndex(where: {$0.frackedIndex == each}){
             frackedModel[firstIndex].cloudcoin?.append(cloudcoin)
             }else{
             frackedModel.append(FrackedModel(frackedIndex: each, cloudcoin: [cloudcoin], responseArray: responseArray, pan: pans))
             }
             }*/
            
        }
        else if p >= 16{ // all pass
            //replace ans newly generated pans with an
            cloudcoin.an = pownResponse.coin[coinIndex].pan
            cloudcoin.pown = pownResponse.coin[coinIndex].pown
            print("PANS \(pownResponse.coin[coinIndex].pan)")
            //to do the above thing generate n number of files where n = number of coins replace it and delete original .stack file
            //save Coin in Realm
            //let fileName = createFileName(cloudcoin: cloudcoin)
            print("FILENAME \(fileName)")
            totalAmoumt += (Int(cloudcoin.sn?.getDenomination() ?? "0") ?? 0)
            directoryModel = DirectoryModel(fileName: fileName, fileExt:  CreateDirectory.cloudcoinName, data: CoinModel(cloudcoin: [cloudcoin]), directory: CreateDirectory.bankName)
            //let _ = CreateDirectory(directoryModel: )
            //CreateDirectory.createAndWriteFile(fileName: fileName, fileExt: CreateDirectory.cloudcoinName, data:  CoinModel(cloudcoin: [cloudcoin]), directory: CreateDirectory.bankName)
            //MARK:- Required to remove file from fracked folder
            //RealmManager.addCoinRModel(amount: cloudcoin.sn?.getDenomination() ?? "0", deno: Int(cloudcoin.sn?.getDenomination() ?? "0") ?? 0, fileName: fileName) {  (success, coinRdata) in}
        } else if n > 0{//for fix_lost api
            //isLost = true
            cloudcoin.pan = pownResponse.coin[coinIndex].pan//pans
            //let fileName = createFileName(cloudcoin: cloudcoin)
            directoryModel = DirectoryModel(fileName: fileName, fileExt:  CreateDirectory.cloudcoinName, data: CoinModel(cloudcoin: [cloudcoin]), directory: CreateDirectory.limboName)
            //let _ = CreateDirectory(directoryModel: )
            //CreateDirectory.createAndWriteFile(fileName: fileName, fileExt: CreateDirectory.cloudcoinName, data:  CoinModel(cloudcoin: [cloudcoin]), directory: CreateDirectory.limboName)
        }
        else{ //mark as counterfeit and put in counterfeit folder
            let coin = CoinModel(cloudcoin: [cloudcoin])
            print("HELLO HERE \(CoinModel(cloudcoin: [cloudcoin])) \(coin.cloudcoin?.count)")
            //let fileName = createFileName(cloudcoin: cloudcoin)
            directoryModel = DirectoryModel(fileName: fileName, fileExt:  CreateDirectory.counterfeitName, data: CoinModel(cloudcoin: [cloudcoin]), directory: CreateDirectory.counterfeitName)
            //let _ = CreateDirectory(directoryModel: )
            
            //CreateDirectory.createAndWriteFile(fileName: createFileName(cloudcoin: cloudcoin), fileExt: CreateDirectory.counterfeitName, data:  CoinModel(cloudcoin: [cloudcoin]), directory: CreateDirectory.counterfeitName)
            //uploadButton.setTitle("NO FILES SELECTED", for: UIControl.State())
            //memoTF.text = ""
        }
        let _ = CreateDirectory(directoryModel: directoryModel)
    }
    private func generatePownHeader(index: Int, coins: [Coins]) -> String?{
        var header: PownHeaderConstants!
        if index < 10{
            header = PownHeaderConstants(RI: "0\(index)", coins: coins)
        }else{
            // Decimal to hexadecimal
            let h1 = String(index, radix: 16)
            var newH1 = ""
            if h1.count < 2{
                newH1 = "0\(h1)"
            }else{
                newH1 = h1
            }
            header = PownHeaderConstants(RI: newH1, coins: coins)
        }
        let mirror = Mirror(reflecting: header!)
        var newStr = String()
        for each in mirror.children{
            if let newVal = each.value as? [Coins]{
                for each1 in newVal{
                    newStr.append(each1.mirrorSelf())
                }
            }else{
                newStr.append("\(each.value)")
            }
        }
        return newStr
    }
    private func generatePownHeader1(index: Int, coins: [Coins]) -> [UInt8]{
        var header: PownHeaderConstants!
        if index < 10{
            header = PownHeaderConstants(RI: "0\(index)", coins: coins)
        }else{
            header = PownHeaderConstants(RI: "".indexGenerator(index: index), coins: coins)
        }
        let mirror = Mirror(reflecting: header!)
        var uintArray = [UInt8]()
        for each in mirror.children{
            if let newVal = each.value as? [Coins]{
                for each1 in newVal{
                    uintArray.append(contentsOf: each1.mirrorSelf1())
                }
            }else{
                if let newStr = each.value as? String{
                    uintArray.append(contentsOf: newStr.stringToUInt8Array())
                }
            }
        }
        print("\(uintArray)")
        return uintArray
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
    private func generatePownBody(coins: [CoinsBinary]) -> [UInt8]{
        var header: PownBodyGenerator!
        header = PownBodyGenerator(coins: coins)
        let mirror = Mirror(reflecting: header!)
        var uintArray = [UInt8]()
        for each in mirror.children{
            if let newVal = each.value as? [CoinsBinary]{
                for each1 in newVal{
                    uintArray.append(contentsOf: each1.mirrorSelf())
                }
            }else if let newStr = each.value as? String{
                uintArray.append(contentsOf: newStr.stringToUInt8Array())
            }
        }
        //print("generatePownBody \(Array(uintArray[0...11]))")
        let crc32 = CRC32.checksum(bytes: Array(uintArray[0...11]))
        //print("HELLO HERE \(crc32)")
        //let newArray = crc32.description.compactMap({UInt8($0.wholeNumberValue ?? 0)})
        //print("HELLO HERE1 \(newArray)  \(Array(newArray[(newArray.count - 1 - 3)...(newArray.count - 1)]))") //2, 4, 5, 5, 7, 5, 0, 2, 2, 9]
        //uintArray.replaceSubrange(12...16, with: Array(newArray[(newArray.count - 1 - 3)...(newArray.count - 1)]))
        uintArray.replaceSubrange(12...15, with: crc32.convertUint32ToUint8())//Array(crc32))
       // print("BODY HERE \(uintArray)")
        return uintArray
    }
    private func generatePownHeaderForBinary(index: Int, coins: [CoinsBinary]) -> [UInt8]{
        var uintArray = generateOnlyHeader(index: index)
        //print("HEADER COUNT \(uintArray) BODY COUNT\(generatePownBody(coins: coins).count)")
        uintArray.append(contentsOf: generatePownBody(coins: coins))
        print("HEADER + BODY \(index) \(uintArray)")
        print("HEADER \(uintArray[0...21]) CHALLENGE \(uintArray[22...37]) SN \(uintArray[38...40]) AN \(uintArray[41...56]) PAN \(uintArray[57...72]) TRAILING \(uintArray[73...74])")
        return uintArray
        /* var header: PownHeaderConstantsBinary!
         if index < 10{
         header = PownHeaderConstantsBinary(RI: "0\(index)", coins: coins)
         }else{
         // Decimal to hexadecimal
         /*let h1 = String(index, radix: 16)
          var newH1 = ""
          if h1.count < 2{
          newH1 = "0\(h1)"
          }else{
          newH1 = h1
          }*/
         header = PownHeaderConstantsBinary(RI: "".indexGenerator(index: index), coins: coins)
         }
         let mirror = Mirror(reflecting: header!)
         var uintArray = [UInt8]()
         for each in mirror.children{
         if let newVal = each.value as? [CoinsBinary]{
         for each1 in newVal{
         uintArray.append(contentsOf: each1.mirrorSelf())
         }
         }else{
         if let newStr = each.value as? String{
         uintArray.append(contentsOf: newStr.stringToUInt8Array())
         }
         }
         }
         print("generatePownHeaderForBinary \(uintArray)")
         return uintArray*/
        // return [UInt8]()
    }
}
