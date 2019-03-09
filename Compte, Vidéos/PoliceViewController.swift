//
//  PoliceViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 24/02/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit


// MARK: Development only
class PoliceViewController: UIViewController {
    
    var membre = ConnexionVariables.isMembreBDE
    var livreur = ConnexionVariables.isLivreurHotline
    
    @IBOutlet weak var membreSwitch: UISwitch!
    @IBOutlet weak var livreurSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if membre {
            membreSwitch.setOn(true, animated: true)
        } else {
            membreSwitch.setOn(false, animated: true)
        }
        
        if livreur {
            livreurSwitch.setOn(true, animated: true)
        } else {
            membreSwitch.setOn(false, animated: true)
        }

        
    }
    
    @IBAction func setMembre(_ sender: UISwitch) {
        if sender.isOn {
            membre = true
        } else {
            membre = false
        }
    }
    
    @IBAction func setLivreur(_ sender: UISwitch) {
        if sender.isOn {
            livreur = true
        } else {
            livreur = false
        }
    }
    

    

}
