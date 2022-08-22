//
//  HomeVC.swift
//  cloudcoin
//
//  Created by Moumita China on 11/11/21.
//

import UIKit

class HomeVC: CVBaseVC {
    
    @IBOutlet weak var withdrawView: GradientView!
    @IBOutlet weak var depositView: GradientView!
    @IBOutlet weak var denoCollectionView: UICollectionView!
    @IBOutlet weak var totalLabel: UILabel!
    
    private var denoModel: [DenominationModel?]?
    private var importedCoins = [CoinModelData]()
    private var getTicket = [String?](repeating: nil, count: 25)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        denoCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        denoCollectionView.dataSource = self
        denoCollectionView.delegate = self
        depositView.isUserInteractionEnabled = true
        depositView.addSingleTapGestureRecognizerWithResponder { [weak self] (tap) in
            guard let `self` = self else { return }
            self.goToDepositVC()
        }
        
        withdrawView.isUserInteractionEnabled = true
        withdrawView.addSingleTapGestureRecognizerWithResponder { [weak self] (tap) in
            guard let `self` = self else { return }
            self.goToWithdrawVC()
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        calculateAmount()
    }
    private func calculateAmount(){
        denoModel = RealmManager.getAllCoinRModel()
        denoCollectionView.reloadData()
        var amount = 0
        for i in 0..<(denoModel?.count ?? 0){
            amount += ((denoModel?[i]?.deno ?? 0) * (denoModel?[i]?.amount ?? 0))
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:amount))
        totalLabel.setAttributedText1(text: formattedNumber ?? "", icon: "Coin")
    }
}
extension HomeVC{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.denoCollectionView{
            return 5
        }else{
            return super.collectionView(collectionView, numberOfItemsInSection: section)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.denoCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVCell", for: indexPath) as! HomeCVCell
            let data = denoModel?[indexPath.row]
            cell.denominationLabel.text = "\(data?.deno ?? 0)'s"
            cell.amountLabel.text = "\(data?.amount ?? 0)"
            return cell
        }else{
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }
}
extension HomeVC{
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if collectionView == self.denoCollectionView{
            let width = ((collectionView.frame.width) / 5) - 8.0
            return CGSize(width: width, height: width * 1.25)
        }else{
            return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.denoCollectionView{
            return 8
        }else{
            return super.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.denoCollectionView{
            return 8
        }else{
            return super.collectionView(collectionView, layout: collectionViewLayout, minimumLineSpacingForSectionAt: section)
        }
    }
}
