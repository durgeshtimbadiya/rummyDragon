//
//  DialogInfoViewController.swift
//  Lets Card
//
//  Created by Durgesh on 22/02/23.
//

import UIKit

// MARK: - Protocol used for sending data back -
protocol DialogViewDelegate: AnyObject {
    func setDialogData(_ model: GiftDataModel, senderTag: Int)
}

class DialogInfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var infoBGImage: UIImageView!
    @IBOutlet weak var infoMainBGImage: UIImageView!
    @IBOutlet weak var gameInfoView: UIView!
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var soundOnOffBtn: UIButton!
    @IBOutlet weak var pointRummyButton: UIButton!
    @IBOutlet weak var poolRummyButton: UIButton!
    @IBOutlet weak var dealRummyButton: UIButton!
    @IBOutlet weak var soundOnOffTitle: UILabel!
    @IBOutlet weak var giftCollectionView: UICollectionView!
    @IBOutlet weak var giftMainView: UIView!
    @IBOutlet weak var backDialogView: UIView!
    @IBOutlet weak var rummyDialogView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet var gameInfoLabels: [UILabel]!
    // Making this a weak variable, so that it won't create a strong reference cycle
    weak var delegate: DialogViewDelegate? = nil

    var isInformationView = false
    var isSettingView = false
    var isGiftView = false
    var isBackView = false
    var isRummyView = false
    var gameInfoValues = [String]()
    var parentViewContr = DashboardViewController()
    var gameType: GameTypes!

    struct GameInfoData {
        var title = String()
        var firtImageSet = [String]()
        var secondImageSet = [String]()
        var thirdImageSet = [String]()
        var fourthImageSet = [String]()
    }
    
    private var gameInfoList = [GameInfoData]()
    private var gameGiftList = [GiftDataModel]()
    private var jackPotWinner: [Int] = [0, 0, 0, 0, 0, 0]
    //ic_silent
    //ic_volume_up

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.informationView.isHidden = true
        self.settingView.isHidden = true
        self.gameInfoView.isHidden = true
        self.giftMainView.isHidden = true
        self.backDialogView.isHidden = true
        self.rummyDialogView.isHidden = true
        
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [UIColor(hexString: "#3700B3").cgColor, UIColor(hexString: "#662D91").cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width - 20.0, height: self.backDialogView.bounds.height)
        self.backDialogView.layer.insertSublayer(gradient, at: 0)//(gradient)
        
        titleLabel.text = "Settings"
        if gameType == .point_rummy || gameType == .car_roulette || gameType == .andar_bahar || gameType == .teen_patti || gameType == .head_tails || gameType == .jackpot_teen_patti {
            titleLabel.text = "How To Play"
        }
        
        if isBackView {
            self.backDialogView.isHidden = false
        } else if isInformationView {
            self.informationView.isHidden = false
            gameInfoList.append(GameInfoData(title: "1.THREE OF A KING (RIO)", firtImageSet: ["bla", "rsa", "bpa"], secondImageSet: ["blk", "rpk", "bpk"], fourthImageSet: ["bl2", "rs2", "bp2"]))
            gameInfoList.append(GameInfoData(title: "2.STRIGHT FLUSH (PURESEQUENCE)", firtImageSet: ["bla", "blk", "blq"], secondImageSet: ["rpa", "rp2", "rp3"], thirdImageSet: ["bpk", "bpq", "bpj"], fourthImageSet: ["rs2", "rs3", "rs4"]))
            gameInfoList.append(GameInfoData(title: "3.STRIGHT (SEQUENCE)", firtImageSet: ["rpa", "blk", "rsq"], secondImageSet: ["rsk", "blq", "bpj"], thirdImageSet: ["bpa", "rp2", "bl3"], fourthImageSet: ["rs2", "bl3", "rp4"]))
            gameInfoList.append(GameInfoData(title: "4.FLUSH (COLOR)", firtImageSet: ["bla", "blk", "blj"], secondImageSet: ["rpa", "rpk", "rp10"], fourthImageSet: ["rs5", "rs3", "rs2"]))
            gameInfoList.append(GameInfoData(title: "5.PAIR (DOUBLE)", firtImageSet: ["bla", "rpa", "blk"], secondImageSet: ["bpa", "rsa", "blq"], fourthImageSet: ["bl2", "rp2", "bp3"]))
            gameInfoList.append(GameInfoData(title: "6.NO PAIR (HIGH CARD)", firtImageSet: ["bla", "rpk", "blj"], secondImageSet: ["bpa", "rsk", "bl10"], fourthImageSet: ["bl5", "rp3", "bp2"]))
            self.infoMainBGImage.isHidden = self.gameType != .jackpot_teen_patti
            self.infoBGImage.isHidden = self.gameType == .jackpot_teen_patti
            if gameType == .jackpot_teen_patti {
                self.getJackpotHistory()
            }
        } else if isSettingView {
            self.settingView.isHidden = false
            self.soundOnOffBtn.isSelected =  UserDefaults.standard.bool(forKey: Constants.UserDefault.isSoundEnable)
            self.soundOnOffTitle.text = self.soundOnOffBtn.isSelected ? "Game Volume On" : "Game Volume Off"
        } else if isGiftView {
            self.giftMainView.isHidden = false
            getGiftList()
        } else if isRummyView {
            self.pointRummyButton.setImage(UIImage.gif(name: "home_rummy_point"), for: .normal)
            self.dealRummyButton.setImage(UIImage.gif(name: "home_rummy_deal"), for: .normal)
            self.poolRummyButton.setImage(UIImage.gif(name: "home_rummy_pool"), for: .normal)
            self.rummyDialogView.isHidden = false
        } else {
            self.gameInfoView.isHidden = false
            let allLabels = ["BOOT VALUE : ", "MAXIMUM BLINDS : ", "CHHAL LIMIT : ", "POT LIMIT : "]
            for i in 0..<allLabels.count {
                let titleString = NSMutableAttributedString(string: "\(allLabels[i])\(gameInfoValues[i])")
                let fontWhite = [ NSAttributedString.Key.foregroundColor: UIColor.white ]
                let fontYellow = [ NSAttributedString.Key.foregroundColor: UIColor(hexString: "#E7FA2D") ]
                
                let rangeTitle1 = NSRange(location: 0, length: allLabels[i].count)
                let rangeTitle2 = NSRange(location: allLabels[i].count, length: gameInfoValues[i].count)
                
                titleString.addAttributes(fontWhite as [NSAttributedString.Key : Any], range: rangeTitle1)
                titleString.addAttributes(fontYellow as [NSAttributedString.Key : Any], range: rangeTitle2)
                self.gameInfoLabels[i].attributedText = titleString
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func tapOnBackDialogButtons(_ sender: UIButton) {
        if let del = delegate {
            del.setDialogData(GiftDataModel(), senderTag: sender.tag)
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        if isRummyView {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func tapOnSoundButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.soundOnOffTitle.text = sender.isSelected ? "Game Volume On" : "Game Volume Off"
        UserDefaults.standard.set(sender.isSelected, forKey: Constants.UserDefault.isSoundEnable)
    }
    
    @IBAction func tapOnRummy(_ sender: UIButton) {
       
        if sender.tag == 0 { // Point Rummy
            self.navigationController?.popViewController(animated: true)
            if let myobject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: PopupViewController().className) as? PopupViewController {
                self.parentViewContr.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
        } else if sender.tag == 1 { // Pool Rummy
            
        } else if sender.tag == 2 { // Deal Rummy
            
        }
    }
    
    private func getGiftList() {
        APIClient.shared.post(parameters: GameRequest(), feed: .Plan_gift, responseKey: "Gift") { result in
            switch result {
            case .success(let aPIResponse):
                if let response = aPIResponse, response.code == 200, let tabledata = response.data_array, tabledata.count > 0 {
                    tabledata.reversed().forEach { object in
                        self.gameGiftList.append(GiftDataModel(object))
                    }
                    self.giftCollectionView.reloadData()
                } else if let message = aPIResponse?.message, !message.isEmpty {
                    Toast.makeToast(message)
                }
                break
            case .failure(let error):
                Toast.makeToast(error.customDescription)
                break
            }
        }
    }
    
    private func getJackpotHistory() {
        APIClient.shared.post(parameters: Game3JackHistRequest(), feed: .JackP_last_winners, responseKey: "winners") { result in
            switch result {
            case .success(let aPIResponse):
                if let response = aPIResponse, response.code == 200, let jackPotHisData = response.data_array, jackPotHisData.count > 0 {
                    for jackpot in jackPotHisData {
                        if self.jackPotWinner.count > jackpot["winning"].intValue - 1 {
                            self.jackPotWinner[jackpot["winning"].intValue - 1] += 1
                        }
//                        switch jackpot["winning"].intValue {
//                        case 0:
//                            break
//                        case 1: // High card
//                            self.jackPotWinner[0] += 1
//                            break
//                        case 2: // PAIR
//                            self.jackPotWinner[1] += 1
//
//                            break
//                        case 3: // Color
//                            break
//                        case 4: // SEQ
//                            break
//                        case 5: // Pure SEq
//                            break
//                        case 6: // Set
//                            break
//                        default:
//                            break
//                        }
                    }
                    self.tableView.reloadData()
                    //winning
                } else if let message = aPIResponse?.message, !message.isEmpty {
                    Toast.makeToast(message)
                }
                break
            case .failure(let error):
                Toast.makeToast(error.customDescription)
                break
            }
        }
    }
}

extension DialogInfoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameType == .teen_patti ? self.gameInfoList.count : (gameType == .point_rummy ? 7 : (gameType == .andar_bahar ? 2 : 1))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if gameType != nil, let cell = tableView.dequeueReusableCell(withIdentifier: gameType.infoCellId, for: indexPath) as? InfoCardTableViewCell {
            //tableView.dequeueReusableCell(withIdentifier: isTeenPatti ? InfoCardTableViewCell.identifier : ((isRummyPoint || isAndarBaharGame || isCarRoulette || isAnimalRoulette) ? InfoCardTableViewCell.rummyIdentifier : (isColourPrediction ? InfoCardTableViewCell.cellCPIdentifier : (isHeadTails ? InfoCardTableViewCell.cellHeadTail : InfoCardTableViewCell.cellDNTIdentifier))), for: indexPath) as? InfoCardTableViewCell {
            if gameType == .teen_patti {
                cell.configure(self.gameInfoList[indexPath.row].title, firstCards: self.gameInfoList[indexPath.row].firtImageSet, secondCards: self.gameInfoList[indexPath.row].secondImageSet, thirdCards: self.gameInfoList[indexPath.row].thirdImageSet, fourthCards: self.gameInfoList[indexPath.row].fourthImageSet)
            } else if gameType == .point_rummy || gameType == .andar_bahar || gameType == .car_roulette || gameType == .animal_roulette {
                cell.configureImages(indexPath.row + 1, gameType: gameType)
            } else if gameType == .jackpot_teen_patti {
                cell.configureJackpot(self.jackPotWinner)
            }
            return cell
        }
        return UITableViewCell()
    }
}


extension DialogInfoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameGiftList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiftCollectionViewCell.identifier, for: indexPath) as? GiftCollectionViewCell {
            cell.configure(gameGiftList[indexPath.row])
            cell.layoutSubviews()
            cell.layoutIfNeeded()
            return cell
        }
        return UICollectionViewCell()
    }
}

extension DialogInfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let del = delegate {
            del.setDialogData(self.gameGiftList[indexPath.row], senderTag: -1)
            self.dismiss(animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130.0, height: 130.0)
    }
}
