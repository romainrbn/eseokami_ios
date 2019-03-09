//
//  SideMenuTableViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 14/12/2018.
//  Copyright © 2018 Romain Rabouan. All rights reserved.
//

import UIKit
import BLTNBoard
import FirebaseAuth
import FirebaseDatabase
import AVFoundation
import QRCodeReader
import Lottie
import PMAlertController
import NYAlertViewController
import PKHUD

class SideMenuTableViewController: UITableViewController, QRCodeReaderViewControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var hotlineCell: UITableViewCell!
    @IBOutlet weak var maCommande: UITableViewCell!
    @IBOutlet weak var billeterie: UITableViewCell!
    @IBOutlet weak var mesReservations: UITableViewCell!
    @IBOutlet weak var mesCommandesCell: UITableViewCell!
    @IBOutlet weak var connectCell: UITableViewCell!
    var alertController: UIAlertController!
    var animationView = LOTAnimationView()
    // Speciale chef a changer (ici 100)
    let systemePoints: [[String: Any]] = [["nom": "Les délices d'Uzume", "value": 25], ["nom": "L'Assault d'Hachiman", "value": 50], ["nom": "La route d'Izanami", "value": 20],["nom": "La pêche de Momotaro", "value": 10],["nom": "Kandama", "value": 20],["nom": "Hanafuda", "value": 5], ["nom": "Sumo", "value": 10], ["nom": "Otadama", "value": 10], ["nom": "Fukuwaraï", "value": 25], ["nom": "Daruma Otoshi", "value": 25], ["nom": "Les verres de Shojo", "value": 25],["nom": "Shinigami 21", "value": 25], ["nom": "La quête d'Ishikawa", "value": 50], ["nom": "Beer-pong", "value": 10], ["nom": "Devine-tête", "value": 10]]
    var initValue: Int = 0
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        alertController.textFields?.first!.text! = "Nombre de pts: \(systemePoints[row]["value"]!)"
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return systemePoints.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return systemePoints[row]["nom"] as! String
    }
    
    @IBOutlet weak var decLabel: UILabel!
    
    let menuItemsNames = ["La liste", "Activités", "Programme de la semaine", "Hotline", "Contact", "Cafet", "Notre programme", "Sponsors", "Vidéo de campagne", "Compte", "Déconnexion"]
    
    let sb = UIStoryboard(name: "Main", bundle: nil)
    
    
    let vcs = ["VC0", "VC1"]
    
    let page = QRCodePageItem(title: "Ton QR Code")
    let pageNoAccount = BLTNPageItem(title: "Connecte-toi")
    var refUsers: DatabaseReference!
    let pageInscription = InscriptionPageItem(title: "Connexion")
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            $0.showTorchButton        = true
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = true
            $0.cancelButtonTitle      = "Annuler"
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    lazy var QRBulletinManager: BLTNItemManager = {
        page.descriptionText = "Voici ton QR Code. Utilise-le lors d'activités ou pour récupérer ton repas commandé."
        page.requiresCloseButton = true
        page.isDismissable = true
        page.actionButtonTitle = "Fermer"
        page.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }

        let rootItem: BLTNItem = page
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    lazy var noAccountManager: BLTNItemManager = {
        pageNoAccount.descriptionText = "Pour afficher ton QR Code ESEOKAMI, connecte-toi à l'application avec ton compte Eseo !"
        pageNoAccount.requiresCloseButton = true
        pageNoAccount.isDismissable = true
        pageNoAccount.actionButtonTitle = "Se connecter"
        pageNoAccount.alternativeButtonTitle = "Pas maintenant"
        pageNoAccount.actionHandler = { item in
            let ib = UIStoryboard(name: "Main", bundle: nil)
            let vc = self.sb.instantiateViewController(withIdentifier: "connexionId")
            item.manager?.present(vc, animated: true)
          //  item.manager?.dismissBulletin(animated: true)
         //  SideMenuTableViewController().performSegue(withIdentifier: "showCoSide", sender: self)
        }
        pageNoAccount.alternativeHandler = { item in
            item.manager?.dismissBulletin(animated: true)
            
        }
        let rootItem: BLTNItem = pageNoAccount
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    lazy var connectionManager: BLTNItemManager = {
        // MARK: Page inscription
        pageInscription.descriptionText = "Connecte toi pour connaître ton score et profiter de plein d'autres fonctions !"
        pageInscription.actionButtonTitle = "Valider"
        pageInscription.isDismissable = false
        pageInscription.alternativeButtonTitle = "Pas maintenant"
        pageInscription.requiresCloseButton = false
        DispatchQueue.main.async {
            
            // - MARK : Implementation ESEO a faire ici
            
            self.pageInscription.actionHandler = { item in
                
                if self.pageInscription.textField.text!.hasSuffix("@reseau.eseo.fr") { // ET && succes de connexion au systeme ESEO
                    // en cas de succes de connexion au systeme ESEO
                    
                    item.manager?.displayActivityIndicator()
                    self.refUsers = Database.database().reference().child("users")
                    let key = self.refUsers.childByAutoId().key
                    let user = ["username:":self.pageInscription.textField.text!]
                    self.refUsers.child(key!).setValue(user)
                    // MARK: Firebase Auth
                    
                    Auth.auth().createUser(withEmail: self.pageInscription.textField.text!, password: self.pageInscription.textFieldMdp.text!, completion: { (user, error) in
                        if error == nil {
                            Auth.auth().signIn(withEmail: self.pageInscription.textField.text!, password: self.pageInscription.textFieldMdp.text!, completion: { (result, error) in
                                print("User connected")
                                self.tableView.reloadData()
                            })
                        }
                        
                    })
                    
                    
                    item.manager?.dismissBulletin(animated: true)
                } else {
                    let alertCont = UIAlertController(title: "Erreur", message: "Veuillez entrer une adresse Eseo valide.", preferredStyle: .alert)
                    let actionCancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertCont.addAction(actionCancel)
                    item.manager?.present(alertCont, animated: true, completion: nil)
                    
                }
            }
        }
        
        pageInscription.alternativeHandler = { item in
            let alertController = UIAlertController(title: "Êtes-vous sûr ?", message: "Vous ne pourrez pas commander à la cafètéria ou gagner des points sur les activités.", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ne pas se connecter", style: .destructive, handler: { (action) in
                item.manager?.dismissBulletin(animated: true)
            })
            
            let actionCancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
            alertController.addAction(action1)
            alertController.addAction(actionCancel)
            self.connectionManager.present(alertController, animated: true, completion: nil)
        }
        let rootItem: BLTNItem = pageInscription
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        tableView.reloadData()
        
        if UserDefaults.standard.object(forKey: "userFullName") == nil {
            decLabel.text = "Connexion"
        } else {
            decLabel.text = "Déconnexion"
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
     
        tableView.showsVerticalScrollIndicator = false
        
        
        
        
        // Refresh control
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        print(ConnexionVariables.isMembreBDE)
        print(ConnexionVariables.isLivreurHotline)
        
        
        
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (ConnexionVariables.isMembreBDE == false) || (ConnexionVariables.isLivreurHotline == false) {
            mesCommandesCell.isHidden = true
            //  mesCommandesCell.isHidden = false
        } else if (ConnexionVariables.isMembreBDE == true) && (ConnexionVariables.isLivreurHotline == true)  {
            mesCommandesCell.isHidden = false
            
            //  mesCommandesCell.isHidden = true
            //    tableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
            //    tableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }
        
        if UserDefaults.standard.object(forKey: "activiteShocker") != nil {
            mesReservations.isHidden = false
            billeterie.isHidden = true
        } else {
            mesReservations.isHidden = true
            billeterie.isHidden = false
        }
        
        if UserDefaults.standard.bool(forKey: "hasReservedHotline") == true {
            maCommande.isHidden = false
            hotlineCell.isHidden = true
        } else {
            maCommande.isHidden = true
            hotlineCell.isHidden = false
        }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    


    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UserDefaults.standard.bool(forKey: "hasReservedHotline") == true {
            if indexPath.row == 8 {
                return 0
            }
        } else {
            if indexPath.row == 4 {
                return 0
            }
        }
        
        if UserDefaults.standard.object(forKey: "activiteShocker") != nil {
            
            if (ConnexionVariables.isMembreBDE == false) && (ConnexionVariables.isLivreurHotline == false) {
                if indexPath.row == 1 {
                    return 0
                } else if indexPath.row == 7 {
                    return 0
                } else {
                    return 85
                }
                
            } else if (ConnexionVariables.isMembreBDE == true) && (ConnexionVariables.isLivreurHotline == false) {
                
                if indexPath.row == 1 {
                    return 0
                } else if indexPath.row == 7 {
                    return 0
                } else {
                    return 85
                }
            } else if (ConnexionVariables.isMembreBDE == true) && (ConnexionVariables.isLivreurHotline == true) {
                if indexPath.row == 7 {
                    return 0
                } else {
                    return 85
                }
                
            }
        } else {
            if (ConnexionVariables.isMembreBDE == false) && (ConnexionVariables.isLivreurHotline == false) {
                if indexPath.row == 1 {
                    return 0
                } else if indexPath.row == 2 {
                    return 0
                } else {
                    return 85
                }
                
            } else if (ConnexionVariables.isMembreBDE == true) && (ConnexionVariables.isLivreurHotline == false) {
                
                if indexPath.row == 1 {
                    return 0
                } else if indexPath.row == 2 {
                    return 0
                } else {
                    return 85
                }
            } else if (ConnexionVariables.isMembreBDE == true) && (ConnexionVariables.isLivreurHotline == true) {
                if indexPath.row == 2 {
                    return 0
                } else {
                    return 85
                }
                
            }
        }
        
       
        
        return 0
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Deselectionne le rang une fois touché
        // TODO : Ouvrir VC correspondant, fermer menu latéral
        
        if ConnexionVariables.isMembreBDE && ConnexionVariables.isLivreurHotline {
            
            if UserDefaults.standard.object(forKey: "activiteShocker") != nil {
                if indexPath.row == 14 {
                    if UserDefaults.standard.object(forKey: "userFullName") == nil {
                        let controller = self.sb.instantiateViewController(withIdentifier: "connexionId")
                        self.present(controller, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "Êtes-vous sûr ?", message: "Voulez-vous vraiment vous déconnecter ?", preferredStyle: .alert)
                        let actionLogOut = UIAlertAction(title: "Déconnexion", style: .destructive) { (alert) in
                            let userDef = UserDefaults.standard
                            userDef.set(nil, forKey: "userID")
                            userDef.set(nil, forKey: "userFirstName")
                            
                            userDef.set(nil, forKey: "userFullName")
                            let controller = self.sb.instantiateViewController(withIdentifier: "connexionId")
                            self.present(controller, animated: true, completion: nil)
                            print("Déconnecté")
                        }
                        let actionCancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
                        alertController.addAction(actionLogOut)
                        alertController.addAction(actionCancel)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                }
            } else {
                if indexPath.row == 14 {
                    if UserDefaults.standard.object(forKey: "userFullName") == nil {
                        let controller = self.sb.instantiateViewController(withIdentifier: "connexionId")
                        self.present(controller, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "Êtes-vous sûr ?", message: "Voulez-vous vraiment vous déconnecter ?", preferredStyle: .alert)
                        let actionLogOut = UIAlertAction(title: "Déconnexion", style: .destructive) { (alert) in
                            let userDef = UserDefaults.standard
                            userDef.set(nil, forKey: "userID")
                            userDef.set(nil, forKey: "userFirstName")
                            
                            userDef.set(nil, forKey: "userFullName")
                            let controller = self.sb.instantiateViewController(withIdentifier: "connexionId")
                            self.present(controller, animated: true, completion: nil)
                            print("Déconnecté")
                        }
                        let actionCancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
                        alertController.addAction(actionLogOut)
                        alertController.addAction(actionCancel)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                }
            }
            
        } else {
            
            
            
            if UserDefaults.standard.object(forKey: "activiteShocker") != nil {
                if indexPath.row == 14 {
                    if UserDefaults.standard.object(forKey: "userFullName") == nil {
                        let controller = self.sb.instantiateViewController(withIdentifier: "connexionId")
                        self.present(controller, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "Êtes-vous sûr ?", message: "Voulez-vous vraiment vous déconnecter ?", preferredStyle: .alert)
                        let actionLogOut = UIAlertAction(title: "Déconnexion", style: .destructive) { (alert) in
                            let userDef = UserDefaults.standard
                            userDef.set(nil, forKey: "userID")
                            userDef.set(nil, forKey: "userFirstName")
                            
                            userDef.set(nil, forKey: "userFullName")
                            let controller = self.sb.instantiateViewController(withIdentifier: "connexionId")
                            self.present(controller, animated: true, completion: nil)
                            print("Déconnecté")
                        }
                        let actionCancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
                        alertController.addAction(actionLogOut)
                        alertController.addAction(actionCancel)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            } else {
                if indexPath.row == 14 {
                    if UserDefaults.standard.object(forKey: "userFullName") == nil {
                        let controller = self.sb.instantiateViewController(withIdentifier: "connexionId")
                        self.present(controller, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "Êtes-vous sûr ?", message: "Voulez-vous vraiment vous déconnecter ?", preferredStyle: .alert)
                        let actionLogOut = UIAlertAction(title: "Déconnexion", style: .destructive) { (alert) in
                            let userDef = UserDefaults.standard
                            userDef.set(nil, forKey: "userID")
                            userDef.set(nil, forKey: "userFirstName")
                            
                            userDef.set(nil, forKey: "userFullName")
                            let controller = self.sb.instantiateViewController(withIdentifier: "connexionId")
                            self.present(controller, animated: true, completion: nil)
                            print("Déconnecté")
                        }
                        let actionCancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
                        alertController.addAction(actionLogOut)
                        alertController.addAction(actionCancel)
                        self.present(alertController, animated: true, completion: nil)
                    }
                    
                }
            }
            
        }
        
    }
    
    func checkIfUserHasPoints(userid: String, completionHandler: @escaping (Bool) -> ())
     {
        
        let ref1 = Database.database().reference().child("scores").child(userid)
        ref1.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("score") {
                self.initValue = snapshot.childSnapshot(forPath: "score").value as! Int
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }, withCancel: nil)
    }
    
    func check(str: String) -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        var texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        var capitalresult = texttest.evaluate(with: str)
        
        let specialCharacterRegEx  = ".*[.]+.*"
        var texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        
        var specialresult = texttest2.evaluate(with: str)
        
        return !capitalresult && specialresult
    }
    
    
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        if check(str: result.value) == false {
            let av = NYAlertViewController()
            av.title = "Erreur"
            
            av.message = "Ce QR Code ne semble pas être conforme 🤔🐉"
            av.addAction(NYAlertAction(title: "OK", style: .default, handler: { (action) in
                av.dismiss(animated: true, completion: nil)
            })!)
            av.buttonColor = UIColor(red: 229/255, green: 34/255, blue: 34/255, alpha: 1)
            readerVC.present(av, animated: true, completion: nil)
        } else {
            let nom = result.value.replacingOccurrences(of: ".", with: " ").capitalized
            var picker = UIPickerView()
            picker.delegate = self
            picker.dataSource = self
            
            
            alertController = UIAlertController(title: "Ajouter des points", message: "Choisis ton activité actuelle pour ajouter des points à \(nom)", preferredStyle: .alert)
            alertController.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Choisis un nombre de points"
                textField.inputView = picker
            })
            alertController.addAction(UIAlertAction(title: "Terminé", style: .default, handler: { (action) in
                
                // Ajouter le nombre de points a l'API
                self.initValue = 0
                let t = self.systemePoints[picker.selectedRow(inComponent: 0)]["value"] as! Int
                let tfText = Int((self.alertController.textFields?.first!.text!)!)
                let uid = result.value
                let uidOkForFirebase = uid.replacingOccurrences(of: ".", with: " ")
                
                let ref = Database.database().reference().child("scores").child(uidOkForFirebase).child("score")
                
                
                self.checkIfUserHasPoints(userid: uidOkForFirebase, completionHandler: { (isRegistered) in
                    if isRegistered {
                        ref.setValue(self.initValue + t, withCompletionBlock: { (error, databaseRef) in
                            if let _ = error {
                                HUD.flash(.error, delay: 1.0)
                                reader.startScanning()
                            } else {
                                HUD.flash(.success, delay: 1.0)
                                reader.startScanning()
                            }
                        })
                    } else {
                        ref.setValue(t, withCompletionBlock: { (error, databaseRef) in
                            if let _ = error {
                                HUD.flash(.error, delay: 1.0)
                                reader.startScanning()
                            } else {
                                HUD.flash(.success, delay: 1.0)
                                reader.startScanning()
                            }
                        })
                    }
                })
                
                
                
                
            }))
            alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
            self.readerVC.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func showQRCode(_ sender: Any) {
        let uid = UserDefaults.standard.object(forKey: "userID")
        
        if ConnexionVariables.isMembreBDE { // Si l'user connecté est membre EseoKami
            // Affichage du scanner de QRCode
            readerVC.delegate = self
            
            readerVC.modalPresentationStyle = .formSheet
            present(readerVC, animated: true, completion: nil)
            
            
            animationView = LOTAnimationView(name: "qrcode")
            animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            animationView.contentMode = .scaleAspectFit
            animationView.loopAnimation = true
            
            //  self.animationView.play()
            
            let av = NYAlertViewController()
            av.title = "Scan de QR Code"
            
            av.message = "Scanne le QR Code pour ajouter des points"
            av.addAction(NYAlertAction(title: "Compris !", style: .default, handler: { (action) in
                UserDefaults.standard.set("done", forKey: "explicationsDone")
                av.dismiss(animated: true, completion: nil)
            })!)
            av.buttonColor = UIColor(red: 229/255, green: 34/255, blue: 34/255, alpha: 1)
            av.alertViewContentView = animationView
            if UserDefaults.standard.object(forKey: "explicationsDone") == nil {
                readerVC.present(av, animated: true) {
                    self.animationView.play()
                }
            }
            
            

        
        } else if let _ = uid {
            QRBulletinManager.showBulletin(above: self)
        } else {
            noAccountManager.showBulletin(above: self)
        }
        
    }
    
    @IBAction func unwindToHomeScreen(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    
    

}

// Modifié en fonction du compte qui sera connecté
struct ConnexionVariables {
    static var isMembreBDE = true
    static var isLivreurHotline = true
}
