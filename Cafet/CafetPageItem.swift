//
//  CafetPageItem.swift
//  EseoKami
//
//  Created by Romain Rabouan on 17/02/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import BLTNBoard
import Lottie

class CafetPageItem: BLTNPageItem {
    var animationView = LOTAnimationView()
    
    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        animationView = LOTAnimationView(name: "Watermelon")
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 250)
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.animationView.play()
        }
        
        
        return [animationView]
    }
}
