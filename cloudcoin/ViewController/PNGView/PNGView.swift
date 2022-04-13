//
//  PNGView.swift
//  cloudcoin
//
//  Created by Moumita China on 06/04/22.
//

import UIKit

class PNGView: UIView {
    
    @IBOutlet weak var coinImg: UIImageView!
    @IBOutlet weak var cloudLbl: UILabel!
    @IBOutlet weak var cloudQuanLbl: UILabel!
    @IBOutlet weak var coinWordLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var coinDenoLbl: UILabel!
    @IBOutlet weak var uploadLbl: UILabel!
    @IBOutlet weak var infoLbl: UILabel!

    private var data: PNGDisplayModel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    convenience init(data: PNGDisplayModel?=nil){
        self.init()
        if data != nil{
            self.data = data!
        }
        commonInit()
    }
    private func commonInit(){
        let viewFromXib = Bundle.main.loadNibNamed("PNGView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = CGRect(x: 0.0, y: 0.0, width: 392, height: 695)//self.bounds
        addSubview(viewFromXib)
        setUpUI()
    }
}
extension PNGView{
    private func setUpUI(){
        self.cloudQuanLbl.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi/4))
        cloudLbl.text = data.longCC
        cloudQuanLbl.text = "\(data.shortCC)  \(data.deno ?? 0)"
        coinWordLbl.text = data.denoWord
        dateLbl.text = data.dateString
        coinDenoLbl.text = "\(data.deno ?? 0)"
        uploadLbl.text = data.uploadTxt
        infoLbl.text = data.infoTxt
    }
}
