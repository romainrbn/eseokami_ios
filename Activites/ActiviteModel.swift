//
//  ActiviteModel.swift
//  EseoKami
//
//  Created by Romain Rabouan on 31/12/2018.
//  Copyright © 2018 Romain Rabouan. All rights reserved.
//

import UIKit
import FirebaseDatabase

class Activite {
    let ref: DatabaseReference?
    var id: String?
    let key: String
    var nom: String?
    
    init(id: String?, nom: String?, key: String = "") {
        self.ref = nil
        self.key = key
        self.id = id
        self.nom = nom
    }
    
    init?(snapshot: DataSnapshot) {
        guard
        let value = snapshot.value as? [String:AnyObject],
        let nom = value["nom"] as? String,
        let id = value["id"] as? String else { return nil }
        
        self.ref = snapshot.ref
        self.key = snapshot.key
        self.nom = nom
    }
    
    func toAnyObject() -> Any {
        return [
            "nom":nom,
            "id":id
        ]
    }
    
    
}
