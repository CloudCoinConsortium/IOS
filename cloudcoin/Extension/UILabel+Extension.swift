//
//  UILabel+Extension.swift
//  cloudcoin
//
//  Created by Moumita China on 30/12/21.
//

import UIKit
import Foundation


extension UILabel{
    //MARK: Set attributed text
    func setAttributedText(text: String?="", icon: String, color: UIColor){
        let fullString = NSMutableAttributedString(string: "\(text ?? "") ", attributes: [NSAttributedString.Key.foregroundColor : color])
         // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: icon)?.imageWithColor(color1: color)
        image1Attachment.bounds = CGRect(x: 0, y: 0, width: 12, height: 12)

        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)

         // add the NSTextAttachment wrapper to our full string, then add some more text.

         fullString.append(image1String)
        
         // draw the result in a label
         self.attributedText = fullString
    }
    func setAttributedText1(text: String?="", icon: String){
        let fullString = NSMutableAttributedString(string: "\(text ?? "") ")
         // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: icon)
        image1Attachment.bounds = CGRect(x: -12, y: 15, width: 30, height: 30)

        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)

         // add the NSTextAttachment wrapper to our full string, then add some more text.

         fullString.append(image1String)
        
         // draw the result in a label
         self.attributedText = fullString
    }
}
