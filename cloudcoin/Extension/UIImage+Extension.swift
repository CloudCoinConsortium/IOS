//
//  UIImage+Extension.swift
//  cloudcoin
//
//  Created by Moumita China on 30/12/21.
//

import UIKit
import Foundation

extension UIImage{
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    func getImageData() -> [UInt8]{
        var uintArray = [UInt8]()
        if let rawData = self.pngData(){
            // Return the raw data as an array of bytes.
            uintArray = [UInt8](rawData)
            print(uintArray)//([UInt8](rawData))
            print("ARRAY COUNT \(uintArray.count)")
        } else {
            // Couldn't read the file.
            print("NO DATA COULD BE READ")
        }
        return uintArray
    }
}
