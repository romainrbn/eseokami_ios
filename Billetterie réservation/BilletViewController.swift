//
//  BilletViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 19/02/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class BilletViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var heures = ["17h45", "18h45"]
    var categories = ["Laser Game", "PaintBall"]
    var toolBar = UIToolbar()
    var ref: DatabaseReference!
    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "mesReservationsPage") as? MaReservationViewController
    
    var nodeCount17PaintBall: Int = 0
    var nodeCount17Laser: Int = 0
    
    var nodeCount18PaintBall: Int = 0
    var nodeCount18Laser: Int = 0
    
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var alertController: UIAlertController!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return heures.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return heures.count
        }
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return heures[row]
        }
        return categories[row]
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
        let heureSelected = heures[picker.selectedRow(inComponent: 0)]
        let categorieSelected = categories[picker.selectedRow(inComponent: 1)]
        alertController.textFields?.first!.text = "\(heureSelected), \(categorieSelected)"
        
    }
    

    
    
    let ref17 = Database.database().reference().child("reservations").child("17h45")
    let ref18 = Database.database().reference().child("reservations").child("18h45")
    
    var picker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
     //   let ref17 = ref.child("reservations").child("17h45")
        
        ref17.observe(.value) { (snapshot) in
            print("NBR OF ITEMS: \(snapshot.childrenCount)")
        }
      
        
       
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.object(forKey: "userEmail") != nil {
            nomLabel.text = UserDefaults.standard.object(forKey: "userFullName") as! String
            emailLabel.text = UserDefaults.standard.object(forKey: "userEmail") as! String
        } else {
            nomLabel.text = "Connecte-toi pour commander ta navette !"
            emailLabel.text = ""
        }
    }
    
    @IBAction func reserver(_ sender: Any) {
        let heureSelected = heures[picker.selectedRow(inComponent: 0)]
        let categorieSelected = categories[picker.selectedRow(inComponent: 1)]
        
        let ref17PaintBall = ref17.child("PaintBall")
        let ref17Laser = ref17.child("LaserGame")
        
        let ref18PaintBall = ref18.child("PaintBall")
        let ref18Laser = ref18.child("LaserGame")
        
        // Observe the values
        ref17PaintBall.child("reservations").observe(.value) { (snapshot) in
            self.nodeCount17PaintBall = Int(snapshot.childrenCount)
        }
        
        ref17Laser.child("reservations").observe(.value) { (snapshot) in
            self.nodeCount17Laser = Int(snapshot.childrenCount)
        }
        
        ref18Laser.child("reservations").observe(.value) { (snapshot) in
            self.nodeCount18Laser = Int(snapshot.childrenCount)
        }
        
        ref18PaintBall.child("reservations").observe(.value) { (snapshot) in
            self.nodeCount18PaintBall = Int(snapshot.childrenCount)
        }
        
        if UserDefaults.standard.object(forKey: "userFullName") != nil {
            alertController = UIAlertController(title: "Valider la réservation", message: "Choisis une heure de navette pour valider ta réservation.", preferredStyle: .alert)
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Choisis ton horaire"
                textField.inputView = self.picker
                textField.text = "\(heureSelected), \(categorieSelected)"
                self.picker.delegate = self
                self.picker.dataSource = self
                self.picker.selectRow(0, inComponent: 0, animated: true)
            }
            
            let reserverAction = UIAlertAction(title: "Réserver", style: .destructive, handler: { (alert) in
                if (self.alertController.textFields?[0].text!.isEmpty)! {
                    //  let alertController = //
                    self.alertController.textFields?[0].layer.borderWidth = 1
                    self.alertController.textFields?[0].layer.borderColor = UIColor.red.cgColor
                } else if (self.nodeCount18PaintBall + self.nodeCount18Laser + self.nodeCount17Laser + self.nodeCount17PaintBall < 240) {
                    // Si la tf n'est pas vide
                    let connectedRef = Database.database().reference(withPath: ".info/connected")
                    connectedRef.observe(.value, with: { (snapshot) in
                        if let connected = snapshot.value as? Bool, connected {
                            let selectedRowHeure = self.picker.selectedRow(inComponent: 0)
                            let selectedRowActivite = self.picker.selectedRow(inComponent: 1)
                            self.ref = Database.database().reference()
                            if (selectedRowHeure == 0) && (selectedRowActivite == 0) {
                                if self.nodeCount17Laser >= 60 {
                                    print("Réservation impossible")
                                    let alertController = UIAlertController(title: "Impossible de réserver", message: "Désolés, toutes les places pour cet horaire ont déjà été prises... Essaies une autre heure ou une autre activité", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alertController, animated: true, completion: nil)
                                } else {
                                    print("Réservation possible")
                                    
                                    ref17Laser.child("reservations").child(UserDefaults.standard.value(forKey: "userFullName") as! String).setValue("reservation")
                                    UserDefaults.standard.set("Laser Game", forKey: "activiteShocker")
                                    UserDefaults.standard.set("17h45", forKey: "HeureNavette")
                                    self.navigationController?.pushViewController(self.vc!, animated: true)
                                    
                                }
                                
                            } else if (selectedRowHeure == 0) && (selectedRowActivite == 1) {
                                if self.nodeCount17PaintBall >= 60 {
                                    print("Réservation impossible")
                                    let alertController = UIAlertController(title: "Impossible de réserver", message: "Désolés, toutes les places pour cet horaire ont déjà été prises... Essaies une autre heure ou une autre activité", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alertController, animated: true, completion: nil)
                                } else {
                                    print("Réservation possible")
                                    ref17PaintBall.child("reservations").child(UserDefaults.standard.value(forKey: "userFullName") as! String).setValue("reservation")
                                    UserDefaults.standard.set("Paint Ball", forKey: "activiteShocker")
                                    UserDefaults.standard.set("17h45", forKey: "HeureNavette")
                                    self.navigationController?.pushViewController(self.vc!, animated: true)
                                    
                                }
                                
                            } else if (selectedRowHeure == 1) && (selectedRowActivite == 0) {
                                if self.nodeCount18Laser >= 60 {
                                    print("Réservation impossible")
                                    let alertController = UIAlertController(title: "Impossible de réserver", message: "Désolés, toutes les places pour cet horaire ont déjà été prises... Essaies une autre heure ou une autre activité", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alertController, animated: true, completion: nil)
                                } else {
                                    print("Réservation possible")
                                    ref18Laser.child("reservations").child(UserDefaults.standard.value(forKey: "userFullName") as! String).setValue("reservation")
                                    UserDefaults.standard.set("Laser Game", forKey: "activiteShocker")
                                    UserDefaults.standard.set("18h45", forKey: "HeureNavette")
                                    self.navigationController?.pushViewController(self.vc!, animated: true)
                                }
                                
                            } else if (selectedRowHeure == 1) && (selectedRowActivite == 1) {
                                if self.nodeCount18PaintBall >= 60 {
                                    print("Réservation impossible")
                                    let alertController = UIAlertController(title: "Impossible de réserver", message: "Désolés, toutes les places pour cet horaire ont déjà été prises... Essaies une autre heure ou une autre activité", preferredStyle: .alert)
                                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    self.present(alertController, animated: true, completion: nil)
                                } else {
                                    print("Réservation possible")
                                    ref18PaintBall.child("reservations").child(UserDefaults.standard.value(forKey: "userFullName") as! String).setValue("reservation")
                                    UserDefaults.standard.set("Paint Ball", forKey: "activiteShocker")
                                    UserDefaults.standard.set("18h45", forKey: "HeureNavette")
                                    self.navigationController?.pushViewController(self.vc!, animated: true)
                                }
                                
                            }
                        } else {
                            let alertController = UIAlertController(title: "Erreur", message: "Tu ne semble pas être connecté à Internet...", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                    
                    // reserver
                } else {
                    let alertController = UIAlertController(title: "Réservation impossible", message: "Désolés, toutes les places de navettes ont déjà été réservées...", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK...", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
            
            alertController.addAction(reserverAction)
            alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
            
            
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Erreur", message: "Tu dois être connecté pour réserver", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Se connecter", style: .default, handler: { (action) in
                // pop connexion
                self.performSegue(withIdentifier: "showConnexionShocker", sender: self)
            }))
            
            alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
  
    
    
    

}
