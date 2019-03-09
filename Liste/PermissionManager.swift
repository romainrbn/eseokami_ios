//
//  PermissionManager.swift
//  EseoKami
//
//  Created by Romain Rabouan on 30/12/2018.
//  Copyright © 2018 Romain Rabouan. All rights reserved.
//

import UIKit
import UserNotifications

class PermissionsManager {
    static let shared = PermissionsManager()
    
    func requestNotifications() {
        UIApplication.shared.registerForRemoteNotifications()
    }
}
