//
//  CardCollectionViewCell.swift
//  Lets Card
//
//  Created by Durgesh on 13/02/23.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    static let identifier = "cellIdentifier"
    
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var jokerCardView: UIView!
    @IBOutlet weak var statusView: UIStackView!
    @IBOutlet weak var statusViewLeading: NSLayoutConstraint!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
}
