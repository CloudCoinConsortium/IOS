//
//  DocumentPicker.swift
//  cloudcoin
//
//  Created by Moumita China on 24/12/21.
//

import Foundation
import UIKit
import UniformTypeIdentifiers


class DocumentPicker: NSObject, UIDocumentPickerDelegate{
    
    private var vc: UIViewController!
    private weak var delegate: DocumentPickerDelegate?
    private var importedCoins = [CoinModelData]()
    private var uintArray = [UInt8]()

    convenience init(vc: UIViewController, delegate: DocumentPickerDelegate?) {
        self.init()
        self.vc = vc
        self.delegate = delegate
        //self.openDocumentPicker()
    }
    
    func openDocumentPicker(){
        //let dpvc = UIDocumentPickerViewController(documentTypes: ["public.stack", "public.cc", "public.bin"], in: .import)
        let types = UTType.types(tag: "bin",
                                 tagClass: UTTagClass.filenameExtension,
                                 conformingTo: nil)
        let type = UTType(tag: "stack", tagClass: UTTagClass.filenameExtension, conformingTo: nil)!
        let type1 = UTType(tag: "bin", tagClass: UTTagClass.filenameExtension, conformingTo: nil)!

        let dpvc = UIDocumentPickerViewController(
            forOpeningContentTypes: [type, type1])//types)
        dpvc.allowsMultipleSelection = true
        dpvc.delegate = self
        vc.present(dpvc, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
        //if controller.documentPickerMode == .import {
        // This is what it should be
        for i in 0..<urls.count{
            if urls[i].mimeType() == "application/json"{ //to support json
                do{
                    let contents = try String(contentsOfFile: urls[i].path)
                    print("PICKED \(contents) \(urls[i].lastPathComponent)")
                    if let jsonData = contents.data(using: .utf8){
                        let decoder = JSONDecoder()
                        let value = try decoder.decode(CoinModel.self, from: jsonData)
                        for j in 0..<(value.cloudcoin?.count ?? 0){
                            importedCoins.append((value.cloudcoin?[j])!)
                        }
                        //self.pownResponse.coin = [PownResponseCoin](repeating: PownResponseCoin(), count: importedCoins.count)
                        //generateHeader()
                        //let _ = PownHeaderGenerator(importedCoins: self.importedCoins, hostModelArray: self.hostModelArray)
                    }
                }catch{
                    print("ERROR here")
                    let error = NSError(domain: "DocumentFailed", code: 404, userInfo: ["error": "Falied to load document"])
                    self.delegate?.documentPickingFailed(error: error)
                }
            }else{//to support binary
                do {
                    // Get the raw data from the file.
                    let rawData: Data = try Data(contentsOf: urls[i])
                    // Return the raw data as an array of bytes.
                    uintArray = [UInt8](rawData)
                    print(uintArray)//([UInt8](rawData))
                    print("ARRAY COUNT \(uintArray.count)")
                } catch {
                    // Couldn't read the file.
                    print("NO DATA COULD BE READ")
                }
            }
        }
        if importedCoins.count > 0{
            self.delegate?.documentPickedSuccessfully(coins: importedCoins, binaryCoins: nil)
        }else if uintArray.count > 0{
            self.delegate?.documentPickedSuccessfully(coins: nil, binaryCoins: uintArray)
        } else{
            let error = NSError(domain: "DocumentFailed", code: 404, userInfo: ["error": "Falied to load document"])
            self.delegate?.documentPickingFailed(error: error)
        }
        //}
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        vc.dismiss(animated: true) {
            let error = NSError(domain: "DocumentFailed", code: 404, userInfo: ["error": "Falied to load document"])
            self.delegate?.documentPickingFailed(error: error)
        }
    }
}

protocol DocumentPickerDelegate: AnyObject {
    func documentPickedSuccessfully(coins: [CoinModelData]?, binaryCoins: [UInt8]?)
    func documentPickingFailed(error: NSError)
}

