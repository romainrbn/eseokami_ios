//
//  IdeesProgrammeViewController.swift
//  EseoKami
//
//  Created by Romain Rabouan on 06/02/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit

class IdeesProgrammeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let titles = ["Réduire le déficit de la Blue Moon", "Organiser un Afterwork par mois", "Le camion du BDE gratuit pour les clubs de l’ESEO", "Varier les repas à la caféteria", "Rajouter des bornes de commandes à la caféteria", "Créer une carte de fidélité", "Remettre en avant le poste de délégué de classe", "Réaliser des Fast and Curious"]
    let subtitles = ["Mise en place d’un partenariat inter-école. En l’échange de fonds afin de financer la Blue Moon, l’école partenaire bénéficiera du rayonnement médiatique de l’événement et de tarifs préférentiels. Nous resterons cependant le seul organisateur.", "Organiser un Afterwork tous les mercredis soir de la 3ème semaine du mois au Garden (Bar du before de notre journée) avec des prix spéciaux pour les étudiants de l’ESEO. Deux Afterworks de prévu pour le retour des « bi-diplômes » et l’arrivée des « Pass’Ingé ».", "300€ de caution d’essence (en cas de plein non fait)\n1500€ de caution camion (s’il est abimé)", "Proposer une variété de plats plus importante le midi, ajouter des plats préparés, modifier les plats selon les arrivages, proposer des corbeilles de fruits et de légumes en fonction des saisons, organiser un repas spécial lors des semaines d’animation.", "Rajouter des bornes de commandes à la cafétéria afin de faciliter la prise de commande.", "Au bout de 10 repas achetés, un sandwich offert", "Meilleure communication avec les élèves et l’administration, notamment lors des réunions de promotions où les délégués de chaque classe sont conviés par l’administration.", "Réaliser des Fast and Curious avec le corps professoral, administratif, et un membre de chaque club actif."]
    
    let images = ["blue_moon", "biere_prog", "camion", "cafet", "resa", "carte_fid", "delegue", "fast_curious"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! IdeeCollectionViewCell
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        
        cell.titleLabel.text = titles[indexPath.item]
        cell.descLabel.text = subtitles[indexPath.item]
        cell.accImage.image = UIImage(named: images[indexPath.item])
        
        return cell
    }
    

   

}
