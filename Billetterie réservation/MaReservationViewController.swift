//
//  BilleterieViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 19/02/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit

class MaReservationViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var navetteLabel: UILabel!
    @IBOutlet weak var activiteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = UserDefaults.standard.object(forKey: "userFullName") as! String
        navetteLabel.text = UserDefaults.standard.object(forKey: "HeureNavette") as! String
        activiteLabel.text = UserDefaults.standard.object(forKey: "activiteShocker") as! String
    }
    
}
