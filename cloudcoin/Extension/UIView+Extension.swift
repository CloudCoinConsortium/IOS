//
//  UIView+Extension.swift
//  cloudcoin
//
//  Created by Moumita China on 07/04/22.
//

import Foundation
import UIKit


extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    func convertToPng() -> Data?{
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image?.pngData()

        /*UIGraphicsBeginImageContextWithOptions(self.layer.frame.size, false, 1)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let viewImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return viewImage.pngData()*/
    }
}
