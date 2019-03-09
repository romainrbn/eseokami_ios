//
//  LicenceViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 08/01/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit

class LicenceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

   
    @IBAction func openIcons(_ sender: Any) {
        if let url = URL(string: "https://www.icons8.com") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
}
