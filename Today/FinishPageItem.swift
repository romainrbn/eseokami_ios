//
//  FinishPageItem.swift
//  EseoKami
//
//  Created by Romain Rabouan on 17/02/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import BLTNBoard
import Lottie

class FinishPageItem: BLTNPageItem {
    
    var animationView = LOTAnimationView()
    
    override func makeViewsUnderTitle(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        animationView = LOTAnimationView(name: "anim2")
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.contentMode = .scaleAspectFit
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.animationView.play()
        }

        
        return [animationView]
    }
}
