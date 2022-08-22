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
    private var coins = [UInt8]()
    //private var importedCoins = [CoinModelData]()
    //private var getTicket = [String?](repeating: nil, count: 25)
    
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
        memoTF.layer.borderColor = UIColor.systemBlue.cgColor
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
        if coins.count > 0 && activeRaida >= 16{
            memoTF.resignFirstResponder()
            let _ = PownHeaderGenerator(hostModelArray: hostModelArray, uintArray: coins, activeRaida: self.activeRaida, delegate: self)
        }else{
            self.view.makeToast("There are not enough RAIDA available to perform the deposit.")
        }
    }
    @objc private func cancelAction(){
        coins = [UInt8]()
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
    
    func documentPickedSuccessfully(binaryCoins: [UInt8]?){
        if let binaryCoins = binaryCoins {
            self.coins = binaryCoins
        }
    }
}
extension DepositVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
extension DepositVC: PownDelegate{
    func pownIsSuccessfull(bool: Bool) {
        if bool{
            self.view.makeToast("Coin submitted successfully!")
        }
    }
}
