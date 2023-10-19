//
//  GiftCollectionViewCell.swift
//  Lets Card
//
//  Created by Durgesh on 24/02/23.
//

import UIKit

class GiftCollectionViewCell: UICollectionViewCell {
    static let identifier = "giftCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var giftImage: UIImageView!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    func configure(_ cellData: GiftDataModel) {
        if titleLabel != nil {
            titleLabel.text = cellData.name
        }
        if giftImage != nil {
            giftImage.sd_setImage(with: URL(string: cellData.image), placeholderImage: UIImage(named: "gift_boxnew"), context: [:])
        }
        if subTitleLabel != nil {
            subTitleLabel.text = cellData.coin
        }
    }
    
    func configureDealer(_ imageName: String) {
        if giftImage != nil {
            giftImage.image = UIImage(named: imageName)
        }
    }
}
