//
//  CreateDirectoryBinary.swift
//  cloudcoin
//
//  Created by Moumita China on 29/01/22.
//

import Foundation

class CreateDirectory: NSObject{
    static let appName = "CloudcoinFile"
    static let bankName = "Bank"
    static let counterfeitName = "Counterfeit"
    static let exportedName = "Exported"
    static let frackedName = "Fracked"
    static let limboName = "Limbo"
    static let importedName = "Imported"
    static let cloudcoinName = "cloudcoin"
    static let binName = "bin"

    let fileManager = FileManager.default
    
    private var directoryModel: DirectoryBinaryModel!
    
    
    convenience init(directoryModel: DirectoryBinaryModel){
        self.init()
        self.directoryModel = directoryModel
        self.createAndWriteFile()
    }
    convenience init(isFirst: Bool) {
        self.init()
        if isFirst{
            if let created = createMainDirectory(){
                if created{
                    createSubDirectory(name: CreateDirectory.bankName)
                    createSubDirectory(name: CreateDirectory.counterfeitName)
                    createSubDirectory(name: CreateDirectory.exportedName)
                    createSubDirectory(name: CreateDirectory.frackedName)
                    createSubDirectory(name: CreateDirectory.limboName)
                    createSubDirectory(name: CreateDirectory.importedName)
                    Settings.shared().isFolderCreated = true
                }
            }
        }
    }
    private func createMainDirectory() -> Bool?{
        if let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
            let newDirectory = directory.appendingPathComponent(CreateDirectory.appName)
            print("DIRECTORY HERE \(newDirectory)")
            var result = false
            do{
                try FileManager.default.createDirectory(atPath: newDirectory.path, withIntermediateDirectories: true, attributes: nil)
                result = true
            }
            catch let error as NSError
            {
                NSLog("Unable to create directory \(error.debugDescription)")
                result = false
            }
            return result
        }else{
            return false
        }
    }
    private func createSubDirectory(name : String){
        if let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
            let newDirectory = directory.appendingPathComponent(CreateDirectory.appName).appendingPathComponent(name)
            print("DIRECTORY HERE \(newDirectory)")
            do{
                try FileManager.default.createDirectory(atPath: newDirectory.path, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error as NSError{
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }
    }
    private func createSubSubDirectory(path: String, name : String){
        if let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first{
            let newDirectory = directory.appendingPathComponent(CreateDirectory.appName).appendingPathComponent(path).appendingPathComponent(name)
            print("DIRECTORY HERE \(newDirectory)")
            do{
                try FileManager.default.createDirectory(atPath: newDirectory.path, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error as NSError
            {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
        }
    }
    private func createAndWriteFile(){//}(fileName: String, data: CoinModel, directory: String) {
        let documentDirectoryUrl = URL(string: getDirectoryPath(path: self.directoryModel.directory))
        let fileUrl = documentDirectoryUrl?.appendingPathComponent(self.directoryModel.fileName).appendingPathExtension(self.directoryModel.fileExt)
        //data to write in file.
        // Transform array into data and save it into file
        let rawData = Data(self.directoryModel.data)
        DispatchQueue.global().async {
            do {
                try rawData.write(to: fileUrl!)
            } catch {
                print(error)
            }
        }
    }
    private func removeCreatedDirectory(){
        do{
            try fileManager.removeItem(atPath: getDirectoryPath(path: CreateDirectory.appName))
        }
        catch let error as NSError{
            NSLog("Unable to remove directory \(error.debugDescription)")
        }
    }
    func getDirectoryPath(path: String) -> String {
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(CreateDirectory.appName, isDirectory: true).appendingPathComponent(path, isDirectory: true)
        return documentsDirectory.absoluteString
    }
    func readDataFromFile2<T: Decodable>(type : T.Type, path: String, filename: String) -> T?{
        if let filepath = URL(string: getDirectoryPath(path: path))?.appendingPathComponent(filename) {
            do {
                let contents = try String(contentsOfFile: filepath.path )
                if let jsonData = contents.data(using: .utf8){
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(T.self, from: jsonData)
                    print("\(contents)  \(value)")
                    return value
                }else{
                    return nil
                }
            } catch {
                // contents could not be loaded
                return nil
            }
        } else {
            // file not found!
            return nil
        }
    }
    private func readDataFromPath<T: Decodable>(type : T.Type, filepath: URL?) -> T?{
        if let filepath = filepath {
            do {
                let contents = try String(contentsOfFile: filepath.path )
                if let jsonData = contents.data(using: .utf8){
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(T.self, from: jsonData)
                    print("\(contents)  \(value)")
                    return value
                }else{
                    return nil
                }
            } catch {
                // contents could not be loaded
                return nil
            }
        } else {
            // file not found!
            return nil
        }
    }
    func moveItem(fromPath: String, toPath: String, filename: String){
        if let fromPath = URL(string: getDirectoryPath(path: fromPath))?.appendingPathComponent(filename).appendingPathExtension(CreateDirectory.binName) {
            do{
                let toPathHere = URL(string: getDirectoryPath(path: toPath))?.appendingPathComponent(filename).appendingPathExtension(CreateDirectory.binName)
                print("TO PATH \(toPathHere)")
                try fileManager.moveItem(atPath: fromPath.path, toPath: (toPathHere?.path)!)
            }catch{
                print(error)
            }
        }
    }
    private func getAllCoinsFromLimbo() -> [CoinModelData]?{
        if let fromPath = URL(string: getDirectoryPath(path: CreateDirectory.limboName)) {
            print("PATH \(fromPath.path)")
            var coins : [CoinModelData]?
            do{
                let directoryContents = try fileManager.contentsOfDirectory(at: fromPath, includingPropertiesForKeys: nil)
                coins = [CoinModelData]()
                for each in directoryContents{
                    if let coinModel = self.readDataFromPath(type: CoinModel.self, filepath: each){
                        if coinModel.cloudcoin?.count ?? 0 > 0{
                            coins?.append(contentsOf: coinModel.cloudcoin ?? [CoinModelData]())
                        }
                    }
                }
                return coins
            }catch{
                print(error)
                return nil
            }
        }else{
            return nil
        }
    }
    private func removeFilePresentInLimboFracked(filename: String){
        let _ = removeFileFromPath(path: CreateDirectory.limboName, filename: filename)
        let _ = removeFileFromPath(path: CreateDirectory.frackedName, filename: filename)
    }
    private func getAllCoinsFromLimbo1() -> [CoinModelData]?{
        //
        if let filePath = URL(string: getDirectoryPath(path: CreateDirectory.limboName))?.appendingPathComponent("1.CloudCoin.1.842140.cloudcoin"){
            let coin = readDataFromPath(type: CoinModel.self, filepath: filePath)
            return coin?.cloudcoin
        }
        return nil
    }
    func removeFileFromPath(path: String, filename: String) -> Bool{
        let filePath = URL(string: getDirectoryPath(path: path))?.appendingPathComponent(filename)
        var success = false
        do {
            try fileManager.removeItem(atPath: filePath?.path ?? "")
            success = true
        } catch {
            print("Could not delete file")
        }
        if success {
            print("SUCCESS")
        } else {
            print("Could not delete file")
        }
        return success
    }
}
