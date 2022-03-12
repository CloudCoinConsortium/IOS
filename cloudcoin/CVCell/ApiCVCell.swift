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
        let arr = HeaderGenerator.generateHeader(index: UInt8(index), commandType: UInt8(Commands.Echo.magicFunction()), udpNo: 1)
        _ = APIManager(hostModel: hostModel, dataArray: arr, completion: { uintArr in
            print("\(index) \(uintArr)")
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
}
