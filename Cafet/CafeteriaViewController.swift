//
//  CafeteriaViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 20/01/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class CafeteriaViewController: ButtonBarPagerTabStripViewController {
    
    let purpleInspireColor = UIColor(red: 1, green: 12/255, blue: 56/255, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        buttonBarView.selectedBar.backgroundColor = purpleInspireColor
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.selectedBarBackgroundColor = purpleInspireColor
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 2.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = UIColor(red: 1, green: 12/255, blue: 56/255, alpha: 1)
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .black
            newCell?.label.textColor = self?.purpleInspireColor
        }
        
        
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child1")
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "child3")
        return [child_1, child_2]
    }
    

   

}
