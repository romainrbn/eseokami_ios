//
//  MaCommandeViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 02/03/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import MapKit

class MaCommandeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nomRestaurant: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var riderButton: UILabel!
    
    var location: CLLocationCoordinate2D!
    
    var locationManager: CLLocationManager!
    
    var center = CLLocationCoordinate2D()
    var span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    
    var commandeReservee: Commande!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var restCoord = UserDefaults.standard.object(forKey: "commandeHotlineReserveeRestCoordinates") as! Dictionary<String, Double>
        let restNom = UserDefaults.standard.object(forKey: "commandeHotlineReserveeRestNom") as! String
        
      //  var adresse = UserDefaults.standard.object(forKey: "commandeHotlineReserveeAdresse") as! String
      //  var infos = ""
       // var commande = UserDefaults.standard.object(forKey: "commandeHotlineReserveeCommande") as! String
        var livreurs = UserDefaults.standard.object(forKey: "commandeHotlineLivreurs") as! Array<String>
        
//        if (UserDefaults.standard.object(forKey: "commandeHotlineReserveeInfos") != nil) {
//            infos = UserDefaults.standard.object(forKey: "commandeHotlineReserveeInfos") as! String
//        } else {
//            infos = ""
//        }
        
        
        let center = CLLocationCoordinate2D(latitude: restCoord["lat"]!, longitude: restCoord["long"]!)
        

        mapView.delegate = self
        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: true)
        
        riderButton.text = "Tes livreurs : \(livreurs[0]), \(livreurs[1])" // TODO: Change
      //  nomRestaurant.text = restNom
        nomRestaurant.text = restNom
      
        
        locationManager = CLLocationManager()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestAlwaysAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        let annot = MKPointAnnotation()
        annot.title = restNom // restNom
        annot.coordinate = center
        mapView.addAnnotation(annot)
    }
    
    @IBAction func needHelp(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Besoin d'aide ?", message: "Indique-nous ton problème avec ta commande 🐲", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Ma commande n'est pas arrivée", style: .default, handler: { (action) in
            // Gérer la commande pas arrivée
        }))
        
        alertController.addAction(UIAlertAction(title: "Je veux annuler ma commande", style: .default, handler: { (action) in
            // Lui indiquer si c'est possible (prise en charge ?)
        }))
        
        alertController.addAction(UIAlertAction(title: "J'ai un autre problème", style: .default, handler: { (action) in
            // Problème
        }))
        
        alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    

    

}

