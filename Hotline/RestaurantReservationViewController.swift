//
//  RestaurantReservationViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 22/02/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import Eureka
import CoreLocation
import MessageUI
import FirebaseDatabase

class RestaurantReservationViewController: FormViewController, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var commanderButton: UIBarButtonItem!
    let locationManager = CLLocationManager()
    var currentAdress: String = ""
    var restaurantReservation = Restaurant(nom: "", coordinates: CLLocationCoordinate2D(), numero: [], path: "", livreurs: [])
    var commandeToReserve: Commande!
    
    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "maCommandePage") as? MaCommandeViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commanderButton.isEnabled = false
        
        self.title = restaurantReservation.nom
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        
        form +++ Section("Tes informations pour la commande")
            <<<  NameRow() { row in
                row.title = "Prénom"
                row.tag = "prenom"
                row.validationOptions = .validatesOnChange
                row.add(rule: RuleRequired())
                row.placeholder = "Entre ton prénom ici"
                }.cellUpdate({ (cell, row) in
                    if !row.isValid && row.wasChanged {
                        self.commanderButton.isEnabled = false
                    } else {
                        self.commanderButton.isEnabled = true
                    }
                })
            <<< NameRow() { row in
                row.title = "Nom"
                row.tag = "nom"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                row.placeholder = "Entre ton nom ici"
                }.cellUpdate({ (cell, row) in
                    if !row.isValid && row.wasChanged {
                        self.commanderButton.isEnabled = false
                    } else {
                        self.commanderButton.isEnabled = true
                    }
                })
            <<< PhoneRow() { row in
                row.tag = "numTel"
                row.title = "Mon num. de téléphone"
                row.add(rule: RuleRequired())
                row.placeholder = "Entre ton numéro ici"
                row.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid && row.wasChanged {
                        self.commanderButton.isEnabled = false
                    } else {
                        self.commanderButton.isEnabled = true
                    }
                })
           
            
            <<< TextAreaRow() { row in
                row.tag = "adresseEntree"
                row.title = "Entre ton adresse ici"
                row.add(rule: RuleRequired())
                row.placeholder = "Entre ton adresse ici"
                row.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid && row.wasChanged {
                        self.commanderButton.isEnabled = false
                    } else {
                        self.commanderButton.isEnabled = true
                    }
                })
        
        
        form +++ Section("Informations supplémentaires pour la livraison")
                <<< TextAreaRow() { row in
                row.tag = "InfosSupp"
                row.title = "Informations supplémentaires pour la livraison"
                row.placeholder = "Étage, interphone..."
        }
        
        form +++ Section("Ta commande")
            <<< TextAreaRow() { row in
                row.tag = "commandeString"
                row.title = "Dis nous ce que tu souhaites commander chez McDonalds Boulevard Foch"
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                row.placeholder = "Entre ta commande ici. Sois le plus détaillé possible (menus, quantité...). Assure-toi que ta commande ne dépasse pas 10€, et on te l'apporte gratuitement 🐉"
                }.cellUpdate({ (cell, row) in
                    if !row.isValid && row.wasChanged {
                        self.commanderButton.isEnabled = false
                    } else {
                        self.commanderButton.isEnabled = true
                    }
                })
        
        

        
    }
    
    

    
    @IBAction func commander(_ sender: Any) {
        let nomRow: NameRow? = form.rowBy(tag: "nom")
        let numRow: PhoneRow? = form.rowBy(tag: "numTel")
        let prenomRow: NameRow? = form.rowBy(tag: "prenom")
        let adresseRow: TextAreaRow? = form.rowBy(tag: "adresseEntree")
        let infosSupRow: TextAreaRow? = form.rowBy(tag: "InfosSupp")
        let commandeRow: TextAreaRow? = form.rowBy(tag: "commandeString")
        
        
        if (nomRow?.value == nil) || (prenomRow?.value == nil) || (numRow?.value == nil) || (adresseRow?.value == nil) || (commandeRow?.value == nil) {
            let alertController = UIAlertController(title: "Erreur", message: "Pense à bien renseigner tous les champs pour valider ta commande", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            let nom = nomRow?.value!
            let num = numRow?.value!
            let prenom = prenomRow?.value!
            let adresse = (adresseRow?.value!)!
            let infosSupp = infosSupRow?.value
            let commande = commandeRow?.value
            
            // Envoyer commande a db (objet commande). (avec Restaurant)
            if infosSupp == nil {
                let envoiCommande = Commande(nom: nom!, prenom: prenom!, adresse: adresse, infos: nil, commande: commande!, tel: num!, restaurantName: restaurantReservation.nom, restaurantCoordinates: restaurantReservation.coordinates, restaurant: restaurantReservation, livreurs: restaurantReservation.livreurs,state: .preparation)
                
                let ref = Database.database().reference().child("Commandes").child(restaurantReservation.path as! String).childByAutoId()
                ref.child("nom").setValue(envoiCommande.nom)
                ref.child("prenom").setValue(envoiCommande.prenom)
                ref.child("adresse").setValue(envoiCommande.adresse)
                ref.child("tel").setValue(envoiCommande.tel)
                ref.child("restaurant").setValue(envoiCommande.restaurantName)
                ref.child("restaurantCoordinates").setValue(envoiCommande.restaurantCoordinates)
                
                switch envoiCommande.state {
                case .preparation:
                    ref.child("etat").setValue("preparation")
                case .priseEnCharge:
                    ref.child("etat").setValue("priseEnChrage")
                case .impossible:
                    ref.child("etat").setValue("impossible")
                case .livree:
                    ref.child("etat").setValue("livree")
                }
                for i in 0...(envoiCommande.restaurant.numero.count - 1) {
                    ref.child("numero_livreur\(i)").setValue(envoiCommande.restaurant.numero[i])
                }
                
                ref.child("commandes").setValue(envoiCommande.commande) { (error, ref) in
                    if let error = error {
                        
                    } else {
                        self.commandeToReserve = Commande(nom: envoiCommande.nom, prenom: envoiCommande.prenom, adresse: envoiCommande.adresse, infos: nil, commande: envoiCommande.commande, tel: envoiCommande.tel, restaurantName: envoiCommande.restaurantName, restaurantCoordinates: envoiCommande.restaurantCoordinates, restaurant: self.restaurantReservation, livreurs: self.restaurantReservation.livreurs, state: .preparation)
                        
                        let lat = Double(envoiCommande.restaurantCoordinates.latitude)
                        let long = Double(envoiCommande.restaurantCoordinates.longitude)
                        
                        let loc = ["lat":lat, "long":long]
                        
                        
                        UserDefaults.standard.set(true, forKey: "hasReservedHotline")
                        UserDefaults.standard.set(self.commandeToReserve.restaurantName, forKey: "commandeHotlineReserveeRestNom")
                        UserDefaults.standard.set(loc, forKey: "commandeHotlineReserveeRestCoordinates")
                        UserDefaults.standard.set(self.commandeToReserve.nom, forKey: "commandeHotlineReserveeNom")
                        UserDefaults.standard.set(self.commandeToReserve.prenom, forKey: "commandeHotlineReserveePrenom")
                        UserDefaults.standard.set(self.commandeToReserve.tel, forKey: "commandeHotlineReserveeTel")
                        UserDefaults.standard.set(self.commandeToReserve.commande, forKey: "commandeHotlineReserveeCommande")
                        UserDefaults.standard.set(self.commandeToReserve.adresse, forKey: "commandeHotlineReserveeAdresse")
                        UserDefaults.standard.set(self.commandeToReserve.livreurs, forKey: "commandeHotlineLivreurs")
                        
                        self.performSegue(withIdentifier: "showCommandeState", sender: self)
                    }
                   
                }
                
                
                
            } else {
                let envoiCommande = Commande(nom: nom!, prenom: prenom!, adresse: adresse, infos: infosSupp!, commande: commande!, tel: num!, restaurantName: restaurantReservation.nom, restaurantCoordinates: restaurantReservation.coordinates, restaurant: restaurantReservation, livreurs: restaurantReservation.livreurs, state: .preparation)
                let ref = Database.database().reference().child("Commandes").child(restaurantReservation.path as! String).childByAutoId()
                ref.child("nom").setValue(envoiCommande.nom)
                ref.child("prenom").setValue(envoiCommande.prenom)
                ref.child("adresse").setValue(envoiCommande.adresse)
                ref.child("tel").setValue(envoiCommande.tel)
                ref.child("restaurant").setValue(envoiCommande.restaurantName)
              
                ref.child("infos_supp").setValue(envoiCommande.infos)
           
                for i in 0...(envoiCommande.restaurant.numero.count - 1) {
                    ref.child("numero_livreur\(i)").setValue(envoiCommande.restaurant.numero[i])
                }
                switch envoiCommande.state {
                case .preparation:
                    ref.child("etat").setValue("preparation")
                case .priseEnCharge:
                    ref.child("etat").setValue("priseEnChrage")
                case .impossible:
                    ref.child("etat").setValue("impossible")
                case .livree:
                    ref.child("etat").setValue("livree")
                }
                ref.child("commandes").setValue(envoiCommande.commande) { (error, ref) in
                    if let error = error {
                        let alertController = UIAlertController(title: "Erreur", message: "Nous n'avons pas pu enregistrer ta commande pour le moment...", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                        self.commandeToReserve = Commande(nom: envoiCommande.nom, prenom: envoiCommande.prenom, adresse: envoiCommande.adresse, infos: envoiCommande.infos, commande: envoiCommande.commande, tel: envoiCommande.tel, restaurantName: envoiCommande.restaurantName, restaurantCoordinates: envoiCommande.restaurantCoordinates, restaurant: envoiCommande.restaurant, livreurs: envoiCommande.livreurs, state: envoiCommande.state)
                        
                        
                        
                        let lat = Double(envoiCommande.restaurantCoordinates.latitude)
                        let long = Double(envoiCommande.restaurantCoordinates.longitude)
                        
                        let loc = ["lat":lat, "long":long]
                        
                        
                        
                        UserDefaults.standard.set(true, forKey: "hasReservedHotline")
                        UserDefaults.standard.set(self.commandeToReserve.restaurantName, forKey: "commandeHotlineReserveeRestNom")
                        UserDefaults.standard.set(loc, forKey: "commandeHotlineReserveeRestCoordinates")
                        UserDefaults.standard.set(self.commandeToReserve.nom, forKey: "commandeHotlineReserveeNom")
                        UserDefaults.standard.set(self.commandeToReserve.prenom, forKey: "commandeHotlineReserveePrenom")
                        UserDefaults.standard.set(self.commandeToReserve.tel, forKey: "commandeHotlineReserveeTel")
                        UserDefaults.standard.set(self.commandeToReserve.commande, forKey: "commandeHotlineReserveeCommande")
                        UserDefaults.standard.set(self.commandeToReserve.adresse, forKey: "commandeHotlineReserveeAdresse")
                        UserDefaults.standard.set(self.commandeToReserve.infos, forKey: "commandeHotlineReserveeInfos")
                        UserDefaults.standard.set(self.commandeToReserve.livreurs, forKey: "commandeHotlineLivreurs")
                        
                        self.performSegue(withIdentifier: "showCommandeState", sender: self)
                    }
                }
                
                
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! MaCommandeViewController
        
        if segue.identifier == "showCommandeState" {
            destinationViewController.commandeReservee = commandeToReserve
        }
        
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    

}
