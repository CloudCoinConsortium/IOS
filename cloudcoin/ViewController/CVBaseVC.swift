//
//  CVBaseVC.swift
//  cloudcoin
//
//  Created by Moumita China on 11/11/21.
//

import UIKit

class CVBaseVC: BaseVC {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Number of active raida
    var activeRaida = 0
    var hostModelArray: [HostModel]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activeRaida = 0
        if hostModelArray == nil{
            hostModelArray = HostExtractRepo.getHostArray()
        }
        collectionView.reloadData()
    }
}
extension CVBaseVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hostModelArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ApiCVCell", for: indexPath) as! ApiCVCell
        cell.mainView.backgroundColor = .lightGray
        cell.delegate = self
        cell.callApi(hostModel: hostModelArray?[indexPath.row], index: indexPath.row)
        cell.mainView.layer.cornerRadius = (collectionView.frame.width / 25) / 4
        return cell
    }
}
extension CVBaseVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let width = ((collectionView.frame.width) / 25) - 8.0
        return CGSize(width: width, height: collectionView.frame.height)//100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
extension CVBaseVC: RaidaCountDelegate{
    func totalNumberOfRaida(id: Int) {
        activeRaida += id
        print("activeRaida \(activeRaida)")
    }
}
@objc protocol RaidaCountDelegate : AnyObject {
    func totalNumberOfRaida(id: Int)
}
