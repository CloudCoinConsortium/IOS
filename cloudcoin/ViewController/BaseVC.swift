//
//  BaseVC.swift
//  cloudcoin
//
//  Created by Moumita China on 11/11/21.
//

import UIKit

class BaseVC: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func goBack(){
        self.navigationController?.popViewController(animated: true)
    }
}
