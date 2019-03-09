//
//  ScanViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 23/01/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import RSBarcodes_Swift
import PMAlertController
import Lottie

class ScanViewController: RSCodeReaderViewController {
    
    var animationView = LOTAnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.focusMarkLayer.strokeColor = UIColor.red.cgColor
        self.cornersLayer.strokeColor = UIColor.yellow.cgColor
        
        self.barcodesHandler = { barcodes in
            for barcode in barcodes {
                // Verification (qr code appartenant bien à qqn...)
                // Barcode found
                let alertController = UIAlertController(title: "Rajouter des points", message: "Choisis un nombre de points à rajouter à Célestin", preferredStyle: .alert)
                alertController.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "Nombre de points"
                    textField.keyboardType = .decimalPad
                })
                alertController.addAction(UIAlertAction(title: "Terminé", style: .default, handler: { (action) in
                    // Web : Ajout des points
                    let nb_points_rajout = alertController.textFields?.first?.text // A convertir en nombre (int ou double)
                    /// ...
                }))
                alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animationView = LOTAnimationView(name: "qrcode")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.contentMode = .scaleAspectFit

      //  self.animationView.play()

        
        let alertVC = PMAlertController(title: "Scan de QR Code", description: "Scanne le QR Code pour lui ajouter des points", image: nil, style: .alert)
        alertVC.addAction(PMAlertAction(title: "Compris !", style: .default))
        alertVC.headerView = animationView
       // self.present(alertVC, animated: true, completion: nil)
        self.present(alertVC, animated: true) {
            self.animationView.play()
        }
        
        
    }
    

    

}
