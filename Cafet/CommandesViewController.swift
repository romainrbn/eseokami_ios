


//
//  CommandesViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 20/01/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CommandesViewController: UIViewController, IndicatorInfoProvider {
    
    var itemInfo: IndicatorInfo = "View"
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
