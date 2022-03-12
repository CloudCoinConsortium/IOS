//
//  DepositVC.swift
//  cloudcoin
//
//  Created by Moumita China on 28/12/21.
//

import UIKit

class DepositVC: CVBaseVC {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var memoTF: UITextField!
    @IBOutlet weak var depositButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    private var importedCoins = [CoinModelData]()
    private var getTicket = [String?](repeating: nil, count: 25)
    
    private var documentPicker: DocumentPicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cancelButton.isHidden = true
        uploadButton.layer.cornerRadius = 12.0
        cancelButton.layer.cornerRadius = 12.0
        depositButton.layer.cornerRadius = 12.0
        memoTF.layer.cornerRadius = 12.0
        memoTF.clipsToBounds = true
        memoTF.layer.borderWidth = 0.6
        memoTF.layer.borderColor = UIColor.systemBlue.cgColor//.withAlphaComponent(0.6).cgColor
        memoTF.placeholder = "Your Memo"
        memoTF.delegate = self
        view.endEditing(true)
        backgroundImage.endEditing(true)
        
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(uploadFromFiles), for: .touchUpInside)
        uploadButton.setTitleColor(.white, for: UIControl.State())
        uploadButton.setTitle("SELECT CLOUD COINS", for: UIControl.State())
        
        depositButton.addTarget(self, action: #selector(depositAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        
        documentPicker = DocumentPicker(vc: self, delegate: self)
    }
    @objc private func depositAction(){
        if importedCoins.count > 0{
            for each in importedCoins{
                let fileName = createFileName(cloudcoin: each)
                let directoryModel = DirectoryModel(fileName: fileName, fileExt:  CreateDirectory.cloudcoinName, data: CoinModel(cloudcoin: [each]), directory: CreateDirectory.importedName)
                let _ = CreateDirectory(directoryModel: directoryModel)
            }
            if activeRaida >= 16{
                memoTF.resignFirstResponder()
                let _ = PownHeaderGenerator(importedCoins: self.importedCoins, hostModelArray: self.hostModelArray)
            }else{
                self.view.makeToast("There are not enough RAIDA available to perform the deposit.")
            }
        }
    }
    @objc private func cancelAction(){
        importedCoins = [CoinModelData]()
        uploadButton.setTitle("SELECT CLOUD COINS", for: UIControl.State())
        cancelButton.isHidden = true
    }
    @objc private func backAction(){
        self.goBack()
    }
    @objc private func uploadFromFiles(){
        documentPicker?.openDocumentPicker()
    }
}
extension DepositVC: DocumentPickerDelegate{
    func documentPickingFailed(error: NSError) {
        print("ERROR \(error.userInfo["error"])")
    }
    
    func documentPickedSuccessfully(coins: [CoinModelData]?, binaryCoins: [UInt8]?){
        if let coins = coins {
            self.importedCoins = coins
            var buttonTitle = ""
            if importedCoins.count > 0{
                cancelButton.isHidden = false
                if importedCoins.count > 1{
                    buttonTitle = "\(self.importedCoins.count) FILES SELECTED"
                }else{
                    buttonTitle = "\(self.importedCoins.count) FILE SELECTED"
                }
            }else{
                buttonTitle = "SELECT CLOUD COINS"
                cancelButton.isHidden = true
            }
            uploadButton.setTitle(buttonTitle, for: UIControl.State())
            let _ = PownHeaderGenerator(importedCoins: self.importedCoins, hostModelArray: hostModelArray, uintArray: nil)
        }else{
            if let binaryCoins = binaryCoins {
                let _ = PownHeaderGenerator(importedCoins: nil, hostModelArray: hostModelArray, uintArray: binaryCoins)
            }
        }
        
    }
}
extension DepositVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
