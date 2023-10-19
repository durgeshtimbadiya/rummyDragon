//
//  RummyWinnerTableViewCell.swift
//  Lets Card
//
//  Created by Durgesh on 01/02/23.
//

import UIKit

class RummyWinnerTableViewCell: UITableViewCell {
    
    static let identifier = "cellIdentifier"
    
    @IBOutlet weak var youLabel: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var winnerImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var wonLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var cardScrollView: UIScrollView!
    @IBOutlet weak var cardMainStackView: UIStackView!
    @IBOutlet weak var mainStackView: UIStackView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    func configure(_ cellData: RummyUserCard, myUserId: Int, winnerUserId: Int, jokerCardName: String) {
        if youLabel != nil {
            youLabel.isHidden = cellData.user_id != myUserId
        }
        if userNameLbl != nil {
            userNameLbl.text = cellData.name
        }
        if resultLabel != nil {
            resultLabel.isHidden = winnerUserId == cellData.user_id
            resultLabel.text = cellData.result == 1 ? "Dropped" : "Lost"
        }
        if mainStackView != nil {
            if winnerUserId == cellData.user_id {
                mainStackView.backgroundColor = UIColor(displayP3Red: 63.0 / 255.0, green: 63.0 / 255.0, blue: 63.0 / 255.0, alpha: 1.0)
                userNameLbl.textColor = .white
                resultLabel.textColor = .white
                scoreLabel.textColor = .white
                wonLabel.textColor = .white
                totalLabel.textColor = .white
            } else {
                mainStackView.backgroundColor = .white
                userNameLbl.textColor = .black
                resultLabel.textColor = .black
                scoreLabel.textColor = .black
                wonLabel.textColor = .black
                totalLabel.textColor = .black
            }
        }
        if cardMainStackView != nil {
            if cellData.cards.count > 0 {
                cellData.cards.forEach { object in
                    if object.cards.count > 0 {
                        self.createGroup(object.cards, jokerCardName: jokerCardName)
                    }
                }
            } else {
                self.createGroup(["backside_card", "backside_card", "backside_card", "backside_card", "backside_card", "backside_card", "backside_card", "backside_card", "backside_card", "backside_card", "backside_card", "backside_card"], jokerCardName: jokerCardName)
            }
        }
        if winnerImage != nil {
            winnerImage.isHidden = winnerUserId != cellData.user_id
        }
        if scoreLabel != nil {
            scoreLabel.text = cellData.score
        }
        if wonLabel != nil {
            wonLabel.text = "\(cellData.win)"
        }
        if totalLabel != nil {
            totalLabel.text = "\(cellData.total)"
        }
    }
    
    
    private func createGroup(_ cards: [String], jokerCardName: String) {
        let mainStckView = APRedorderableStackView()
        mainStckView.alignment = .bottom
        mainStckView.distribution = .fillEqually
        mainStckView.spacing = -18
        self.cardMainStackView.addArrangedSubview(mainStckView)
        var jokerNumber = jokerCardName
        jokerNumber = String(jokerNumber.dropFirst(2))
        
        for i in 0..<cards.count {
            let button = UIImageView()
            var cardNumber = cards[i].lowercased()
            if cardNumber.last == "_" {
                cardNumber.removeLast()
            }
            let bottomImage = UIImage(named: cardNumber)
            cardNumber = String(cardNumber.dropFirst(2))
            button.image = jokerNumber == cardNumber ? bottomImage?.mergeWithBottom(topImage: UIImage(named: "ic_joker")!) : bottomImage
            button.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 32.0))
            button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40.0))
    
            mainStckView.addArrangedSubview(button)
        }
    }
}
