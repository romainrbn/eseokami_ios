//
//  MesCommandeHotlineLivreurViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 23/02/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//
// Info: BDE ONLY, LIVREUR ONLY / Fetch the data from the database and dispatch it within the 4 groups. They get notified when a new command is created.

import UIKit
import CoreLocation
import FirebaseDatabase

class MesCommandeHotlineLivreurViewController: UICollectionViewController, ReservationsCollectionViewItemDelegate {
    
    

    let ref = Database.database().reference().child("Commandes")
    
    var lenghts: [Int] = []
    
    var names: [[String]] = []
    var surnames: [[String]] = []
    var commandes: [[String]] = []
    var adresses: [[String]] = []
    var infos: [[String]] = []
    
    var commande: CommandeLivreur!

    var isHeightCalculated: Bool = false
    var pathsForGroups: [DatabaseReference] = []
    var nomsRestosForGroups: [String] = []
    
    var groupeActuel: GroupesLivraison = .Groupe1
    let defaultsEmail = UserDefaults.standard.object(forKey: "userEmail") as! String
    private let refresher = UIRefreshControl()
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let lay = UICollectionViewFlowLayout()
        lay.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 10)
        lay.minimumInteritemSpacing = 10
        lay.minimumLineSpacing = 10
        lay.itemSize = CGSize(width: 350, height: 310)
        lay.headerReferenceSize = CGSize(width: self.collectionView.frame.width, height: 75)
        self.collectionView.collectionViewLayout = lay
        
        
        
        
        
        
        
        self.collectionView.alwaysBounceVertical = true
        
        refresher.addTarget(self, action: #selector(refreshCol), for: .valueChanged)
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = refresher
        } else {
            self.collectionView.addSubview(refresher)
        }
        
        
        
        if defaultsEmail == "paulin.gislard@reseau.eseo.fr" || defaultsEmail == "gabriel.lecenne@reseau.eseo.fr" {
            groupeActuel = .Groupe1
            
        } else if defaultsEmail == "benjamin.dupont@reseau.eseo.fr" || defaultsEmail == "marie.poirat@reseau.eseo.fr" {
            groupeActuel = .Groupe2
            
        } else if defaultsEmail == "xavier.cordonnier@reseau.eseo.fr" || defaultsEmail == "erika.martzolf@reseau.eseo.fr" {
            groupeActuel = .Groupe3
            
        } else if defaultsEmail == "theo.cesbron@reseau.eseo.fr" || defaultsEmail == "andy.cousineau@reseau.eseo.fr" {
            groupeActuel = .Groupe4
            
        } else if defaultsEmail == "romain.rabouan@reseau.eseo.fr" {
            groupeActuel = .admin
        }
        
        switch groupeActuel {
        case .Groupe1:
            pathsForGroups = [ref.child("boite_pizzas"), ref.child("quai_bab"), ref.child("regal_doutre"), ref.child("O_classic"), ref.child("dominos"), ref.child("oriflamme")]
            nomsRestosForGroups = ["La Boîte à Pizzas", "La Quai'bab d'Aladin", "Le régal de la doutre", "O'Classic", "Domino's Pizza", "L'Oriflamme"]
            names = [[], [], [], [], [], []]
            surnames = [[], [], [], [], [], []]
            adresses = [[], [], [], [], [], []]
            commandes = [[], [], [], [], [], []]
            infos = [[], [], [], [], [], []]
        case .Groupe2:
            pathsForGroups = [ref.child("subway_saint_serge"), ref.child("point_chicken"), ref.child("tam"), ref.child("speed_burger"), ref.child("otacos"), ref.child("pizza_tempo")]
            nomsRestosForGroups = ["Subway Saint-Serge", "Point Chicken", "Le Tam'", "Speed Burger", "O'Tacos", "Pizza Tempo"]
            names = [[], [], [], [], [], []]
            surnames = [[], [], [], [], [], []]
            adresses = [[], [], [], [], [], []]
            commandes = [[], [], [], [], [], []]
            infos = [[], [], [], [], [], []]
        case .Groupe3:
            pathsForGroups = [ref.child("chicken_wrap"), ref.child("orient_halles"), ref.child("subway_fleur"), ref.child("punjab"), ref.child("lezard_vert"), ref.child("ylios"), ref.child("takos_king")]
            nomsRestosForGroups = ["Chicken Wrap", "Orient'Halles", "Subway Fleur-d'eau", "Le Punjab", "Le Lézard Vert", "Ylios Arhadia", "Takos King"]
            names = [[], [], [], [], [], [], []]
            surnames = [[], [], [], [], [], [], []]
            adresses = [[], [], [], [], [], [], []]
            commandes = [[], [], [], [], [], [], []]
            infos = [[], [], [], [], [], [], []]
        case .Groupe4:
            pathsForGroups = [ref.child("mcdo_foch"), ref.child("mie_caline"), ref.child("restaurant_vf"), ref.child("ashiq"), ref.child("mcdoner"), ref.child("minh"), ref.child("vite_frais")]
            nomsRestosForGroups = ["McDo Boulevard Foch", "La Mie Câline", "Restaurant Vf", "Ashiq Muhammad", "McDoner", "Chez Minh", "Vite&Frais"]
            names = [[], [], [], [], [], [], []]
            surnames = [[], [], [], [], [], [], []]
            adresses = [[], [], [], [], [], [], []]
            commandes = [[], [], [], [], [], [], []]
            infos = [[], [], [], [], [], [], []]
        case .admin:
            pathsForGroups = [ref.child("boite_pizzas"), ref.child("quai_bab"), ref.child("regal_doutre"), ref.child("O_classic"), ref.child("dominos"), ref.child("oriflamme"), ref.child("subway_saint_serge"), ref.child("point_chicken"), ref.child("tam"), ref.child("speed_burger"), ref.child("otacos"), ref.child("pizza_tempo"), ref.child("chicken_wrap"), ref.child("orient_halles"), ref.child("subway_fleur"), ref.child("punjab"), ref.child("lezard_vert"), ref.child("ylios"), ref.child("takos_king"), ref.child("mcdo_foch"), ref.child("mie_caline"), ref.child("restaurant_vf"), ref.child("ashiq"), ref.child("mcdoner"), ref.child("minh"), ref.child("vite_frais")]
            nomsRestosForGroups = ["La Boîte à Pizzas", "La Quai'bab d'Aladin", "Le régal de la doutre", "O'Classic", "Domino's Pizza", "L'Oriflamme", "Subway Saint-Serge", "Point Chicken", "Le Tam'", "Speed Burger", "O'Tacos", "Pizza Tempo", "Chicken Wrap", "Orient'Halles", "Subway Fleur-d'eau", "Le Punjab", "Le Lézard Vert", "Ylios Arhadia", "Takos King", "McDo Boulevard Foch", "La Mie Câline", "Restaurant Vf", "Ashiq Muhammad", "McDoner", "Chez Minh", "Vite&Frais"]
            names = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
            surnames = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
            adresses = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
            commandes = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
            infos = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
        }
        
        for i in pathsForGroups {
            
            i.observeSingleEvent(of: .value, with: { (snapshot) in
                self.lenghts.append(Int(snapshot.childrenCount))
            }, withCancel: nil)
            
        }
        
        
        
        
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
        fetch_commandes { (finished) in
            if finished {
                print("NAMES: \(self.names)")
            }
        }
        
    }
    
    
    
    
    
    func fetch_commandes(completionHandler: @escaping (Bool) -> ()) {
        switch groupeActuel {
        case .Groupe1:
            names = [[], [], [], [], [], []]
            surnames = [[], [], [], [], [], []]
            adresses = [[], [], [], [], [], []]
            commandes = [[], [], [], [], [], []]
            infos = [[], [], [], [], [], []]
        case .Groupe2:
            names = [[], [], [], [], [], []]
            surnames = [[], [], [], [], [], []]
            adresses = [[], [], [], [], [], []]
            commandes = [[], [], [], [], [], []]
            infos = [[], [], [], [], [], []]
        case .Groupe3:
            names = [[], [], [], [], [], [], []]
            surnames = [[], [], [], [], [], [], []]
            adresses = [[], [], [], [], [], [], []]
            commandes = [[], [], [], [], [], [], []]
            infos = [[], [], [], [], [], [], []]
        case .Groupe4:
            names = [[], [], [], [], [], [], []]
            surnames = [[], [], [], [], [], [], []]
            adresses = [[], [], [], [], [], [], []]
            commandes = [[], [], [], [], [], [], []]
            infos = [[], [], [], [], [], [], []]
        case .admin:
            names = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
            surnames = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
            adresses = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
            commandes = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
            infos = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
            
        }
        print("Number of restaurants: \(pathsForGroups.count)")

        
        for i in 0...(pathsForGroups.count - 1) {
            
            pathsForGroups[i].observeSingleEvent(of: .value) { (snapshot) in
                if !snapshot.exists() {
                    return
                } else {
                    
                    for j in 0...(Int(snapshot.childrenCount) - 1) {
                        
                        if let valeur = (snapshot.children.allObjects as! [DataSnapshot])[j].value as? [String:String] {
                          //  print("PRENOM: \(valeur["prenom"]!)")
                            self.surnames[i].append(valeur["prenom"]!)
                            self.names[i].append(valeur["nom"]!)
                            self.adresses[i].append(valeur["adresse"]!)
                            self.commandes[i].append(valeur["commandes"]!)
                            self.infos[i].append(valeur["infos_supp"]!)
                        }
                    }
                    completionHandler(true)
                    
                }
            }

            
        }
        
        self.collectionView.reloadData()
        
        
    }
    
    
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return pathsForGroups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LivreurCollectionViewCell
        cell.delegate = self
        
        cell.nomLabel.text = "👤 Nom: \(self.surnames[indexPath.section][indexPath.item]) \(self.names[indexPath.section][indexPath.item])"
        cell.adresseLabel.text = "🏠 Adresse : \(self.adresses[indexPath.section][indexPath.item])"
        cell.commandeLabel.text = "🍴 Commande : \(self.commandes[indexPath.section][indexPath.item])"
        cell.infosLabel.text = "🔔 Infos supplémentaires: \(self.infos[indexPath.section][indexPath.item])"
       // cell.phoneButton.addTarget(self, action: #selector(), for: .touchUpInside)
        
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names[section].count
    
    }
    var keys: [String] = []
    
    func fetchKeys(path: DatabaseReference, completionHandler: @escaping (Bool) -> ()) {
        keys = []
        path.observeSingleEvent(of: .value) { (snapshot) in
            
            for rest in snapshot.children.allObjects as! [DataSnapshot] {
                self.keys.append(rest.key)
            }
            completionHandler(true)
            
        }
        
    }
    
    func reservationDidTapLivree(_ sender: LivreurCollectionViewCell) {
        guard let tappedIndexPath = collectionView.indexPath(for: sender) else { return }
        print("Livrée", tappedIndexPath)
        
        let path = pathsForGroups[tappedIndexPath.section]
        fetchKeys(path: path) { (completed) in
            if completed {
                let keyToModify = self.keys[tappedIndexPath.item]
                let finalPath = path.child(keyToModify).child("etat")
                finalPath.setValue("livree")
            }
        }

        
    }
    
    func reservationDidTapPriseEnCharge(_ sender: LivreurCollectionViewCell) {
        guard let tappedIndexPath = collectionView.indexPath(for: sender) else { return }
        let path = pathsForGroups[tappedIndexPath.section]
        fetchKeys(path: path) { (completed) in
            if completed {
                let keyToModify = self.keys[tappedIndexPath.item]
                let finalPath = path.child(keyToModify).child("etat")
                finalPath.setValue("priseEnCharge")
            }
        }
    }
    
    func reservationDidTapImpossible(_ sender: LivreurCollectionViewCell) {
        guard let tappedIndexPath = collectionView.indexPath(for: sender) else { return }
        let path = pathsForGroups[tappedIndexPath.section]
        fetchKeys(path: path) { (completed) in
            if completed {
                let keyToModify = self.keys[tappedIndexPath.item]
                let finalPath = path.child(keyToModify).child("etat")
                finalPath.setValue("impossible")
            }
        }
    }
    
    @objc func callNumber(tel: String) {
        // Appeler numero
        // voir target pour num
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerLiv", for: indexPath) as? LivreurCollectionReusableView {
            
            
            sectionHeader.restaurantName.text = nomsRestosForGroups[indexPath.section]
            
            return sectionHeader
        }
        
        return UICollectionReusableView()
    }
    
    @IBAction func refresh(_ sender: Any) {
        fetch_commandes { (finished) in
            self.collectionView.reloadData()
        }
    }
    
    @objc func refreshCol() {
        fetch_commandes { (finished) in
            self.refresher.endRefreshing()
            self.collectionView.reloadData()
            self.refresher.endRefreshing()
            
        }
        
        self.refresher.endRefreshing()
    }

}
    

    
extension MesCommandeHotlineLivreurViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var totalHeight: CGFloat = 40
        if let cell = collectionView.cellForItem(at: indexPath) as? LivreurCollectionViewCell {

            let heightSV1 = cell.firstStackView.frame.height
            totalHeight += heightSV1

            let heightSV2 = cell.secondStackView.frame.height
            totalHeight += heightSV2
        }
        
        if totalHeight > 310 {
            return CGSize(width: 350, height: totalHeight)
        } else {
            return CGSize(width: 350, height: 310)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView.numberOfItems(inSection: section) == 0 {
            return CGSize.zero
        } else {
            let s = collectionView.frame.width
            let h: CGFloat = 75
            return CGSize(width: s, height: h)
        }
    }
}


enum GroupesLivraison {
    case Groupe1
    case Groupe2
    case Groupe3
    case Groupe4
    case admin
}
