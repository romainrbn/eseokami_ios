//
//  RestaurantTableViewCell.swift
//  EseoKami
//
//  Created by Romain Rabouan on 28/12/2018.
//  Copyright © 2018 Romain Rabouan. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var customLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
