//
//  ApiCVCell.swift
//  cloudcoin
//
//  Created by Moumita China on 11/11/21.
//

import UIKit

class ApiCVCell: UICollectionViewCell {
    
    @IBOutlet weak var mainView: UIView!
    
    weak var delegate: RaidaCountDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainView.backgroundColor = .lightGray
    }
    
    func callApi(hostModel: HostModel?=nil, index: Int){
        if let str = HeaderGenerator.generateEchoHeader(index: index){
            _ = APIManager(hostModel: hostModel, sendString: str, dataArray: [UInt8](), completion: { returnStr in
                print("\(index) \(returnStr)")
                let uintArr = returnStr.stringToUInt8Array()
                print("RESPONSE ARRAY CONVERTED\(uintArr)")
                DispatchQueue.main.async {
                    if !uintArr.isEmpty && uintArr[2] == 250{
                        self.delegate?.totalNumberOfRaida(id: 1)
                        self.mainView.backgroundColor = .green
                    }else{
                        self.mainView.backgroundColor = .red
                    }
                }
            })
        }
        /*let data = ServerStatusRepo().getServerStatus(view: self.mainView, id: String(index))
        data.subscribe(onNext: { [weak self] status in
            guard let `self` = self else { return }
            if status{
                self.delegate?.totalNumberOfRaida(id: 1)
                self.mainView.backgroundColor = .green
            }else{
                self.mainView.backgroundColor = .lightGray
            }
        }, onError: { error in
            self.mainView.backgroundColor = .red
        }).disposed(by: disposeBag)*/
    }
}
