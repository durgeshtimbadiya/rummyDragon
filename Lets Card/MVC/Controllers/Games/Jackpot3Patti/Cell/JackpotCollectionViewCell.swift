//
//  JackpotCollectionViewCell.swift
//  Lets Card
//
//  Created by Durgesh on 03/07/23.
//

import UIKit

class JackpotCollectionViewCell: UICollectionViewCell {
    static let identifier = "componentCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addedAmtLbl: UILabel!
    @IBOutlet weak var selectedAmtLbl: UILabel!
    @IBOutlet weak var multiplierLbl: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var withConstraint: NSLayoutConstraint!
    @IBOutlet weak var winnerImage: UIImageView!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var animBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var animAmountLbl: UILabel!

    func configure(_ cellData: JackpotRulesModel) {
        if titleLabel != nil {
            self.titleLabel.text = cellData.rule_type
        }
        if addedAmtLbl != nil {
            self.addedAmtLbl.text = "\(cellData.added_amount)"
        }
        if selectedAmtLbl != nil {
            self.selectedAmtLbl.text = "\(cellData.select_amount)"
        }
        if multiplierLbl != nil {
            self.multiplierLbl.text = cellData.into
        }
    }
}
