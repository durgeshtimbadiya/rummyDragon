//
//  ChatDataTableViewCell.swift
//  Lets Card
//
//  Created by Durgesh on 23/02/23.
//

import UIKit

class ChatDataTableViewCell: UITableViewCell {

    static let leftIdentifier = "leftCell"
    static let rightIdentifier = "rightCell"
    
    @IBOutlet weak var messageLbl: PaddingLabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    private let myUserId = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(_ cellData: ChatModel, myProfileImg: String) {
        if messageLbl != nil {
            messageLbl.layer.masksToBounds = true
            self.messageLbl.cornerRadius = 10.0
            messageLbl.layer.maskedCorners = cellData.user_id == myUserId ? [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner] : [.layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            messageLbl.numberOfLines = cellData.chat.count > 25 ? 0 : 1
            messageLbl.text = cellData.chat

            messageLbl.sizeToFit()
            messageLbl.layoutIfNeeded()
        }
        if profileImage != nil && cellData.user_id == myUserId && !myProfileImg.isEmpty {
            profileImage.sd_setImage(with: URL(string: myProfileImg), placeholderImage: UIImage(named: "gamechaticon"), context: nil)
        }
        self.layoutIfNeeded()
    }
}
