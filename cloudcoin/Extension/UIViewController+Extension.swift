//
//  UIViewController+Extension.swift
//  cloudcoin
//
//  Created by Moumita China on 18/12/21.
//

import Foundation
import UIKit

extension UIViewController{
    func goToDepositVC(){
        let vc = UIStoryboard.instantiate(withViewClass: DepositVC.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func goToWithdrawVC(){
        let vc = UIStoryboard.instantiate(withViewClass: WithdrawVC.self)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension UIViewController{
    func uInt32ToInt(buf: [UInt8]) -> (Int, NSError?) {
        if buf.count == 0 || buf.count > 4 {
            return (0, NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid buffer"]))
        }
        assert(buf.count * MemoryLayout<UInt8>.stride >= MemoryLayout<Int>.size)
        let value = UnsafeRawPointer(buf).assumingMemoryBound(to: Int.self).pointee.bigEndian
        return (value, nil)//int(binary.BigEndian.Uint32(buf)), nil
    }
}
