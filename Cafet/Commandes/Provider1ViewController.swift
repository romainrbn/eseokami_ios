//
//  Provider1ViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 12/01/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import Floaty


class Provider1ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let floaty = Floaty()
    
    @IBOutlet var sectionButtons: [UIButton]!
    
    let elements: [[String]] = [["Big Mac","280 Original","Croq' McDo"], ["Frites", "Potatoes"], ["Coca zéro", "Ice Tea", "Fanta"], ["Sundae KitKat", "Sundae Daim"]]
    
    let sections = ["Burgers", "Frites", "Boissons", "Desserts"]
    
    let images = ["hamburger_rose", "french_fries_rose", "soda_rose", "glace_rose"]

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionButtons[0].addTarget(self, action: #selector(scrollToSection0), for: .touchUpInside)
        sectionButtons[1].addTarget(self, action: #selector(scrollToSection1), for: .touchUpInside)
        sectionButtons[2].addTarget(self, action: #selector(scrollToSection2), for: .touchUpInside)
        sectionButtons[3].addTarget(self, action: #selector(scrollToSection3), for: .touchUpInside)
        
        
        collectionView.showsVerticalScrollIndicator = false
        
        
        floaty.buttonImage = #imageLiteral(resourceName: "icons8-shopping-basket-24")
        
        floaty.buttonColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        
        self.view.addSubview(floaty)
        
    }
    
    @objc func scrollToSection0() {
        if let cv = self.collectionView {
            let indexPath = IndexPath(item: 0, section: 0)
            if let attributes =  cv.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                
                let topF = CGPoint(x: 0, y: attributes.frame.origin.y - cv.contentInset.top)
                cv.setContentOffset(topF, animated: true)
            }
        }
    }
    
    @objc func scrollToSection1() {
        if let cv = self.collectionView {
            let indexPath = IndexPath(item: 0, section: 1)
            if let attributes =  cv.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                
                let topF = CGPoint(x: 0, y: attributes.frame.origin.y - cv.contentInset.top)
                cv.setContentOffset(topF, animated: true)
            }
        }
    }
    
    @objc func scrollToSection2() {
        if let cv = self.collectionView {
            let indexPath = IndexPath(item: 0, section: 2)
            if let attributes =  cv.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                
                let topF = CGPoint(x: 0, y: attributes.frame.origin.y - cv.contentInset.top)
                cv.setContentOffset(topF, animated: true)
            }
        }
    }
    
    @objc func scrollToSection3() {
        if let cv = self.collectionView {
            let indexPath = IndexPath(item: 0, section: 3)
            if let attributes =  cv.layoutAttributesForSupplementaryElement(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                
                let topF = CGPoint(x: 0, y: attributes.frame.origin.y - cv.contentInset.top)
                cv.setContentOffset(topF, animated: true)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return elements[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      //  sectionButtons[indexPath.section].addTarget(self, action: #selector(scrollCollButtons), for: .touchUpInside)
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ElementFoodCollectionViewCell
        
        cell.elementName.text = elements[indexPath.section][indexPath.item]
        cell.moreInfoLabel.layer.cornerRadius = 10
        cell.moreInfoLabel.layer.masksToBounds = true
        
        if indexPath.section == 0 { // a voir avec les .
            cell.moreInfoLabel.isHidden = true
        } else if indexPath.section == 1 {
            cell.moreInfoLabel.text = "Grande taille"
            
        } else if indexPath.section == 2 {
            cell.moreInfoLabel.text = "50cl."
            
        } else if indexPath.section == 3 {
            cell.moreInfoLabel.isHidden = true
            
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? FoodCollectionReusableView {
            
            sectionHeader.foodTypeLabel.text = sections[indexPath.section]
            sectionHeader.foodTypeIcon.image = UIImage(named: images[indexPath.section])
            
            return sectionHeader
            
        }
        
        return UICollectionReusableView()
    }
}
