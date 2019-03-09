//
//  TodayViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 31/12/2018.
//  Copyright © 2018 Romain Rabouan. All rights reserved.
//

import UIKit
import BLTNBoard
import UserNotifications
import FirebaseDatabase
import FirebaseAuth
import SwiftyJSON
import Alamofire

class TodayViewController: UIViewController, UNUserNotificationCenterDelegate {

    // MARK: Properties

    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var numberOfPoints: UILabel!
    @IBOutlet weak var menu_button: UIBarButtonItem!
    @IBOutlet weak var hotlineButton: UIButton!
    @IBOutlet weak var maReservationButton: UIButton!
    @IBOutlet weak var reserverButton: UIButton!
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    
    @IBOutlet weak var labelConseil: UILabel!
    
    
    var jsonData: Data?
    
    
    var reference: DatabaseReference!
    var refUsers: DatabaseReference!
    
    var activityList = [Activite]()
    
    let colorCommandees = UIColor(rgb: 0x21C434).withAlphaComponent(0.56)
    
    let date = Date()
    let formatter = DateFormatter()

    
    let customBlue = UIColor(red: 76/255, green: 134/255, blue: 202/255, alpha: 1)
    let secondGradColor = UIColor(rgb: 0x38ef7d)
    let firstGradColor = UIColor(rgb: 0x11998e)
    let thirdGradColor = UIColor(rgb: 0xFC5C7D)
    let quatreGradColor = UIColor(rgb: 0x6A82FB)
    var handle: AuthStateDidChangeListenerHandle?

    let page = BLTNPageItem(title: "Bienvenue sur EseoKami !")
    
    let colors: [UIColor] = [UIColor.white, UIColor.black, UIColor.black,UIColor.black,UIColor.black,UIColor.black, UIColor.black, UIColor.black,UIColor.black,UIColor.black]
    let pageNotifications = NotifPageItem(title: "Notifications")
    let pageInscription = InscriptionPageItem(title: "Connexion")
    let pageConclusion = FinishPageItem(title: "Configuration terminée")
    let greenCouleur = UIColor(red: 0.294, green: 0.85, blue: 0.392, alpha: 1)
    let blueCouleur = UIColor(red: 47/255, green: 122/255, blue: 246/255, alpha: 1)
    let monImage = UIImage(named: "IntroCompletion")
    
    // MARK: Initialisation bulletin
    lazy var bulletinManager: BLTNItemManager = {
      //  page.image = UIImage(named: "NotificationPrompt")
        page.descriptionText = "Ici, commandez vos repas ainsi que vos activités, et informez vous sur notre liste."
        page.actionButtonTitle = "Commencer"
        
        page.appearance.actionButtonColor = UIColor(red: 165/255, green: 47/255, blue: 41/255, alpha: 1)
        page.requiresCloseButton = false
        page.isDismissable = false
        page.image = UIImage(named: "logo")
        
        DispatchQueue.main.async {
            self.page.next = self.pageNotifications
            self.page.actionHandler = { item in
                item.manager?.displayNextItem()
            }
        }
        
        let rootItem: BLTNItem = page
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    
    
    lazy var connectionManager: BLTNItemManager = {
        // MARK: Page inscription
        pageInscription.descriptionText = "Connecte toi pour connaître ton score et profiter de plein d'autres fonctions !"
        pageInscription.actionButtonTitle = "Valide"
        pageInscription.isDismissable = false
        pageInscription.alternativeButtonTitle = "Pas maintenant"
        pageInscription.requiresCloseButton = false
        DispatchQueue.main.async {
            
            // MARK : Implementation ESEO a faire ici
            self.pageInscription.next = self.pageConclusion
            self.pageInscription.actionHandler = { item in
                
                
                let al = UIAlertController(title: "OK", message: "OK", preferredStyle: .alert)
                al.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                item.manager?.present(al, animated: true, completion: nil)
                
                if self.pageInscription.textField.text!.hasSuffix("@reseau.eseo.fr") { // ET && succes de connexion au systeme ESEO
                    // en cas de succes de connexion au systeme ESEO
                    
                    let emailTransformed = self.pageInscription.textField.text!.replacingOccurrences(of: "@", with: "%40")
                    
                    let urlString = "http://api.pandfstudio.ovh/login?email=\(emailTransformed)&password=\(self.pageInscription.textFieldMdp.text!)"
                    
                    
                    AF.request(urlString).responseJSON(completionHandler: { (reponseData) in
                        if reponseData.result.value != nil {
                            let json = JSON(reponseData.result.value!)
                            
                            if json["success"].bool! {
                                print("succès !!!")
                                item.manager?.displayNextItem()
                            } else {
                                print("erreur...")
                            }
                            
                        }
                    })
                    
                    // if success
                    
                    // else
                    
                    item.manager?.displayActivityIndicator()
                    self.refUsers = Database.database().reference().child("users")
                    let key = self.refUsers.childByAutoId().key
                    let user = ["username:":self.pageInscription.textField.text!]
                    self.refUsers.child(key!).setValue(user)
                    // MARK: Firebase Auth
                    
                    Auth.auth().createUser(withEmail: self.pageInscription.textField.text!, password: self.pageInscription.textFieldMdp.text!, completion: { (user, error) in
                        if error == nil {
                            Auth.auth().signIn(withEmail: self.pageInscription.textField.text!, password: self.pageInscription.textFieldMdp.text!, completion: { (result, errpr) in
                                print("User connected")
                            })
                        }
                        
                    })
                    
                } else {
                    let alertCont = UIAlertController(title: "Erreur", message: "Veuillez entrer une adresse Eseo valide.", preferredStyle: .alert)
                    let actionCancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertCont.addAction(actionCancel)
                    item.manager?.present(alertCont, animated: true, completion: nil)
                    
                }
            }
        }
        
        pageInscription.alternativeHandler = { item in
            let alertController = UIAlertController(title: "Es-tu sûr ?", message: "Tu ne pourras pas commander à la cafètéria ou gagner des points sur les activités.", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ne pas se connecter", style: .destructive, handler: { (action) in
                item.manager?.displayNextItem()
            })
            
            let actionCancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
            alertController.addAction(action1)
            alertController.addAction(actionCancel)
            self.bulletinManager.present(alertController, animated: true, completion: nil)
        }
        let rootItem: BLTNItem = pageInscription
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.value(forKey: "userFirstName") != nil && UserDefaults.standard.value(forKey: "userFullName") != nil  {
            nameLabel.text = (UserDefaults.standard.value(forKey: "userFirstName") as! String)
            profileImage.setImageForName(UserDefaults.standard.object(forKey: "userFullName") as! String, backgroundColor: customBlue, circular: true, textAttributes: nil, gradient: false)
        } else {
            nameLabel.text = "Célestin"
        }
        
        if UserDefaults.standard.value(forKey: "userID") != nil {
            let def = UserDefaults.standard.object(forKey: "userID") as! String
            let root = def.replacingOccurrences(of: ".", with: " ")
            Database.database().reference().child("scores").child(root).observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.hasChild("score") {
                    self.numberOfPoints.text = "\(snapshot.childSnapshot(forPath: "score").value!) points"
                } else {
                    self.numberOfPoints.text = "0 point"
                }
                
                
            }
            // print(UserDefaults.standard.object(forKey: "userID"))
        }
        
        
        
        
    }
    
    @objc func reserve() {
        self.performSegue(withIdentifier: "reserveSegue", sender: self)
    }
    
    @objc func aReserver() {
        self.performSegue(withIdentifier: "aReserveSegue", sender: self)
    }
    
    @objc func hotReserve() {
        self.performSegue(withIdentifier: "hotlineReservee", sender: self)
    }
    
    @objc func pasReserverHotline() {
        self.performSegue(withIdentifier: "hotlineNonReservee", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.bool(forKey: "hasReservedHotline") != false {
            hotlineButton.setTitle("Ma commande", for: .normal)
            hotlineButton.backgroundColor = UIColor(red: 65/255, green: 193/255, blue: 54/255, alpha: 1)
            hotlineButton.addTarget(self, action: #selector(hotReserve), for: .touchUpInside)
        } else {
            hotlineButton.addTarget(self, action: #selector(pasReserverHotline), for: .touchUpInside)
        }
        
        
        
        if UserDefaults.standard.object(forKey: "activiteShocker") != nil {
            reserverButton.setTitle("Accéder à la réservation", for: .normal)
            reserverButton.tintColor = UIColor.green
            reserverButton.backgroundColor = UIColor(red: 65/255, green: 193/255, blue: 54/255, alpha: 1)
            labelConseil.text = "Ta place est bien réservée !"
            labelConseil.textColor = UIColor(red: 65/255, green: 193/255, blue: 54/255, alpha: 1)
            reserverButton.addTarget(self, action: #selector(reserve), for: .touchUpInside)
        } else {
            reserverButton.addTarget(self, action: #selector(aReserver), for: .touchUpInside)
        }
        
      //  print(UserDefaults.standard.object(forKey: "userEmail") as! String)
        
        let navigation = UINavigationBar.appearance()
        
        let content = UNMutableNotificationContent()
        content.title = "La Hotline commence bientôt, tiens-toi prêt ! 🚗"
        content.body = "Commande dès 18h !"
        // Configure the recurring date.
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        
        dateComponents.month = 4
        dateComponents.day = 24
        dateComponents.hour = 17
        dateComponents.minute = 45
        dateComponents.second = 0
        
        // Create the trigger as a repeating event.
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: dateComponents, repeats: true)
        
        let navigationFont = UIFont(name: "Gang of Three", size: 20)

        let navigationLargeFont = UIFont(name: "Gang of Three", size: 34) // 34 is Large Title size by default
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString,
                                            content: content, trigger: trigger)
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
            if error != nil {
                // Handle any errors.
            }
        }

        
        if #available(iOS 11, *){
            navigation.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: navigationLargeFont!]
        }
        
        
        menu_button.image = UIImage(named: "menu")
        
        if UserDefaults.standard.object(forKey: "userFirstName") != nil {
            nameLabel.text = (UserDefaults.standard.object(forKey: "userFirstName") as! String)
        } else {
            nameLabel.text = "Célestin"
        }
        
        if UserDefaults.standard.object(forKey: "userFullName") != nil {
            profileImage.setImageForName(UserDefaults.standard.object(forKey: "userFullName") as! String, backgroundColor: customBlue, circular: true, textAttributes: nil, gradient: false)
        } else {
             profileImage.setImageForName("Célestin", backgroundColor: customBlue, circular: true, textAttributes: nil, gradient: false)
        }
        
        // MARK: Setup pages of bulletin
        setupPages()
        
        formatter.dateFormat = "EEEE dd LLLL"
        formatter.locale = Locale(identifier: "fr_FR")
        let result = formatter.string(from: date)
        let capResult = result.capitalizingFirstLetter()
        dateLabel.text = capResult
        UNUserNotificationCenter.current().delegate = self
        
        
        // MARK: Countdown Label
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if self.launchedBefore || UserDefaults.standard.object(forKey: "userID") != nil  {
                print("Not first launch.")
                print("Email of user: \(user?.email)")
                
            } else if UserDefaults.standard.object(forKey: "userID") == nil && self.launchedBefore {
                
                self.connectionManager.showBulletin(above: self)
                
            } else if UserDefaults.standard.object(forKey: "userID") == nil && !self.launchedBefore {
                print("First launch, setting UserDefault.")
                
                self.bulletinManager.showBulletin(above: self)
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @objc func updateTimer() {
        let userCalendar = Calendar.current
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second, .month, .year, .day], from: date)
        let currentDate = calendar.date(from: components)
        
        var hotlineDate = DateComponents()
        hotlineDate.year = 2019
        hotlineDate.month = 4
        hotlineDate.day = 24
        hotlineDate.hour = 18
        hotlineDate.minute = 00
        hotlineDate.second = 00
        let hotlineDay = userCalendar.date(from: hotlineDate as DateComponents)!
        
        
        let dayCalendarUnit: NSCalendar.Unit = ([.day, .hour, .minute, .second])
        let hotlineDayDifference = userCalendar.dateComponents([.day, .hour, .minute, .second], from: currentDate!, to: hotlineDay)
        
        let daysLeft = hotlineDayDifference.day
        let hoursLeft = hotlineDayDifference.hour
        let minuteLeft = hotlineDayDifference.minute
        let secondsLeft = hotlineDayDifference.second
        
        countdownLabel.text = "\(daysLeft!)J \(hoursLeft!)H \(minuteLeft!)M \(secondsLeft!)s"
        
    }
    
    func setupPages() {
        bulletinManager.backgroundViewStyle = .blurredDark
        // MARK: Page notifications
     //   pageNotifications.image = UIImage(named: "NotificationPrompt")
        pageNotifications.isDismissable = false
        pageNotifications.descriptionText = "Recois des notifications lorsque ta commande est prête ou lorsque ta navette s'apprête à partir par exemple"
        pageNotifications.actionButtonTitle = "Recevoir des notifications"
        pageNotifications.alternativeButtonTitle = "Pas maintenant"
        pageNotifications.requiresCloseButton = false
        DispatchQueue.main.async {
            self.pageNotifications.next = self.pageInscription
            self.pageNotifications.actionHandler = { item in
                PermissionsManager.shared.requestNotifications()
                
                if #available(iOS 10.0, *) {
                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                    
                    
                    UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (granted, error) in
                        guard granted else { return }
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                            item.manager?.displayNextItem()
                        }
                    })
                } else {
                    let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                    DispatchQueue.main.async {
                        UIApplication.shared.registerUserNotificationSettings(settings)
                        item.manager?.displayNextItem()
                    }
                }
                
                UIApplication.shared.registerForRemoteNotifications()
                
            }
        }
        pageNotifications.alternativeHandler = { item in
            let alertController = UIAlertController(title: "Es-tu sûr ?", message: "Tu ne recevras pas de notifications", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ne pas recevoir de notifications", style: .destructive, handler: { (action) in
                item.manager?.displayNextItem()
            })
            
            let actionCancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
            alertController.addAction(action1)
            alertController.addAction(actionCancel)
            self.bulletinManager.present(alertController, animated: true, completion: nil)
        }
        // MARK: Page conclusion
        pageConclusion.descriptionText = "Tu peux désormais utiliser l'application. En cas de problème, n'hésite pas à nous contacter cette semaine (onglet contact)."
        
        pageConclusion.actionButtonTitle = "Terminer"
        pageConclusion.isDismissable = true
        pageConclusion.alternativeButtonTitle = "Recommencer"
        pageConclusion.requiresCloseButton = true
        pageConclusion.appearance.actionButtonColor = greenCouleur

        pageConclusion.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        
        pageConclusion.alternativeHandler = { item in
            self.bulletinManager.popToRootItem()
        }
        
        // MARK: Page inscription
        pageInscription.descriptionText = "Connecte toi pour connaître ton score et profiter de plein d'autres fonctions !"
        pageInscription.actionButtonTitle = "Valider"
        pageInscription.isDismissable = false
        pageInscription.alternativeButtonTitle = "Pas maintenant"
        pageInscription.requiresCloseButton = false
        DispatchQueue.main.async {
            
            // - MARK : Implementation ESEO a faire ici
            self.pageInscription.next = self.pageConclusion
            self.pageInscription.actionHandler = { item in
                
                if self.pageInscription.textField.text!.hasSuffix("@reseau.eseo.fr") { // ET && succes de connexion au systeme ESEO
                   // en cas de succes de connexion au systeme ESEO
                    
                    let emailTransformed = self.pageInscription.textField.text!.replacingOccurrences(of: "@", with: "%40")
                    print("emailTransformed: \(emailTransformed)")
                    let urlString = "http://api.pandfstudio.ovh/login?email=\(emailTransformed)&password=\(self.pageInscription.textFieldMdp.text!)"
                    
                    print("urlString: \(urlString)")
                    
                    
                    AF.request(urlString).responseJSON(completionHandler: { (reponseData) in
                        if reponseData.result.value != nil {
                            let json = JSON(reponseData.result.value!)
                            
                            if json["success"].bool! {
                                UserDefaults.standard.set(true, forKey: "launchedBefore")
                                item.manager?.displayActivityIndicator()
                                item.manager?.displayNextItem()
                                // MARK: UID
                                let uid = json["infos"]["UID"].string!
                                let token = json["infos"]["token"].string!
                                
                                let userDef = UserDefaults.standard
                                User.uid = uid
                                userDef.set(User.uid, forKey: "userID")
                                userDef.set(self.pageInscription.textField.text!, forKey: "userEmail")
                               // userDef.set(token, forKey: "userToken")
                                UserDefaults.standard.set(token, forKey: "tokenUser")
                              //  print("USERDEF: \(UserDefaults.standard.object(forKey: "tokenUser"))")
                                userDef.set(json["infos"]["fullname"].string!.components(separatedBy: " ").first, forKey: "userFirstName")
                                self.nameLabel.text = json["infos"]["fullname"].string!.components(separatedBy: " ").first
                                 // A SAUVEGARDER
                                userDef.set(json["infos"]["fullname"].string!, forKey: "userFullName")
                                
                                
                                self.profileImage.setImageForName(json["infos"]["fullname"].string!, backgroundColor: self.customBlue, circular: true, textAttributes: nil, gradient: false)
                                
                                let parameters: Parameters = [
                                    "AuthorizationEseo": token
                                ]

                                let headers: HTTPHeaders = [
                                    "accept": "application/json"
                                ]
                                
                                AF.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: { (response) in
                                    switch response.result {
                                    case .success(let value):
                                        let swiftyJson = JSON(value)
                                        print ("return as JSON using swiftyJson is: \(swiftyJson)")
                                    case .failure(let error):
                                        print ("error: \(error)")
                                    }
                                })
                               
                                let credential = URLCredential(user: emailTransformed, password: self.pageInscription.textFieldMdp.text!, persistence: .forSession)

                                
                                AF.request(urlString).authenticate(with: credential).responseJSON { response in
                                    debugPrint("REPONSECRED: \(response)")
                                }
                                
                                AF.request(urlString, headers: headers).responseJSON(completionHandler: { (response) in
                                    debugPrint("RESPONSEJSON: \(response)")
                                    AF.request("http://api.pandfstudio.ovh/users/romain.rabouan").responseJSON(completionHandler: { (response) in
                                        let json = JSON(response.result.value!)
                                        print(json)
                                    })
                                })
                                
                            } else {
                                print("erreur...")
                                let alert = UIAlertController(title: "Erreur", message: "Nous n'avons pas réussi à te connecter. Réessayes.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                item.manager?.present(alert, animated: true, completion: nil)
                            }
                            
                        } else {
                            let alert = UIAlertController(title: "Erreur", message: "Nous n'avons pas réussi à te connecter. Réessayes.", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                            item.manager?.present(alert, animated: true, completion: nil)
                            
                        }
                    })
                        self.refUsers = Database.database().reference().child("users")
                        let key = self.refUsers.childByAutoId().key
                        let user = ["username:":self.pageInscription.textField.text!]
                        self.refUsers.child(key!).setValue(user)
                    // MARK: Firebase Auth
                    
                    Auth.auth().createUser(withEmail: self.pageInscription.textField.text!, password: self.pageInscription.textFieldMdp.text!, completion: { (user, error) in
                        if error == nil {
                            Auth.auth().signIn(withEmail: self.pageInscription.textField.text!, password: self.pageInscription.textFieldMdp.text!, completion: { (result, errpr) in
                                print("User connected")
                                print("User inscrit: \(Auth.auth().currentUser?.email)")
                            })
                        } else {
                            print("error")
                        }
                        
                    })

                    
                    
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
                item.manager?.displayNextItem()
            })
            
            let actionCancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
            alertController.addAction(action1)
            alertController.addAction(actionCancel)
            self.bulletinManager.present(alertController, animated: true, completion: nil)
        }
        
    }

    
    @IBAction func getCurrentUser(_ sender: Any) {
        let user = Auth.auth().currentUser?.email
        print("Utilisateur actuel: \(user)")
    }
    
}

