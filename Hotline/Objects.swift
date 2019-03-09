//
//  Restaurant.swift
//  EseoKami
//
//  Created by Romain Rabouan on 20/02/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase

class Restaurant {
    var nom: String
    var coordinates: CLLocationCoordinate2D
    var numero: [String]
    var path: String
    var livreurs: [String]

    
    init(nom: String, coordinates: CLLocationCoordinate2D, numero: [String], path: String, livreurs: [String]) {
        self.nom = nom
        self.coordinates = coordinates
        self.numero = numero
        self.path = path
        self.livreurs = livreurs
    }
    
}

class Commande {
    var nom: String
    var prenom: String
    var adresse: String
    var infos: String?
    var commande: String
    var tel: String
    var restaurantName: String
    var restaurantCoordinates: CLLocationCoordinate2D
    var restaurant: Restaurant
    var livreurs: [String]
    var state: CommandesStates
    
    init(nom: String, prenom: String, adresse: String, infos: String?, commande: String, tel: String, restaurantName: String, restaurantCoordinates: CLLocationCoordinate2D, restaurant: Restaurant, livreurs: [String], state: CommandesStates) {
        self.nom = nom
        self.prenom = prenom
        self.adresse = adresse
        self.infos = infos
        self.commande = commande
        self.tel = tel
        self.restaurantName = restaurantName
        self.restaurantCoordinates = restaurantCoordinates
        self.restaurant = restaurant
        self.livreurs = livreurs
        self.state = state
    }
    
    
}

class CommandeLivreur {
    
    var state: CommandesStates
    
    init(state: CommandesStates) {
        self.state = state
    }
}

class UserEseo {
    var name: String
    var nbrePoints: Int
    var email: String
    
    init(name: String, nbrePoints: Int, email: String) {
        self.name = name
        self.nbrePoints = nbrePoints
        self.email = email
    }
}

enum CommandesStates {
    case livree
    case preparation
    case impossible
    case priseEnCharge
}
