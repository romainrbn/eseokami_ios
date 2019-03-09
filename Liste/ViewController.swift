//
//  ViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 14/12/2018.
//  Copyright © 2018 Romain Rabouan. All rights reserved.
//  TODO: AlertController quand dismiss connexion et notifs
//  TODO: Supprimer connexion initiale

import UIKit
import SideMenu
import BLTNBoard
import UserNotifications


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UNUserNotificationCenterDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let modules = ["Bureau", "Animation", "Event", "Communication","Logistique", "Sponsors", "Club", "RCIIA", "Voyage"]
    
    
    
    let descriptions = ["Le bureau sera votre interlocuteur en cas d'élection. Découvrez-les !", "Vous pourrez découvrir l'animation tout au long de la semaine, à travers les activités par exemple !", "Cette semaine, c'est eux qui organisent les évènements et les soirées !", "Cette semaine, ils gèrent l'appli, les réseaux sociaux...", "Ils organisent la restauration et les transports cette semaine !", "Ce sont eux qui ont déniché nos entreprises partenaires.", "Ils gèreront les différents clubs à l'ESEO en cas d'élection", "En cas d'élection, ils gèreront les différentes promotions ainsi que les forums liés à l'ESEO", "Ils organiseront les différents voyages gérés par le BDE."]
    
    let personnes: [[[String : String?]]] = [[["nom":"Marie-Aïnhoa Nicolas", "role": "Présidente"], ["nom" :"Nicolas Durat" , "role": "Vice-président"], ["nom":"Clara Pasquier", "role":"Vice-présidente"], ["nom":"Alexis Hervé", "role": "Trésorier"], ["nom":"Lucie Siret", "role":"Trésorière"], ["nom":"Erika Martzolf","role":"Secrétaire"]], [["nom":"Guillaume Chapela", "role": "Resp. Animation"], ["nom" :"Camille Duboue" , "role": "Membre Anim"], ["nom":"Tristan Gauville", "role":"Membre Anim"], ["nom":"Clément Puchault", "role": "Membre Anim"], ["nom":"Hugo Garnier", "role":"Membre Anim"], ["nom":"Clément Granseigne","role":"Membre Anim"], ["nom":"Bryan Ngatchou","role":"Membre Anim"]], [["nom":"Timothée Jouffrieau", "role": "Responsable Event"], ["nom" :"Roxanne Laigneau" , "role": "Membre Event"], ["nom":"Joseph Guerin", "role":"Membre Event"], ["nom":"Maxime Galliot", "role": "Membre Event"], ["nom":"Dylan Deniau", "role":"Membre Event"], ["nom":"Paul Joseph", "role":"Membre Event"], ["nom":"Benjamin Tortorici", "role":"Membre Event"], ["nom":"Diane Duchaussoy", "role":"Membre Event"]], [["nom":"Pierre Bertier", "role": "Resp. Communication"], ["nom" :"Marylou Alleaume" , "role": "Membre Communication"], ["nom":"Amélie Dousteyssier", "role":"Membre Communication"], ["nom":"Romain Rabouan", "role": "Membre Communication"]], [["nom":"Emmanuel Gelineau", "role": "Resp. Logistique"], ["nom" :"Thomas Grébault" , "role": "Membre Logistique"], ["nom":"Paulin Gislard", "role":"Membre Logistique"], ["nom":"Charles Clément", "role": "Membre Logistique"], ["nom" :"Andy Cousineau" , "role": "Membre Logistique"]], [["nom":"Xavier Cordonnier", "role": "Responsable Sponsors"], ["nom" :"Margaux Delaunay" , "role": "Membre Sponsors"], ["nom":"Paul Lefay", "role":"Membre Sponsors"], ["nom":"Benjamin Dupont", "role": "Membre Sponsors"]],[["nom":"Théo Cesbron", "role": "Responsable Club"], ["nom" :"Louise Gelbart" , "role": "Membre Club"], ["nom":"Louis Rampal", "role":"Membre Club"], ["nom":"Soren Guyon", "role": "Membre Club"]], [["nom":"Chloé Gounot", "role": "Responsable RCIIA"], ["nom" :"Julia Body" , "role": "Membre RCIIA"], ["nom" :"Marie Poirat" , "role": "Membre RCIIA"]], [["nom":"Justine Petton", "role": "Responsable Voyage"], ["nom" :"Léa Bureau" , "role": "Membre Voyage"]]] // triple entrée
    
    
    let kamis: [String?] = [nil, "Hachiman", "Susanoo","Fujin", "Inari", "Raiden","Saruta-Hiko", "Uzume","Omoikane","Amaterasu"]
    
    let pageQR = BLTNPageItem(title: "Ton QR Code")
    let page = BLTNPageItem(title: "Bienvenue sur EseoKami !")
    
    let colors: [UIColor] = [UIColor.white, UIColor.red, UIColor.red,UIColor.red,UIColor.red,UIColor.red, UIColor.red, UIColor.red,UIColor.black,UIColor.red]
    let pageNotifications = BLTNPageItem(title: "Notifications")
    let pageInscription = InscriptionPageItem(title: "Connexion")
    let pageConclusion = BLTNPageItem(title: "Configuration terminée")
    let greenCouleur = UIColor(red: 0.294, green: 0.85, blue: 0.392, alpha: 1)
    let blueCouleur = UIColor(red: 47/255, green: 122/255, blue: 246/255, alpha: 1)
    let monImage = UIImage(named: "IntroCompletion")
    
    // Initialisation bulletin
    lazy var bulletinManager: BLTNItemManager = {
        page.image = UIImage(named: "NotificationPrompt")
        page.descriptionText = "Ici, commandez vos repas ainsi que vos activités, et informez vous sur notre liste."
        page.actionButtonTitle = "Commencer"
        page.requiresCloseButton = false
        page.isDismissable = false
        page.image = monImage?.withRenderingMode(.alwaysTemplate)
        page.imageView?.tintColor = blueCouleur
        page.appearance.imageViewTintColor = blueCouleur
        DispatchQueue.main.async {
            self.page.next = self.pageNotifications
            self.page.actionHandler = { item in
                item.manager?.displayNextItem()
            }
        }
        
        let rootItem: BLTNItem = page
        return BLTNItemManager(rootItem: rootItem)
    }()
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            bulletinManager.showBulletin(above: self)
        }

       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        
        setupSideMenu()
        setupPages()
        
    }
    
    func setupSideMenu() {
        SideMenuManager.default.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuReference") as? UISideMenuNavigationController
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupPages() {
        bulletinManager.backgroundViewStyle = .blurredDark
        
        pageNotifications.image = UIImage(named: "NotificationPrompt")
        pageNotifications.isDismissable = false
        pageNotifications.descriptionText = "Recevez des notifications lorsque votre commande est prête ou lorsque votre navette s'apprête à partir par exemple"
        pageNotifications.actionButtonTitle = "Recevoir des notifications"
        pageNotifications.alternativeButtonTitle = "Pas maintenant"
        pageNotifications.requiresCloseButton = false
        DispatchQueue.main.async {
            self.pageNotifications.next = self.pageInscription
            self.pageNotifications.actionHandler = { item in
            PermissionsManager.shared.requestNotifications()
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { (granted, error) in
                    guard granted else { return }
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        item.manager?.displayNextItem()
                    }
                })
            
                
            }
        }
        pageNotifications.alternativeHandler = { item in
            let alertController = UIAlertController(title: "Êtes-vous sûr ?", message: "Vous ne recevrez pas de notifications cette semaine", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ne pas recevoir de notifications", style: .destructive, handler: { (action) in
                item.manager?.displayNextItem()
            })
            
            let actionCancel = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
            alertController.addAction(action1)
            alertController.addAction(actionCancel)
            self.bulletinManager.present(alertController, animated: true, completion: nil)
        }
        
        pageConclusion.descriptionText = "Vous pouvez désormais utiliser l'application. En cas de problème, n'hésitez pas à nous contacter cette semaine (onglet contact)."
        pageConclusion.image = UIImage(named: "IntroCompletion")
        
        pageConclusion.actionButtonTitle = "Terminer"
        pageConclusion.isDismissable = true
        pageConclusion.alternativeButtonTitle = "Recommencer"
        pageConclusion.requiresCloseButton = true
        pageConclusion.appearance.actionButtonColor = greenCouleur
        pageConclusion.image = monImage?.withRenderingMode(.alwaysTemplate)
        pageConclusion.imageView?.tintColor = greenCouleur
        pageConclusion.appearance.imageViewTintColor = greenCouleur
        pageConclusion.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        
        pageConclusion.alternativeHandler = { item in
            self.bulletinManager.popToRootItem()
        }
        
        pageInscription.descriptionText = "Connecte toi pour connaître ton score et profiter de plein d'autres fonctions !"
        pageInscription.actionButtonTitle = "Valider"
        pageInscription.isDismissable = false
        pageInscription.alternativeButtonTitle = "Pas maintenant"
        pageInscription.requiresCloseButton = false
        DispatchQueue.main.async {
            self.pageInscription.next = self.pageConclusion
            self.pageInscription.actionHandler = { item in
                item.manager?.displayActivityIndicator()

                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    item.manager?.displayNextItem()
                })

                
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
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func presentSideMenu(_ sender: Any) {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func showSearch(_ sender: Any) {
        print("Recherche appuyé")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return modules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personnes[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PresentationCollectionViewCell
        
        cell.imageView.image = #imageLiteral(resourceName: "void_image")
        cell.nameLabel.text = personnes[indexPath.section][indexPath.item]["nom"] as! String
        cell.moduleLabel.text = personnes[indexPath.section][indexPath.item]["role"] as! String
        
        
        cell.layer.cornerRadius = 15
        
        return cell
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? PresentationCollectionReusableView {
            
            sectionHeader.moduleName.text = modules[indexPath.section]
            sectionHeader.descriptionLabel.text = descriptions[indexPath.section]
            
            if kamis[indexPath.section] != nil {
                sectionHeader.leurKamiLabel.text = "Leur Kami : \(kamis[indexPath.section]!)"
                sectionHeader.leurKamiLabel.textColor = colors[indexPath.section]
            } else {
                sectionHeader.leurKamiLabel.textColor = colors[indexPath.section]
            }
            
            
            return sectionHeader
        }
        
        return UICollectionReusableView()
    }
    
    
    
}
