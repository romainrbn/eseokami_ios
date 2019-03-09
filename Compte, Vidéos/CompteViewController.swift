//
//  CompteViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 02/02/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit

class CompteViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberOfPoints: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: 700)
        scrollView.isDirectionalLockEnabled = true
        if UserDefaults.standard.object(forKey: "userFullName") == nil {
            nameLabel.text = "Déconnecté"
            numberOfPoints.text = "Connecte-toi pour consulter ton nombre de points !"
        } else {
            nameLabel.text =  "Identifié sous le nom de : \(UserDefaults.standard.object(forKey: "userFullName") as! String)"
            numberOfPoints.text = "0 points" // remplacer le 0 par API
        }
        
    }
    
    @IBAction func openWebsite(_ sender: Any) {
        if UIApplication.shared.canOpenURL(URL(string: "https://www.eseokami.fr")!) {
             UIApplication.shared.open(URL(string: "https://www.eseokami.fr")!, options: [:], completionHandler: nil)
        }
       
    }
    
    

}
