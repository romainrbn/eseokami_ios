//
//  ActivitesCollectionViewCell.swift
//  EseoKami
//
//  Created by Romain Rabouan on 31/12/2018.
//  Copyright © 2018 Romain Rabouan. All rights reserved.
//

import UIKit

class ActivitesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var activiteName: UILabel!
    @IBOutlet weak var descImage: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var qrCodeButton: UIButton!
    
    override func layoutSubviews() {
      //  qrCodeButton.imageView?.image = UIImage(named: "qrCode")?.withRenderingMode(.alwaysTemplate)
        
     //   activiteName.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    }
}
