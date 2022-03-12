//
//  UITableView+Extension.swift
//  cloudcoin
//
//  Created by Moumita China on 30/12/21.
//

import UIKit
import Foundation


extension UITableView{
    
    func dequeueReusableCell<T : UITableViewCell>(withClassIdentifier cell: T.Type) -> T {
        return dequeueReusableCell(withIdentifier: String(describing: cell.self)) as! T
    }
    
    func registerNib(_ cellClass: UITableViewCell.Type) {
        let id = String(describing: cellClass.self)
        let nib = UINib(nibName: id, bundle: nil)
        register(nib, forCellReuseIdentifier: id)
    }
    
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass.self))
    }
    func dequeueReusableCell<T: UITableViewCell>(withClassIdentifier: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: String(describing: withClassIdentifier.self), for: indexPath) as! T
    }
    
    
    func reloadWithoutAnimation() {
        let lastScrollOffset = contentOffset
        beginUpdates()
        endUpdates()
        layer.removeAllAnimations()
        setContentOffset(lastScrollOffset, animated: false)
    }
}
