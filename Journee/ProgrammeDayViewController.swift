//
//  ProgrammeDayViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 09/01/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import MapKit


class ProgrammeDayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let activites = ["L'éveil de Ryujin", "Le banquet d'Inari", "La Shocker Zone", "Les offrandes de Kitsune", "Le before des yokai", "Kannagara"]
    
    let heures = ["7h30-10h15", "12h-12h30", "18h-20h", "18h-21h", "19h-23h", "21h30-3h"]
    
    let lieux: [String?] = ["Salle Dirac", "Salle Dirac", "Angers", "Angers", "Le Garden", "Domaine de Chatillon"]
    
    let descriptions: [String?] = ["Petit-Déjeuner", "Activités et Repas du midi", "Activités", "Hotline", "Before", "Soirée"]
    
    let coordinates: [CLLocationCoordinate2D?] = [nil, nil, CLLocationCoordinate2D(latitude: 47.468405, longitude: -0.519055), nil, CLLocationCoordinate2D(latitude: 47.4704, longitude: -0.548359), CLLocationCoordinate2D(latitude: 47.5234, longitude: -0.5574)]
    
    let colorBackground = UIColor(red: 172/255, green: 62/255, blue: 79/255, alpha: 1)
    
    let annotation = MKPointAnnotation()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let navigation = UINavigationBar.appearance()
        
        let navigationFont = UIFont(name: "Gang of Three", size: 20)
        
        let navigationLargeFont = UIFont(name: "Gang of Three", size: 34) // 34 is Large Title size by default
        
       // navigation.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: navigationFont!]
        
        
        if #available(iOS 11, *){
            navigation.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: navigationLargeFont!]
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProgrammeCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.titleLabel.text = activites[indexPath.item]
        cell.heuresLabel.text = heures[indexPath.item]
        cell.lieuLabel.text = lieux[indexPath.item]
        if descriptions[indexPath.item] != nil {
            cell.descriptionLabel.text = descriptions[indexPath.item]
        } else {
            cell.descriptionLabel.text = ""
        }
        
        cell.backgroundColor = colorBackground
        
        if coordinates[indexPath.item] != nil {
            
            let center = CLLocationCoordinate2D(latitude: coordinates[indexPath.item]!.latitude, longitude: coordinates[indexPath.item]!.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            annotation.coordinate = coordinates[indexPath.item]!
           
            
        } else {
            
        }
        
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    
}
