//
//  GradientView.swift
//  cloudcoin
//
//  Created by Moumita China on 11/11/21.
//

import UIKit
import Foundation

@IBDesignable
/// A customizable GradientView
public class GradientView: UIView {
    //MARK:- Properties
    /**
     CornerRadius of  view.
     - Default value will change in different enviroments iphone, iphoneX, iPad, etc.
     */
    @IBInspectable public var cornerRadius: CGFloat = 16.0{
        didSet {
            layoutIfNeeded()
        }
    }
    @IBInspectable public var borderWidth: CGFloat = 0.0{
        didSet {
            layoutIfNeeded()
        }
    }
    @IBInspectable public var borderColor: UIColor = .clear{
        didSet {
            layoutIfNeeded()
        }
    }
    override public func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    override public func draw(_ rect: CGRect) {
        addBackgroundShape()
    }
    //MARK:- Methodes
    private func addBackgroundShape() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = self.cornerRadius
        self.clipsToBounds = true
        let layerGradient = CAGradientLayer()
        layerGradient.colors = [UIColor(hex: 0x1d2123).cgColor, UIColor(hex: 0x1d2161).cgColor]
                layerGradient.startPoint = CGPoint(x: 0, y: 0.5)
                layerGradient.endPoint = CGPoint(x: 1, y: 0.5)
        layerGradient.cornerRadius = self.cornerRadius
        layerGradient.borderWidth = self.borderWidth
        layerGradient.borderColor = self.borderColor.cgColor
        layerGradient.backgroundColor = UIColor.clear.cgColor
        layerGradient.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height)
        layer.insertSublayer(layerGradient, at: 0)
    }
}
