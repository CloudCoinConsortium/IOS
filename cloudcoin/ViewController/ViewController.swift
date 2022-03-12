//
//  ViewController.swift
//  cloudcoin
//
//  Created by Moumita China on 01/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let hostModelArray = HostExtractRepo.getHostArray()
        print(hostModelArray)
        let apiManger = APIManager(hostModel: hostModelArray?[0])
        print("APIManager")
    }
    
}

