//
//  LivreurCollectionViewCell.swift
//  EseoKami
//
//  Created by Romain Rabouan on 23/02/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit

class LivreurCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var firstStackView: UIStackView!
    @IBOutlet weak var secondStackView: UIStackView!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var commandeLabel: UILabel!
    @IBOutlet weak var infosLabel: UILabel!
    @IBOutlet weak var nomLabel: UILabel!
    @IBOutlet weak var adresseLabel: UILabel!
    @IBOutlet weak var impossibleButton: UIButton!
    @IBOutlet weak var priseEnChargeButton: UIButton!
    @IBOutlet weak var livreeButton: UIButton!

    
    var isHeightCalculated: Bool = false
    weak var delegate: ReservationsCollectionViewItemDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.shadowOffset = CGSize(width: 1, height: 0)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.25
        self.clipsToBounds = false
        self.layer.masksToBounds = false
    }
    
    @IBAction func livreeTaped(_ sender: UIButton) {
        delegate?.reservationDidTapLivree(self)
    }
    
    @IBAction func priseEnChargeTapped(_ sender: UIButton) {
        delegate?.reservationDidTapPriseEnCharge(self)
    }
    
    @IBAction func impossibleTapped(_ sender: UIButton) {
        delegate?.reservationDidTapImpossible(self)
    }
    
   

}
