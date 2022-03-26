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
    //private var importedCoins = [CoinModelData]()
    private var uintArray = [UInt8]()
    
    convenience init(vc: UIViewController, delegate: DocumentPickerDelegate?) {
        self.init()
        self.vc = vc
        self.delegate = delegate
        //self.openDocumentPicker()
    }
    
    func openDocumentPicker(){
        let type = UTType(tag: "bin", tagClass: UTTagClass.filenameExtension, conformingTo: nil)!
        
        let dpvc = UIDocumentPickerViewController(
            forOpeningContentTypes: [type])
        dpvc.allowsMultipleSelection = true
        dpvc.delegate = self
        vc.present(dpvc, animated: true, completion: nil)
    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]){
        // This is what it should be
        for i in 0..<urls.count{
            //to support binary
            do {
                // Get the raw data from the file.
                let rawData: Data = try Data(contentsOf: urls[i])
                // Return the raw data as an array of bytes.
                //uintArray = [UInt8](rawData)
                uintArray.append(contentsOf: [UInt8](rawData))
                print(uintArray)//([UInt8](rawData))
            } catch {
                // Couldn't read the file.
                print("NO DATA COULD BE READ")
            }
        }
        if uintArray.count > 0{
            self.delegate?.documentPickedSuccessfully(binaryCoins: uintArray)
        } else{
            let error = NSError(domain: "DocumentFailed", code: 404, userInfo: ["error": "Falied to load document"])
            self.delegate?.documentPickingFailed(error: error)
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        vc.dismiss(animated: true) {
            let error = NSError(domain: "DocumentFailed", code: 404, userInfo: ["error": "Falied to load document"])
            self.delegate?.documentPickingFailed(error: error)
        }
    }
}

protocol DocumentPickerDelegate: AnyObject {
    func documentPickedSuccessfully(binaryCoins: [UInt8]?)
    func documentPickingFailed(error: NSError)
}

