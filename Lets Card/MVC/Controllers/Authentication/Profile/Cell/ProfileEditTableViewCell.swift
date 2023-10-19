//
//  ProfileEditTableViewCell.swift
//  Lets Card
//
//  Created by Durgesh on 21/12/22.
//

import UIKit

struct ProfileCellData {
    var title = String()
    var placeHolder = String()
    var value = String()
    var title2 = String()
    var placeHolder2 = String()
    var value2 = String()
    var image = Constants.appLogoImage
}

class ProfileEditTableViewCell: UITableViewCell {
    static let textCell = "textCell"
    static let submitCell = "submitCell"
    static let imageCell = "imageCell"
    static let labelCell = "labelCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textFieldT: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var titleLabel2: UILabel!
    @IBOutlet weak var textFieldT2: UITextField!
    @IBOutlet weak var imageViewV: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ cellData: ProfileCellData, row: Int, target: Any, selector: Selector, isLastRow: Bool, isLastSecondRow: Bool) {
        if titleLabel != nil {
            titleLabel.text = cellData.title
        }
        if textFieldT != nil {
            textFieldT.placeholder = cellData.placeHolder
            textFieldT.text = cellData.value
            textFieldT.tag = row
            textFieldT.isUserInteractionEnabled = !isLastRow
            textFieldT.returnKeyType = isLastSecondRow ? .done : .next
        }
        if submitButton != nil {
            submitButton.addTarget(target, action: selector, for: .touchUpInside)
        }
    }
    
    func configureDashProfile(_ cellData: ProfileCellData, row: Int) {
        if imageViewV != nil {
            imageViewV.isHidden = row % 2 != 0
        }
        if titleLabel != nil {
            titleLabel.text = cellData.title
        }
        if titleLabel2 != nil {
            titleLabel2.text = cellData.value
        }
    }
    
    func configureBank(_ cellData: ProfileCellData, row: Int, target: Any, selectors: [Selector], isLastRow: Bool, isLastSecondRow: Bool) {
        if titleLabel != nil {
            titleLabel.text = cellData.title
        }
        if textFieldT != nil {
            textFieldT.placeholder = cellData.placeHolder
            textFieldT.text = cellData.value
            textFieldT.tag = row
            textFieldT.isUserInteractionEnabled = !isLastRow
            textFieldT.returnKeyType = .next
        }
        if titleLabel2 != nil {
            titleLabel2.text = cellData.title2
        }
        if textFieldT2 != nil {
            textFieldT2.placeholder = cellData.placeHolder2
            textFieldT2.text = cellData.value2
            textFieldT2.tag = row
            textFieldT2.layer.setValue(row + 19, forKey: "extraTag")
            textFieldT2.isUserInteractionEnabled = !isLastRow
            textFieldT2.returnKeyType = isLastSecondRow ? .done : .next
        }
        if imageViewV != nil {
            imageViewV.image = cellData.image
        }
        if submitButton != nil {
            submitButton.addTarget(target, action: isLastRow ? selectors[1] : selectors[0], for: .touchUpInside)
        }
    }
}
