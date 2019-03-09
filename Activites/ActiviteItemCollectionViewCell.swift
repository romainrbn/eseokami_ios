//
//  ActiviteItemCollectionViewCell.swift
//  EseoKami
//
//  Created by Romain Rabouan on 31/12/2018.
//  Copyright © 2018 Romain Rabouan. All rights reserved.
//

import UIKit

class ActiviteItemCollectionViewCell: UICollectionViewCell {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22)
//        label.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
//        label.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
//        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
//        label.bottomAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
        label.center = contentView.center
        label.frame = CGRect(x: 10, y: 0, width: self.contentView.frame.width, height: self.contentView.frame.height)
        label.textAlignment = .left
        contentView.addSubview(label)
    }
}
