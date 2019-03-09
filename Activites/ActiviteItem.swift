//
//  ActiviteItem.swift
//  EseoKami
//
//  Created by Romain Rabouan on 31/12/2018.
//  Copyright © 2018 Romain Rabouan. All rights reserved.
//

import UIKit
import BLTNBoard
import FirebaseDatabase
import FirebaseAuth

class ActiviteItem: BLTNPageItem {
    var collectionView: UICollectionView?
    let activites = ["Trampoline Park", "La cage", "Barbecue"]
    var selec: String = ""
    
    var refActivites: DatabaseReference!
  //  let activitiesVC = ActivitesViewController()
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        
        let collectionWrapper = interfaceBuilder.wrapView(collectionView, width: nil, height: 256, position: .pinnedToEdges)
        self.collectionView = collectionView
        
        collectionView.register(ActiviteItemCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return [collectionWrapper]
    }
    
    override func tearDown() {
        super.tearDown()
        
        collectionView?.dataSource = nil
        collectionView?.delegate = nil
    }
}


extension ActiviteItem: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        refActivites = Database.database().reference().child("users").child("activites")
        let key = refActivites.childByAutoId().key
        let activite = ["id":key, "nom":activites[indexPath.item]]
        refActivites.child(key!).setValue(activite)
        self.manager?.displayActivityIndicator()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
           self.manager?.displayNextItem()
        })

       // activitiesVC.finishedPage.descriptionText = self.selec
        print(selec)
        
        print(activites[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ActiviteItemCollectionViewCell
        cell.backgroundColor = UIColor(rgb: 0x21C434).withAlphaComponent(0.56)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.label.text = activites[indexPath.item]
        cell.label.clipsToBounds = true
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let longueur = collectionView.bounds.width
        let hauteur = CGFloat(75)
        return CGSize(width: longueur, height: hauteur)
    }
}
