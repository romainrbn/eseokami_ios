//
//  QRViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 28/12/2018.
//  Copyright © 2018 Romain Rabouan. All rights reserved.
//


// Pour chaque activité, dans menu admin, un menu rajouter des points et scan du QR et rajout


// Admin : Inscrit nbre de points a donner. genere un qr code avec les points. le mec scanne et recoit les points

import UIKit

class QRViewController: UIViewController {
    // QR CODE DYNAMIQUE ?
    // QR créé avec les données suivantes :
    // Nombre de points : 2372
    // Prénom : Jean
    // Nom de famille : Martin
    
    // test
    var prenom = "Jean" // Hard coding
    var nomDeFamille = "Martin" // Firebase
    var nbPoints = 2372 // Firebase
    // end test
    
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var qrImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeMessage.text = "Voici ton QR Code"
        
        qrImage.image = generateQRCode(from: "\(prenom)\n\(nomDeFamille)\n\(nbPoints)")
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.4) {
            UIScreen.main.brightness = 1
        }
        
    }
    
    @IBAction func retour_precedent() {
        self.dismiss(animated: true, completion: nil)
        
        
    }

}
