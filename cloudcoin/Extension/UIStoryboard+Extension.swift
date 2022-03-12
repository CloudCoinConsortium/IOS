//
//  UIStoryboard+Extension.swift
//  cloudcoin
//
//  Created by Moumita China on 28/12/21.
//

import UIKit
import Foundation


extension UIStoryboard {
    
    class func instantiate<T: UIViewController>(withViewClass: T.Type) -> T {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: String(describing: withViewClass.self)) as! T
    }
}
extension UIStoryboard {
    func instantiateViewController<T>(type: T.Type) -> T {
        let id = String(describing: type)
        print("StoryBoard id: \(id)")
        return instantiateViewController(withIdentifier: id) as! T
    }
}
