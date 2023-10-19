//
//  InfoCardTableViewCell.swift
//  Lets Card
//
//  Created by Durgesh on 22/02/23.
//

import UIKit

class InfoCardTableViewCell: UITableViewCell {
    static let identifier = "dataCell"
    static let rummyIdentifier = "rummyInfoCell"
    static let cellDNTIdentifier = "cellDNT"
    static let cellJackpotIdentifier = "jackpotInfoCell"
    static let cellCPIdentifier = "cellCP"
    static let cellHeadTail = "cellHeadTail"
    
    @IBOutlet var stackView1Images: [UIImageView]!
    @IBOutlet var stackView2Images: [UIImageView]!
    @IBOutlet var stackView3Images: [UIImageView]!
    @IBOutlet var stackView4Images: [UIImageView]!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageViewV: UIImageView!
    @IBOutlet var labels: [UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        selectionStyle = .none
    }
    
    func configure(_ titleStr: String, firstCards: [String], secondCards: [String], thirdCards: [String], fourthCards: [String]) {
        if titleLabel != nil {
            self.titleLabel.text = titleStr
        }
        if firstCards.count == stackView1Images.count {
            for card in 0..<firstCards.count {
                stackView1Images[card].image = UIImage(named: firstCards[card])
            }
        }
        if secondCards.count == stackView2Images.count {
            for card in 0..<secondCards.count {
                stackView2Images[card].image = UIImage(named: secondCards[card])
            }
        }
        if thirdCards.count == stackView3Images.count {
            for card in 0..<thirdCards.count {
                stackView3Images[card].image = UIImage(named: thirdCards[card])
            }
        }
        if fourthCards.count == stackView4Images.count {
            for card in 0..<fourthCards.count {
                stackView4Images[card].image = UIImage(named: fourthCards[card])
            }
        }
    }
    
    func configureImages(_ imageTag: Int = 0, gameType: GameTypes) {
        if self.imageViewV != nil {
            if gameType == .car_roulette {
                self.imageViewV.image = UIImage(named: "car_oulette_rules")
            } else if gameType == .animal_roulette {
                self.imageViewV.image = UIImage(named: "animal_roulette_rules")
            } else {
                self.imageViewV.image = UIImage(named: gameType == .point_rummy ? "ic_rummy_rule\(imageTag)" : "ic_ab_rule\(imageTag)")
            }
        }
    }
    
    func configureJackpot(_ jackHist: [Int]) {
        for i in 0..<jackHist.count {
            self.labels[i].text = "\(jackHist[i])"
        }
    }
}
