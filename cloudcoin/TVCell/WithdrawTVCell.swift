//
//  WithdrawTVCell.swift
//  cloudcoin
//
//  Created by Moumita China on 30/12/21.
//

import UIKit

class WithdrawTVCell: UITableViewCell {

    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var denominationImage: UIImageView!
    @IBOutlet weak var totalNotesLabel: UILabel!
    @IBOutlet weak var selfNotesLabel: UILabel!
    
    private var delegate: WithdrawDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        totalNotesLabel.layer.cornerRadius = 6.0
        totalNotesLabel.layer.masksToBounds = true
    }
    func setUpCell(tag: Int, data: DenominationModel?, delegate: WithdrawDelegate?){
        self.delegate = delegate
        plusButton.tag = tag
        minusButton.tag = tag
        plusButton.addTarget(self, action: #selector(plusAction(sender:)), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusAction(sender:)), for: .touchUpInside)
        denominationImage.image = UIImage(named: "Note\(tag)")
        totalNotesLabel.text = "\(data?.amount ?? 0)"
        selfNotesLabel.text = "\(data?.selfAmount ?? 0)"

    }
    @objc private func plusAction(sender: UIButton){
        self.delegate?.plusAction(index: sender.tag)
    }
    @objc private func minusAction(sender: UIButton){
        self.delegate?.minusAction(index: sender.tag)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
