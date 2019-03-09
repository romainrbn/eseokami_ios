//
//  ActivitesViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 31/12/2018.
//  Copyright © 2018 Romain Rabouan. All rights reserved.
//


// A faire : Resa non, récupérer par jour les activités

import UIKit
import BLTNBoard
import FirebaseDatabase
import ChameleonFramework
import SAConfettiView


class ActivitesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // Si database vide, mettre un item "vous n'avez pas encore reserve d'activite" gris (en default)
    
    // MARK: F.Databse
    var reference: DatabaseReference!
    
    
    var confettiView: SAConfettiView!
    
    
    // MARK: IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
   // @IBOutlet weak var addButton: UIBarButtonItem!
    
    var collectionViewColors = [UIColor(red: 176/255, green: 62/255, blue: 79/255, alpha: 1), UIColor(red: 238/255, green: 123/255, blue: 48/255, alpha: 1), UIColor(red: 175/255, green: 43/255, blue: 43/255, alpha: 1), UIColor(red: 175/255, green: 43/255, blue: 43/255, alpha: 1), UIColor(red: 176/255, green: 62/255, blue: 79/255, alpha: 1), UIColor(red: 238/255, green: 123/255, blue: 48/255, alpha: 1), UIColor(red: 175/255, green: 43/255, blue: 43/255, alpha: 1), UIColor(red: 175/255, green: 43/255, blue: 43/255, alpha: 1), UIColor(red: 176/255, green: 62/255, blue: 79/255, alpha: 1), UIColor(red: 238/255, green: 123/255, blue: 48/255, alpha: 1), UIColor(red: 175/255, green: 43/255, blue: 43/255, alpha: 1), UIColor(red: 175/255, green: 43/255, blue: 43/255, alpha: 1), UIColor(red: 176/255, green: 62/255, blue: 79/255, alpha: 1), UIColor(red: 238/255, green: 123/255, blue: 48/255, alpha: 1), UIColor(red: 175/255, green: 43/255, blue: 43/255, alpha: 1), UIColor(red: 175/255, green: 43/255, blue: 43/255, alpha: 1), UIColor(red: 176/255, green: 62/255, blue: 79/255, alpha: 1), UIColor(red: 238/255, green: 123/255, blue: 48/255, alpha: 1), UIColor(red: 175/255, green: 43/255, blue: 43/255, alpha: 1), UIColor(red: 175/255, green: 43/255, blue: 43/255, alpha: 1)]
    
    let descImages = [UIImage(named: "headphones"), UIImage(named: "music_black"), UIImage(named: "activity-placehorder"), UIImage(named: "vibe"), UIImage(named: "headphones"), UIImage(named: "music_black"), UIImage(named: "activity-placehorder"), UIImage(named: "vibe"), UIImage(named: "headphones"), UIImage(named: "music_black"), UIImage(named: "activity-placehorder"), UIImage(named: "vibe"), UIImage(named: "headphones"), UIImage(named: "music_black"), UIImage(named: "activity-placehorder"), UIImage(named: "vibe")] // attention au index out of range
    
    
    let date = Date()
    let formatter = DateFormatter()
    
    var activityList = [Activite]()
    
    var liste_des_activites: [[[String : String?]]] = [[
        ["nom":"Stand Photo", "description": nil, "image": "activite_photos"],
        ["nom":"Stand jeux vidéo : PS4, Xbox One", "description": nil, "image": "activite_jvideos"],
        ["nom":"Le poing de Kintaro", "description": "FRAPPERAS-TU AUSSI FORT QUE KINTARO ?", "image": "activite_kintaro"],
        ["nom": "Les palets de Fujin", "description": "QUI SÈME LE VENT, RÉCOLTE LA TEMPÊTE...", "image": "activite_palets"]], [["nom":"Les désirs d'Uzume", "description": "Les rires éclatent mieux lorsque la nourriture est bonne...", "image": "activite_uzume"],
        ["nom":"L'assault d'Hachiman", "description": "Réveille le ninja qui est en toi !", "image": "activite_hachiman"],
        ["nom":"La route d'Izanami", "description": "Courir ou mourir, tel est le dilemme d'Izanami !", "image": "activite_mirror"],
        ["nom": "Le duel de Raijin", "description": "Coup de tonerre sur le ring, qui ressortira vainqueur ?", "image": "activite_kintaro"],
        ["nom":"L'arbre de Saruta", "description": "Même le singe tombe de l'arbre...", "image": "activite_saruta"],
        ["nom":"Voyage vers tsukuyomi", "description": "Boucle ta ceinture, décollage imminent vers Tsukuyomi !", "image": "activite_ejector"],
        ["nom": "Le combat des Kamis", "description": "Kami rentre dans le cercle mais ne met pas le genou à terre !", "image": "activite_sumo"]],
        [["nom":"La colère de Susanoo", "description": "Susanoo ne semble pas d'humeur aujourd'hui, les cyclones sont de sortie...", "image": "activite_susanoo"],
         ["nom":"Les verres de Shojo", "description": "Fais preuve de précision si tu ne veux pas trinquer avec Shojo !", "image": "activite_mojito_pong"],
         ["nom":"Shinigami 21", "description": "Shinigami ou 21, à toi de voir !", "image": "activite_shinigami"],
         ["nom": "Les ruses d'Inari", "description": "Seras-tu déjouer les ruses d'Inari ?", "image": "activite_inari"]],
        [["nom":"La quête d'Ishikawa", "description": "Ma question préférée, qu'est-ce je vais faire de tout cet oseille ?", "image": "activite_ishikawa"],
         ["nom":"Le tapis d'Omukade", "description": "Cours de stretching japonais géant", "image": "activite_twister"],
         ["nom":"Les tonneaux d'Haradashi", "description": "Des trous plus grands pour les moins doués...", "image": "activite_beer_pong_geant"],
         ["nom": "Les langues de Kasa-Obake", "description": "Tire la langue et cours !", "image": "activite_elastique"]]]
    
    
    // MARK: Variables
    var testNamesConseilles = [["Nom":"Afterwork", "Heure": "20h30"], ["Nom":"La cage","Heure": "21h00"]]
    var testNamesReservees = [["Nom":"Trampoline Park", "Heure": "21h30"]]
    let activityTypes = ["À la pause", "Ce midi", "Le before", "En soirée"]
    
    let heures = ["Auj. 18h30", "Dem. 21h"] // fetch w/ db
    var gradientLayer: CAGradientLayer!
    let blueCouleur = UIColor(red: 47/255, green: 122/255, blue: 246/255, alpha: 1)
    
    let colorCommandees = UIColor(rgb: 0x21C434).withAlphaComponent(0.56)
    let colorConseil = UIColor(rgb: 0x329498).withAlphaComponent(0.56)
    
    var refresher: UIRefreshControl!
    
    // MARK: BLTN
    let page = BLTNPageItem(title: "Réserver une activité")
    let chooseActivityPage = ActiviteItem(title: "Au programme aujourd'hui")
    let monImageActivite = UIImage(named: "activity")
    let finishedImage = UIImage(named: "IntroCompletion")
    let finishedPage = BLTNPageItem(title: "Terminé")
    lazy var activiteManager: BLTNItemManager = {
        page.descriptionText = "Ici, commandez une activité. Vous la retrouverez ensuite dans l'onglet \"Mes Activités\""
        page.actionButtonTitle = "Commencer"
        page.alternativeButtonTitle = "Annuler"
        page.alternativeHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        page.image = monImageActivite?.withRenderingMode(.alwaysTemplate)
        page.imageView?.tintColor = blueCouleur
        page.requiresCloseButton = true
        
        page.isDismissable = true
        DispatchQueue.main.async {
            self.page.next = self.chooseActivityPage
            self.page.actionHandler = { item in
                item.manager?.displayNextItem()
            }
        }
        let rootItem: BLTNItem = page
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    let greenCouleur = UIColor(red: 0.294, green: 0.85, blue: 0.392, alpha: 1)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        confettiView.startConfetti()
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0) + .milliseconds(500), execute: {
//            self.confettiView.stopConfetti()
//        })
//
//        confettiView.stopConfetti()

        
    }
    
    
    // MARK: View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        confettiView = SAConfettiView(frame: self.view.bounds)
        confettiView.colors = [UIColor(red: 173/255, green: 43/255, blue: 43/255, alpha: 1), UIColor(red: 164/255, green: 47/255, blue: 41/255, alpha: 1), UIColor(red: 125/255, green: 43/255, blue: 56/255, alpha: 1), UIColor(red: 238/255, green: 123/255, blue: 48/255, alpha: 1)]
        confettiView.intensity = 1
        confettiView.type = .Confetti
       // view.addSubview(confettiView)
        
        reference = Database.database().reference().child("activites")
        self.refresher = UIRefreshControl()
        self.collectionView!.alwaysBounceVertical = true
        self.refresher.addTarget(self, action: #selector(reloadCollectionViewData), for: .valueChanged)
        self.collectionView.addSubview(refresher)
        setupPages()
        emptyLabel.isHidden = true
        collectionView.isHidden = false
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
        
        if collectionView.numberOfItems(inSection: 0) == 0 {
           // collectionView.isHidden = true
            emptyLabel.isHidden = false
        }
        
        
        reference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.activityList.removeAll()
                for activites in snapshot.children.allObjects as! [DataSnapshot] {
                    let activiteObject = activites.value as? [String: AnyObject]
                    let activityName = activiteObject?["nom"]
                    let activityId = activiteObject?["id"]
                    let activite = Activite(id: activityId as! String, nom: activityName as! String)
                    self.activityList.append(activite)
                }
                self.collectionView.reloadData()
            }
        }
    }
    
//    func setupAddButton() {
//        var dateComponents = DateComponents()
//        dateComponents.day = 5 // TODO: A mettre sur date de la journée (lanceur = réservation...)
//        dateComponents.month = 5
//        dateComponents.year = 2019
//        let userCalendar = Calendar.current
//        let currentDate = Date()
//
//        let dateSoiree = userCalendar.date(from: dateComponents)
//
//        if dateSoiree! > currentDate || dateSoiree! < currentDate {
//            addButton.isEnabled = false
//        } else {
//
//            addButton.isEnabled = true
//        }
//    }
    
    @objc func reloadCollectionViewData() {
       // collectionView.reloadData() // A faire mais probleme avec mask corner cell
        self.refresher.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    // MARK: Set up bulletin in order to choose activity
    func setupPages() {
        chooseActivityPage.isDismissable = true
        chooseActivityPage.descriptionText = "Choisissez une activité dans la liste"
        chooseActivityPage.alternativeButtonTitle = "Annuler"
        chooseActivityPage.alternativeHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        
        reference = Database.database().reference().child("activites")
        reference.observe(DataEventType.value) { (snapshot) in
            if snapshot.childrenCount > 0 {
                for activites in snapshot.children.allObjects as! [DataSnapshot] {
                    let activiteObject = activites.value as? [String: AnyObject]
                    let activiteName = activiteObject?["nom"]
                    self.finishedPage.descriptionText = "Vous êtes bien inscrit pour la session \"\(activiteName!)\"." ///
                }
            }
        }
        
        DispatchQueue.main.async {
            self.chooseActivityPage.next = self.finishedPage
        }
        
        
        
        finishedPage.actionButtonTitle = "Fermer"
        finishedPage.image = finishedImage?.withRenderingMode(.alwaysTemplate)
        finishedPage.imageView?.tintColor = greenCouleur
        finishedPage.appearance.imageViewTintColor = greenCouleur
        finishedPage.alternativeButtonTitle = "Annuler"
        finishedPage.alternativeHandler = { item in
            item.manager?.dismissBulletin(animated: true)
        }
        
        finishedPage.actionHandler = { item in
            item.manager?.dismissBulletin(animated: true) ////
        }
        
        
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return liste_des_activites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return liste_des_activites[section].count
//        if section == 0 {
//            return activityList.count
//        } else {
//            return testNamesConseilles.count
//        }
        
    }
    
    @objc func showQRCodeActivity() {
        let alertController = UIAlertController(title: "En cours d'implémentation", message: "Cette fonction n'est pas encore disponible (d'ici ce week-end ça sera fait)", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(actionOK)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ActivitesCollectionViewCell
         cell.layer.cornerRadius = 20
       
        cell.layer.masksToBounds = true
        cell.clipsToBounds = true
        
        cell.backgroundColor = UIColor.flatWatermelonColorDark()
        cell.activiteName.text = liste_des_activites[indexPath.section][indexPath.item]["nom"] as! String
        
        if liste_des_activites[indexPath.section][indexPath.item]["description"] != nil {
            cell.descriptionLabel.text = (liste_des_activites[indexPath.section][indexPath.item]["description"] as? String)?.uppercased()
        } else {
            cell.descriptionLabel.text = ""
        }
        
        if indexPath.item == 0 {
            cell.backgroundColor = self.collectionViewColors[0]
            

        } else {
            
            cell.backgroundColor = self.collectionViewColors[indexPath.item]
        }

        
        
        cell.descImage.image = UIImage(named: liste_des_activites[indexPath.section][indexPath.item]["image"] as! String) // TODO: Attention, si trop d'éléments, pas assez d'images (soit créer suffisament d'images - déconseillé, soit faire descImages.randomElement()!
        
        
        
        cell.activiteName.textAlignment = .left

        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? ActiviteCollectionReusableView {
            sectionHeader.activityType.text = activityTypes[indexPath.section]
            
            return sectionHeader
        }
        
        return UICollectionReusableView()
    }
    
    @IBAction func showActivityDetail(_ sender: Any) {
        print("OK NEXT ACTIVITY FLAGGED")
//        let alertController = UIAlertController(title: "Fonction encore en développement", message: "Disponibilité ce week-end ;)", preferredStyle: .alert)
//        let actionDismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//        alertController.addAction(actionDismiss)
//        self.present(alertController, animated: true, completion: nil)
        
        
        

        
    }
    
    
//    @IBAction func addActivity(_ sender: Any) {
//        var dateComponents = DateComponents()
//        dateComponents.day = 5 // TODO: A mettre sur date de la journée (lanceur = réservation...)
//        dateComponents.month = 5
//        dateComponents.year = 2019
//        let userCalendar = Calendar.current
//        let currentDate = Date()
//
//        let dateSoiree = userCalendar.date(from: dateComponents)
//
//        if dateSoiree! > currentDate || dateSoiree! < currentDate {
//            let alertController = UIAlertController(title: "Impossible de réserver une activité", message: "Tu pourras réserver une activité seulement durant la journée EseoKami !", preferredStyle: .alert)
//            let actionDismiss = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//            alertController.addAction(actionDismiss)
//            self.present(alertController, animated: true, completion: nil)
//        } else {
//            activiteManager.showBulletin(above: self)
//        }
//        // Pour réserver certaines activités seulement
//
//    }
    
}

extension ActivitesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 4)
    }
}

extension UIView {
    func roundCornersTop(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
    
    func roundCornersBottom(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        if #available(iOS 11.0, *) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
    }
}

