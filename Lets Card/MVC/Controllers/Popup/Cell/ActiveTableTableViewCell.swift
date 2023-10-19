//
//  ActiveTableTableViewCell.swift
//  Lets Card
//
//  Created by Durgesh on 29/12/22.
//

import UIKit

class ActiveTableTableViewCell: UITableViewCell {

    static let headerCell = "headerCell"
    static let dataCell = "dataCell"
    
    @IBOutlet weak var bootLabel: UILabel!
    @IBOutlet weak var chaalLimitLabel: UILabel!
    @IBOutlet weak var potLimitLabel: UILabel!
    @IBOutlet weak var totalPlayersLabel: UILabel!
    @IBOutlet weak var playNowButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(_ cellData: ActiveTableModel, row: Int, target: Any, selector: Selector, gameType: GameTypes) {
        if bootLabel != nil {
            bootLabel.text = gameType == .teen_patti ? cellData.boot_value.cleanValue2 : cellData.point_value.cleanValue2
        }
        if chaalLimitLabel != nil {
            chaalLimitLabel.text = gameType == .teen_patti ? cellData.min_amount.cleanValue2 : cellData.boot_value.cleanValue2
        }
        if potLimitLabel != nil {
            potLimitLabel.text = gameType == .teen_patti ? cellData.pot_limit.cleanValue2 : "\(Int(cellData.pot_limit))"
        }
        if totalPlayersLabel != nil {
            totalPlayersLabel.text = "\(cellData.online_members)"
        }
        if playNowButton != nil {
            playNowButton.tag = row
            playNowButton.addTarget(target, action: selector, for: .touchUpInside)
        }
    }
}
