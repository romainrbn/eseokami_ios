//
//  CafetChoixRestoViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 28/12/2018.
//  Copyright © 2018 Romain Rabouan. All rights reserved.
//

import UIKit
import BLTNBoard
import XLPagerTabStrip
import Lottie

class CafetChoixRestoViewController: UITableViewController, IndicatorInfoProvider {
    
    var itemInfo = IndicatorInfo(title: "Faire une commande")
    
   // var numberOfItemsInCart = 0
    
    let calendar = Calendar.current
    let now = Date()
    
    let page = CafetPageItem(title: "Bienvenue dans la caféteria")
    let rizImage = UIImage(named: "rice")
    
    lazy var cafeteriaManager: BLTNItemManager = {
        page.descriptionText = "Ce midi, mange gratuitement grâce à nos partenaires."
        page.actionButtonTitle = "Me renseigner sur les menus"
//        page.image = rizImage?.withRenderingMode(.alwaysTemplate)
//
//        page.imageView?.tintColor = .orange
//        page.appearance.imageViewTintColor = .orange

        page.actionHandler = { item in
            let dix_trente = self.calendar.date(bySettingHour: 10, minute: 30, second: 0, of: self.now)!
            let treize = self.calendar.date(bySettingHour: 13, minute: 00, second: 00, of: self.now)!
            
            if self.now >= dix_trente && self.now <= treize {
                print("Commande possible")
                item.manager?.dismissBulletin(animated: true)
            } else {
                let alertController = UIAlertController(title: "Commande impossible", message: "Tu ne peux commander que entre 10h30 et 13h. 🍱", preferredStyle: .alert)
                let actionOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(actionOK)
                item.manager!.present(alertController, animated: true, completion: nil)
            }
        }
        let rootItem: BLTNItem = page
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    let imagesNames: [String] = ["mcDoIllustration", "pitayaIllustration", "pizzaIllustration"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.separatorColor = .clear


        
        
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dix_trente = self.calendar.date(bySettingHour: 10, minute: 30, second: 0, of: self.now)!
        let treize = self.calendar.date(bySettingHour: 13, minute: 00, second: 00, of: self.now)!
        if self.now >= dix_trente && self.now <= treize {
            print("Commande possible")
            self.performSegue(withIdentifier: "show\(indexPath.item)", sender: nil)
        } else {
            
            self.performSegue(withIdentifier: "show\(indexPath.item)", sender: nil)
            

        }
    }
    
    // Logic
    
    @objc func showMenuLateral() {
        performSegue(withIdentifier: "menuLateralShow", sender: self)
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBeforeCafet")
        
        cafeteriaManager.showBulletin(above: self)
        
        if !launchedBefore {
            print("Déja lancé, on n'affiche pas le bulletin")
        } else {
             cafeteriaManager.showBulletin(above: self)
        }
       
        
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }

}
