//
//  UIButton+Extension.swift
//  cloudcoin
//
//  Created by Moumita China on 30/12/21.
//

import UIKit
import Foundation


extension UIButton{
    func setAttributedText1(text: String?="", icon: String){
        //let fullString = NSMutableAttributedString(string: "\(text ?? "") ")
        let fullString = NSMutableAttributedString(string: "\(text ?? "") ")//, attributes: [NSAttributedString.Key.foregroundColor : color])
         // create our NSTextAttachment
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: icon)
        image1Attachment.bounds = CGRect(x: -12, y: 15, width: 30, height: 30)

        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSAttributedString(attachment: image1Attachment)

         // add the NSTextAttachment wrapper to our full string, then add some more text.

         fullString.append(image1String)
        
         // draw the result in a label
        self.setAttributedTitle(fullString, for: UIControl().state)//attributedText = fullString
    }
    func setAttributedText(text: String?="", icon: String){
        let buttonText: NSString = NSString(string: text ?? "")

            //getting the range to separate the button title strings
            let newlineRange: NSRange = buttonText.range(of: "\n")

            //getting both substrings
            var substring1 = ""
            var substring2 = ""

            if(newlineRange.location != NSNotFound) {
                substring1 = buttonText.substring(to: newlineRange.location)
                substring2 = buttonText.substring(from: newlineRange.location)
            }

            //assigning diffrent fonts to both substrings
        let font1: UIFont = UIFont.boldSystemFont(ofSize: 18.0)//UIFont(name: "Arial", size: 17.0)!
        let attributes1 = [NSMutableAttributedString.Key.font: font1, NSMutableAttributedString.Key.foregroundColor: UIColor.white]
            let attrString1 = NSMutableAttributedString(string: substring1, attributes: attributes1)
        let image1Attachment = NSTextAttachment()
        image1Attachment.image = UIImage(named: icon)?.imageWithColor(color1: .white)
        image1Attachment.bounds = CGRect(x: 0, y: 0, width: 22, height: 22)

        // wrap the attachment in its own attributed string so we can append it
        let image1String = NSMutableAttributedString(attachment: image1Attachment)
        
        let font2: UIFont = UIFont.boldSystemFont(ofSize: 28.0)
            let attributes2 = [NSMutableAttributedString.Key.font: font2, NSMutableAttributedString.Key.foregroundColor: UIColor.white]
            let attrString2 = NSMutableAttributedString(string: substring2, attributes: attributes2)
        attrString2.append(image1String)

            //appending both attributed strings
            attrString1.append(attrString2)

            //assigning the resultant attributed strings to the button
        self.titleLabel?.textAlignment = .center
        self.setAttributedTitle(attrString1, for: UIControl().state)
    }
}
