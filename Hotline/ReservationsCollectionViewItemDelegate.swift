//
//  ReservationsCollectionViewItemDelegate.swift
//  EseoKami
//
//  Created by Romain Rabouan on 02/03/2019.
//  Copyright © 2019 Romain Rabouan. All rights reserved.
//

import UIKit

protocol ReservationsCollectionViewItemDelegate: class {
    func reservationDidTapLivree(_ sender: LivreurCollectionViewCell)
    func reservationDidTapPriseEnCharge(_ sender: LivreurCollectionViewCell)
    func reservationDidTapImpossible(_ sender: LivreurCollectionViewCell)
}
