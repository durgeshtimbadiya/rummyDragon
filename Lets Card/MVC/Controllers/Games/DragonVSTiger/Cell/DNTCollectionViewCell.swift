//
//  DNTCollectionViewCell.swift
//  Lets Card
//
//  Created by Durgesh on 01/03/23.
//

import UIKit

class DNTCollectionViewCell: UICollectionViewCell {
    static let lastBetCell = "lastBetCell"
    static let betCell = "betCell"
    static let playerCell = "playerCell"
    static let cellColourIdentifier = "cellColour"

    @IBOutlet weak var imageViewV: UIImageView!
    @IBOutlet weak var winView: UIView!
    @IBOutlet weak var highLitedView: UIView!
    @IBOutlet weak var nameLabel: PaddingLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    private let carImages = ["ic_car_circle_tata", "ic_car_circle_mahindra", "ic_car_circle_audi", "ic_car_circle_bmw", "ic_car_circle_mercedez", "ic_car_circle_porche", "ic_car_lamborghiani", "ic_car_circle_ferrari"]
    private let animalImages = ["ic_animal_tiger", "ic_animal_snake", "ic_animal_shark", "ic_animal_fox", "ic_animal_cheetah", "ic_animal_bear", "ic_animal_whale", "ic_animal_lion"]
    private let redVsBlackImages = ["ic_jackpot_strip_blue", "ic_red_dot", "ic_black_dot", "ic_jackpot_strip_purple", "ic_jackpot_strip_shade", "ic_jackpot_strip_green"]
    private let baccaratImages = ["ic_jackpot_strip_blue", "ic_jackpot_strip_green", "ic_jackpot_strip_orange", "ic_jackpot_strip_purple", "ic_jackpot_strip_shade", "ic_jackpot_strip_green"]
    private let jackpotLabels = ["", "HIGH", "PAIR", "COLOR", "SEQ", "PURE SEQ", "SET"]
    private let bacaratLabels = ["PLAYER", "BANKER", "TIE", "P.Pair", "B.Pair", ""]
    
    func configure(_ betAmount: Int, highLightet: Int) {
        self.imageViewV.image = UIImage(named: "ic_coin_\(betAmount)_dt")
        if self.highLitedView != nil {
            self.highLitedView.isHidden = betAmount != highLightet
        }
    }
    
    func configureBotUsers(_ cellData: HeadTailBotModel) {
        if self.titleLabel != nil {
            self.titleLabel.text = cellData.name
        }
        if self.subTitleLabel != nil {
            self.subTitleLabel.text = cellData.coin
        }
        if self.imageViewV != nil {
            self.imageViewV.sd_setImage(with: URL(string: cellData.avatar), placeholderImage: UIImage(named: "app_icon 1"), context: [:])
        }
    }
    
    func configureLast(_ cellData: LastWinningsModel, gameType: GameTypes) {
        switch gameType {
        case .seven_up_down:
            if nameLabel != nil {
                self.nameLabel.text = cellData.winning == "0" ? "2-6" : (cellData.winning == "1" ? "8-12" : "7")
                self.nameLabel.backgroundColor = .clear
                //self.nameLabel.backgroundColor = cellData.winning == "0" ? "2-6" : (cellData.winning == "1" ? "8-12" : "7")
            }
            if imageViewV != nil {
                self.imageViewV.image = cellData.winning == "0" ? UIImage(named: "red_pannel") : (cellData.winning == "1" ? UIImage(named: "green_pannel") : UIImage(named: "blue_pannel"))
            }
            break
        case .car_roulette:
            if imageViewV != nil {
                var item = 0
                if let iitm = Int(cellData.winning) {
                    item = iitm
                }
                if item != 0 {
                    item = item - 1
                }
                if item > carImages.count - 1 {
                    item = carImages.count - 1
                }
                imageViewV.image = UIImage(named: carImages[item])
            }
            break
        case .head_tails:
            if imageViewV != nil {
                imageViewV.image = UIImage(named: cellData.winning == "0" ? "ic_head_bg" : "ic_tail_bg")
            }
            break
        case .animal_roulette:
            if imageViewV != nil {
                var item = 0
                if let iitm = Int(cellData.winning) {
                    item = iitm
                }
                if item != 0 {
                    item = item - 1
                }
                if item > animalImages.count - 1 {
                    item = animalImages.count - 1
                }
                imageViewV.image = UIImage(named: animalImages[item])
            }
            break
        case .red_vs_black:
            if imageViewV != nil {
                var item = 0
                if let iitm = Int(cellData.winning) {
                    item = iitm
                }
                if item > redVsBlackImages.count - 1 {
                    item = redVsBlackImages.count - 1
                }
                imageViewV.image = UIImage(named: redVsBlackImages[item])
            }
            break
        case .bacarate:
            var item = 0
            if let iitm = Int(cellData.winning) {
                item = iitm
            }
            if item > baccaratImages.count - 1 {
                item = baccaratImages.count - 1
            }
            if titleLabel != nil {
                titleLabel.text = bacaratLabels[item]
            }
            if imageViewV != nil {
                imageViewV.image = UIImage(named: baccaratImages[item])
            }
            break
        case .jackpot_teen_patti:
            var item = 0
            if let iitm = Int(cellData.winning) {
                item = iitm
            }
            if item > baccaratImages.count - 1 {
                item = baccaratImages.count - 1
            }
            if titleLabel != nil {
                titleLabel.text = jackpotLabels[item]
            }
            if imageViewV != nil {
                imageViewV.image = UIImage(named: baccaratImages[item])
            }
        case .roulette:
            if titleLabel != nil {
                titleLabel.text = cellData.winning
            }
        default:
            imageViewV.image = UIImage(named: cellData.winning == "0" ? "ic_dt_d" : (cellData.winning == "1" ? "ic_dt_t" : "ic_dt_tie"))
            break
        }
        
        /*if isSevenUpDown && nameLabel != nil {
            self.nameLabel.text = cellData.winning == "0" ? "2-6" : (cellData.winning == "1" ? "8-12" : "7")
        } else if imageViewV != nil {
            if isCarRoulette {
                var item = 0
                if let iitm = Int(cellData.winning) {
                    item = iitm
                }
                if item != 0 {
                    item = item - 1
                }
                if item > carImages.count - 1 {
                    item = carImages.count - 1
                }
                imageViewV.image = UIImage(named: carImages[item])
            } else if isHeadTails {
                imageViewV.image = UIImage(named: cellData.winning == "0" ? "ic_head_bg" : "ic_tail_bg")
            } else if isAnimalRoulette {
                var item = 0
                if let iitm = Int(cellData.winning) {
                    item = iitm
                }
                if item != 0 {
                    item = item - 1
                }
                if item > animalImages.count - 1 {
                    item = animalImages.count - 1
                }
                imageViewV.image = UIImage(named: animalImages[item])
            } else if isRedVsBlack {
                var item = 0
                if let iitm = Int(cellData.winning) {
                    item = iitm
                }
                if item > redVsBlackImages.count - 1 {
                    item = redVsBlackImages.count - 1
                }
                imageViewV.image = UIImage(named: redVsBlackImages[item])
            } else if isBaccarat {
                var item = 0
                if let iitm = Int(cellData.winning) {
                    item = iitm
                }
                if titleLabel != nil {
                    switch item {
                    case 0:
                        titleLabel.text = "PLAYER"
                        break
                    case 1:
                        titleLabel.text = "BANKER"
                        break
                    case 2:
                        titleLabel.text = "TIE"
                        break
                    case 3:
                        titleLabel.text = "P.Pair"
                        break
                    case 4:
                        titleLabel.text = "B.Pair"
                        break
                    default:
                        // 1
                        break
                    }
                }
                if item > baccaratImages.count - 1 {
                    item = baccaratImages.count - 1
                }
                imageViewV.image = UIImage(named: baccaratImages[item])
            } else if isJackpot {
                var item = 0
                if let iitm = Int(cellData.winning) {
                    item = iitm
                }
                if item > baccaratImages.count - 1 {
                    item = baccaratImages.count - 1
                }
                imageViewV.image = UIImage(named: baccaratImages[item])
                titleLabel.text = jackpotLabels[item]
            } else if isRoullete {
                //ic_jackpot_strip_green
                if titleLabel != nil {
                    titleLabel.text = cellData.winning
                }
            } else {
                imageViewV.image = UIImage(named: cellData.winning == "0" ? "ic_dt_d" : (cellData.winning == "1" ? "ic_dt_t" : "ic_dt_tie"))
            }
        }*/
    }
    
    private func winningAnimation(_ viewV: UIView) {
        viewV.alpha = 1.0
        UIView.transition(with: viewV, duration: 1.0, options: .transitionCrossDissolve) {
            viewV.alpha = 0.0
        } completion: { isAaa in
            viewV.alpha = 1.0
        }
    }
    
    func configureColour(_ imageName: String, isWinner: Bool) {
        if self.imageViewV != nil {
            self.imageViewV.image = UIImage(named: imageName)
        }
        if self.winView != nil {
            self.winView.isHidden = !isWinner
            self.winningAnimation(self.winView)
            self.winView.layer.masksToBounds = true
            self.winView.layer.cornerRadius = 5
            self.winView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
        }
    }
}
