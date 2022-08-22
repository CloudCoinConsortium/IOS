//
//  WithdrawVC.swift
//  cloudcoin
//
//  Created by Moumita China on 30/12/21.
//

import UIKit

class WithdrawVC: CVBaseVC {
    
    // @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var exportButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var individualButton: UIButton!
    @IBOutlet weak var stackButton: UIButton!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var withdrawLabel: UILabel!
    
    @IBOutlet weak var memoTF: UITextField!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    var denoModel: [DenominationModel?]?
    var coinModel = [CoinRModel]()
    var totalAmount = 0
    var rowHeight : CGFloat = 0
    
    var fileNames = [String]()
    
    private let createDirectory = CreateDirectory()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        individualButton.isSelected = true
        designButton(sender: individualButton)
        designButton(sender: stackButton)
        
        individualButton.setTitleColor(UIColor.white, for: UIControl.State())
        individualButton.addTarget(self, action: #selector(indiAction(sender:)), for: .touchUpInside)
        stackButton.addTarget(self, action: #selector(stackAction(sender:)), for: .touchUpInside)
        stackButton.setTitleColor(UIColor.white, for: UIControl.State())
        
        tableView.dataSource = self
        tableView.delegate = self
        
        exportButton.layer.cornerRadius = 12.0
        shareButton.layer.cornerRadius = 12.0
        
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        exportButton.addTarget(self, action: #selector(exportAction(sender:)), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareAction(sender:)), for: .touchUpInside)
        
        memoTF.layer.cornerRadius = 12.0
        memoTF.clipsToBounds = true
        memoTF.layer.borderWidth = 0.6
        memoTF.layer.borderColor = UIColor.systemBlue.cgColor
        memoTF.placeholder = "Your Memo"
        memoTF.delegate = self
        
        rowHeight = (tableView.frame.width * 0.6) * 0.36
        
        denoModel = RealmManager.getAllCoinRModel()
        tableView.separatorStyle = .none
        tableView.reloadData()
        for i in 0..<(denoModel?.capacity ?? 0){
            if denoModel?[i]?.amount != 0{
                tableHeight.constant += rowHeight
            }
        }
        calculateTotalAmount()
        calculateTotalAmount2()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    private func designButton(sender: UIButton){
        if sender.isSelected{
            sender.setImage(UIImage(named: "RadioFilled"), for: UIControl.State())
        }else{
            sender.setImage(UIImage(named: "RadioUnfilled"), for: UIControl.State())
        }
    }
    private func calculateTotalAmount(){
        var amount = 0
        for i in 0..<(denoModel?.count ?? 0){
            amount += ((denoModel?[i]?.deno ?? 0) * (denoModel?[i]?.selfAmount ?? 0))
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:amount))
        exportButton.setAttributedText(text: "EXPORT\n\(formattedNumber ?? "") ", icon: "Coin")
    }
    private func calculateTotalAmount2(){
        var amount = 0
        for i in 0..<(denoModel?.count ?? 0){
            amount += ((denoModel?[i]?.deno ?? 0) * (denoModel?[i]?.amount ?? 0))
        }
        totalAmount = amount
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:amount))
        totalLabel.setAttributedText1(text: formattedNumber ?? "", icon: "Coin")
    }
    @objc private func backAction(){
        self.goBack()
    }
    @objc private func indiAction(sender: UIButton){
        sender.isSelected = true
        stackButton.isSelected = false
        designButton(sender: sender)
        designButton(sender: stackButton)
    }
    @objc private func stackAction(sender: UIButton){
        sender.isSelected = true
        individualButton.isSelected = false
        designButton(sender: sender)
        designButton(sender: individualButton)
    }
    @objc private func exportAction(sender: UIButton){
        //MARK:- generate json and write to file
        fileNames = [String]()
        if totalAmount > 0{
            individualTransaction()
            shareActionFiles()
        }else{
            self.view.makeToast("You don't have cloudcoins to withdraw")
        }
        denoModel = RealmManager.getAllCoinRModel()
        tableView.reloadData()
        calculateTotalAmount()
        calculateTotalAmount2()
    }
    private func shareActionFiles(){
        var filePaths = [URL]()
        for i in 0..<fileNames.count{
            if let filepath = URL(string: createDirectory.getDirectoryPath(path: CreateDirectory.exportedName))?.appendingPathComponent(fileNames[i]) {
                filePaths.append(filepath)
            }
        }
        openActivityController(data: filePaths)
    }
    @objc private func shareAction(sender: UIButton){
        //MARK:- generate json and write to file
    }
    private func individualTransaction(){
        coinModel = RealmManager.getFileName(denoModel: denoModel ?? [DenominationModel]()) ?? [CoinRModel]()
        var amount = 0
        for i in 0..<totalAmount{//coinModel.count{
            amount += Int(coinModel[i].amount) ?? 0 * coinModel[i].denomination
            print("FILENAME \(coinModel[i].file_name)")
            let hello = createDirectory.readDataFromFile2(type: CoinModel.self, path: CreateDirectory.bankName, filename: "\(coinModel[i].file_name)")
            print("HELLO HERE \(String(describing: hello))")
            let fileName = coinModel[i].file_name
            createDirectory.moveItem(fromPath: coinModel[i].directory_name, toPath: CreateDirectory.exportedName, filename: coinModel[i].file_name)
            fileNames.append("\(fileName)")
            RealmManager.deleteCoinRModel(coin: coinModel[i])
        }
        writeToRealm(amount: String(amount), count: self.coinModel.count)
    }
    private func writeToRealm(amount: String, count: Int){
        RealmManager.addTransactionRModel(amount: amount, memo: self.memoTF.text ?? "Amount withdrawn") { [weak self] (success) in
            guard let `self` = self else { return }
            if success ?? false{
                let name = self.createDirectory.getDirectoryPath(path: CreateDirectory.exportedName)
                if count > 1{
                    self.view.makeToast("\(count) CloudCoins withdrew successfully. Your coins were exported to \(name)")
                }else{
                    self.view.makeToast("\(count) CloudCoin withdrew successfully. Your coins were exported to \(name)")
                }
            }
        }
    }
    private func openActivityController(data: [URL]){
        let activityController = UIActivityViewController(activityItems: data, applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, completed, items, error in
            if completed{
                
            }else{
                
            }
        }
        self.present(activityController, animated: true, completion: nil)
    }
    private func processInternal(coin : [CoinRModel]) -> Int{
        var amount = 0, stack = [CoinModelData](), deno = 0
        for i in 0..<coin.count{
            deno = coin[i].denomination
            amount += 1//Int(coin[i].amount) ?? 0 * coin[i].denomination
            print("FILENAME \(coin[i].file_name)")
            let hello = createDirectory.readDataFromFile2(type: CoinModel.self, path: CreateDirectory.bankName, filename: "\(coin[i].file_name).\(CreateDirectory.cloudcoinName)")
            stack.append(contentsOf: hello?.cloudcoin ?? [CoinModelData]())
            print("HELLO HERE \(String(describing: hello))")
            createDirectory.removeFileFromPath(path: CreateDirectory.bankName, filename: "\(coin[i].file_name).\(CreateDirectory.cloudcoinName)")
            RealmManager.deleteCoinRModel(coin: coin[i])
        }
        if stack.count > 0{
            let filename = "\(getFilename(total: String(stack.count)))"
            let _ = CreateDirectory(directoryModel: DirectoryBinaryModel(fileName: filename, fileExt: CreateDirectory.binName, data: [UInt8](), directory: CreateDirectory.exportedName))
            //CreateDirectory.createAndWriteFile(fileName: filename, fileExt: CreateDirectory.stackName, data: CoinModel(cloudcoin: stack), directory: CreateDirectory.exportedName)
            fileNames.append("\(filename).\(CreateDirectory.binName)")
            amount = Int(stack.count * deno)
        }
        return amount
    }
    private func getFilename(total: String) -> String{
        return "\(total).CloudCoins.\(Date().timeIntervalSince1970)"
    }
}
extension WithdrawVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return denoModel?.capacity ?? 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClassIdentifier: WithdrawTVCell.self, for: indexPath)
        cell.setUpCell(tag: indexPath.row, data: denoModel?[indexPath.row], delegate: self)
        return cell
    }
}
extension WithdrawVC: WithdrawDelegate{
    func plusAction(index: Int) {
        if denoModel?[index]?.selfAmount ?? 0 > -1 && denoModel?[index]?.selfAmount ?? 0 < denoModel?[index]?.amount ?? 0{
            denoModel?[index]?.selfAmount! += 1
            self.tableView.reloadData()
            calculateTotalAmount()
        }else{
            self.view.makeToast("You don't have enough Cloudcoin")
        }
    }
    
    func minusAction(index: Int) {
        if denoModel?[index]?.selfAmount ?? 0 > 0 {
            denoModel?[index]?.selfAmount! -= 1
            self.tableView.reloadData()
            calculateTotalAmount()
        }else{
            self.view.makeToast("You don't have enough Cloudcoin")
        }
    }
}
extension WithdrawVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if denoModel?[indexPath.row]?.amount == 0{
            
            return 0
        }
        return (tableView.frame.width * 0.6) * 0.36
    }
}
extension WithdrawVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

protocol WithdrawDelegate: AnyObject{
    func plusAction(index: Int)
    func minusAction(index: Int)
}
