//
//  SponsorsViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 12/01/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit


class SponsorsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let sponsorsNames = ["Heetch"]
    let sponsorsLogos: [UIImage] = [UIImage(named: "heetch")!]
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sponsorsNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SponsorsCollectionViewCell
        cell.layer.cornerRadius = 8
        cell.sponsorName.text = sponsorsNames[indexPath.row]
        cell.sponsorLogo.image = sponsorsLogos[indexPath.row]
        return cell
    }
    

    

}
