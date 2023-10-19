//
//  Jackpot3PattiViewController.swift
//  Lets Card
//
//  Created by Durgesh on 28/06/23.
//

import UIKit

class Jackpot3PattiViewController: UIViewController {
    
    @IBOutlet weak var profileBottomView: UIView!
//    @IBOutlet weak var profileImage: UIImageView!
//    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var walletBalLbl: UILabel!
    @IBOutlet weak var betEndImage: UIImageView!
    @IBOutlet weak var jackpotWinBoxImage: UIImageView!
    @IBOutlet weak var betCollectionView: UICollectionView!
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    @IBOutlet weak var componectCollectionView: UICollectionView!
    
    @IBOutlet weak var jackpotAmountLbl: UILabel!
    @IBOutlet weak var bigWinAmountLbl: UILabel!
    @IBOutlet weak var bigWinNameLbl: UILabel!
    @IBOutlet weak var bigWinImage: UIImageView!
    @IBOutlet var cardImages: [UIImageView]!

    @IBOutlet weak var battingLabel: UILabel!
    @IBOutlet weak var otherUserView: UIStackView!
    @IBOutlet weak var otherUserLabel: UILabel!
    
    @IBOutlet weak var pleaseWaitView: UIView!
    
    private var rulesModelList = [JackpotRulesModel]()
    private var coinsDataList = [10, 50, 100, 1000, 5000]
    
    private var placeGameAmount = 0
    
    private var isCardsDisribute = false
    private var winnerId = -1
    private var lastWinList = [LastWinningsModel]()
    
    private var game_id = ""
    private var timeRemaining = 0
    private var timeRemainingCard = 0
    private var isGameBegning = false
    private var canbet = false
    private var added_date = ""
    private var allCardsArray = [String]()
    private var isBetStarted = false
    private var isBotPlayerSet = false
    
    private var timerStatus = Timer()
    private var gameStartTimer = Timer()
    private var cardDistributeTimer = Timer()
    
    private let SET = "SET"
    private let PURE_SEQ = "PURE SEQ"
    private let SEQ = "SEQ"
    private let COLOR = "COLOR"
    private let PAIR = "PAIR"
    private let HIGH_CARD = "HIGH"
    
    private var set_amount = 0
    private var pure_sequence_amount = 0
    private var sequence_amount = 0
    private var color_amount = 0
    private var pair_amount = 0
    private var high_card_amount = 0
    
    private let jackpot_winbox = ["ic_jackpot_winbox_blue", "ic_jackpot_winbox_green", "ic_jackpot_winbox_orange", "ic_jackpot_winbox_purple", "ic_jackpot_winbox_shade", "ic_jackpot_winbox_green"]
    private let jackpot_win_label = ["", "HIGH", "PAIR", "COLOR", "SEQ", "PURE SEQ", "SET"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        startGameStatus()
        setSetRulesValue()
    }
    
    private func setSetRulesValue() {
        rulesModelList.removeAll()
        rulesModelList.append(JackpotRulesModel(rule_type: SET, rule_value: 6, added_amount: 0, select_amount: 0, into: "20%"))
        rulesModelList.append(JackpotRulesModel(rule_type: PURE_SEQ, rule_value: 5, added_amount: 0, select_amount: 0, into: "10X"))
        rulesModelList.append(JackpotRulesModel(rule_type: SEQ, rule_value: 4, added_amount: 0, select_amount: 0, into: "6X"))
        rulesModelList.append(JackpotRulesModel(rule_type: COLOR, rule_value: 3, added_amount: 0, select_amount: 0, into: "5X"))
        rulesModelList.append(JackpotRulesModel(rule_type: PAIR, rule_value: 2, added_amount: 0, select_amount: 0, into: "4X"))
        rulesModelList.append(JackpotRulesModel(rule_type: HIGH_CARD, rule_value: 1, added_amount: 0, select_amount: 0, into: "3X"))
        self.componectCollectionView.reloadData()
        self.betCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setCarRotationAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerStatus.invalidate()
        timerStatus.invalidate()
        gameStartTimer.invalidate()
        gameStartTimer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.pleaseWaitView.isHidden = true
//        self.makeDummyAnimation()
//        self.timeRemaining = 10
//        self.setGameTimer()
    }

    @IBAction func tapOnBackButton(_ sender: UIButton) {
        PromptVManager.present(self, titleString: "CONFIRMATOIN", messageString: "Are you sure, you want to Leave ?", viewTag: 1)
    }
    
    @IBAction func tapOnAddChips(_ sender: UIButton) {
       
    }
    
    @IBAction func tapOnInfoButton(_ sender: UIButton) {
        if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: DialogInfoViewController().className) as? DialogInfoViewController {
            myObject.isInformationView = true
            myObject.gameType = GameTypes.jackpot_teen_patti
            self.navigationController?.present(myObject, animated: true)
        }
    }
    
    private func startGameStatus() {
        if timerStatus.isValid {
            timerStatus.invalidate()
        }
        timerStatus = Timer(timeInterval: 5, target: self, selector: #selector(self.gameStatus), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timerStatus, forMode: .default)
        timerStatus.fire()
    }
    
    private func setGameTimer() {
        if gameStartTimer.isValid {
            gameStartTimer.invalidate()
        }
        gameStartTimer = Timer(timeInterval: 1, target: self, selector: #selector(self.updateGameStartTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.gameStartTimer, forMode: .default)
        gameStartTimer.fire()
    }
    
    @objc private func updateGameStartTimer() {
        timeRemaining -= 1
        if timeRemaining == 0 {
            self.battingLabel.text = "Betting 0.0s"
            //self.betEndImage.isHidden = false
            //self.betEndImage.frame.size.height = 0.0
            //self.betEndImage.image = UIImage(named: "iv_bet_stops")
            //UIView.transition(with: self.betEndImage, duration: 1, options: .curveEaseInOut) {
            //    self.betEndImage.frame.size.height = 33.0
            //}
//            self.isCardsDisribute = false
//            if !timerStatus.isValid {
//                self.startGameStatus()
//            }
        }
        if timeRemaining < 0 {
            if gameStartTimer.isValid {
                gameStartTimer.invalidate()
            }
            return
        }
//        makeDummyAnimation()
        self.battingLabel.text = "Betting \(timeRemaining).0s"
    }
    
    private func cardDistributedTimer() {
        timeRemainingCard = 0
        if cardDistributeTimer.isValid {
            cardDistributeTimer.invalidate()
        }
        cardDistributeTimer = Timer(timeInterval: 1, target: self, selector: #selector(self.updateCardTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.cardDistributeTimer, forMode: .default)
        cardDistributeTimer.fire()
    }
    
    @objc private func updateCardTimer() {
        if timeRemainingCard == allCardsArray.count {
            if cardDistributeTimer.isValid {
                cardDistributeTimer.invalidate()
            }
            self.setWinningView()
            return
        }
        if allCardsArray.count > timeRemainingCard {
            self.cardImages[timeRemainingCard].image = UIImage(named: allCardsArray[timeRemainingCard].lowercased())
        }
        timeRemainingCard += 1
    }
    
    private func setWinningView() {
        self.jackpotWinBoxImage.image = UIImage(named: jackpot_winbox[winnerId])
        self.pleaseWaitView.isHidden = false
        self.battingLabel.text = self.jackpot_win_label[winnerId]
        delay(2) {
            self.componectCollectionView.reloadData()
            self.delay(2) {
                self.isCardsDisribute = false
            }
        }
    }
}

extension Jackpot3PattiViewController {
    private func placeBet(_ tagIndex: Int) {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: ColourPredBetRequest(game_id: self.game_id, bet: "\(self.rulesModelList[tagIndex].rule_value)", amount: "\(self.placeGameAmount)"), feed: .JackP_place_bet, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse?.data, apiResponse?.code == 200 {
                        self.walletBalLbl.text = response["wallet"].stringValue
                        self.rulesModelList[tagIndex].select_amount = self.rulesModelList[tagIndex].select_amount + self.placeGameAmount
                        self.componectCollectionView.reloadData()
                        self.gameStatus()
                    } else if let message = apiResponse?.message, !message.isEmpty {
                        Toast.makeToast(message)
                    }
                    break
                case .failure(_):
//                    Toast.makeToast(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    @objc private func gameStatus() {
        if isCardsDisribute {
            return
        }
        DispatchQueue.global(qos: .background).async { [self] in
            APIClient.shared.post(parameters: Game3PJackpotRequest(total_bet_high_card: "\(high_card_amount)", total_bet_pair: "\(pair_amount)", total_bet_color: "\(color_amount)", total_bet_sequence: "\(sequence_amount)", total_bet_pure_sequence: "\(pure_sequence_amount)"), feed: .JackP_get_active_game, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let responseCode = apiResponse?.code, responseCode == 407 {
                        self.dismiss(animated: true)
                    } else if let response = apiResponse?.data, apiResponse?.code == 200 {
                        var gameStatus = ""
                        winnerId = -1
                        lastWinList = [LastWinningsModel]()
                        if let lastWinnings = response["last_winning"].array, lastWinnings.count > 0 {
                            lastWinnings.forEach { object in
                                lastWinList.append(LastWinningsModel(object))
                            }
                            self.resultCollectionView.reloadData()
                        }
                        if let bigWinners = response["big_winner"].array, bigWinners.count > 0, let userList = bigWinners[0]["user_data"].array, userList.count > 0 {
                            let profileImage = userList[0]["profile_pic"].stringValue
                            self.bigWinImage.sd_setImage(with: URL(string: "\(Constants.baseURL)\(APIClient.imagePath)\(profileImage)"), placeholderImage: UIImage(named: "avatar"), context: [:])
                            self.bigWinNameLbl.text = userList[0]["name"].stringValue
                            self.bigWinAmountLbl.text = "\(Constants.currencySymbol)\(userList[0]["winning_amount"].int ?? 0)"
                        }
                        if let online = response["online"].int {
                            otherUserLabel.text = "\(online)"
                        } else if let online = response["online"].string {
                            otherUserLabel.text = online
                        }
                        if let profileArrayData = response["profile"].array, profileArrayData.count > 0 {
                            let profileDataModel = ProfileData(profileArrayData[0])
                            self.walletBalLbl.text = profileDataModel.wallet.cleanValue2
                        }

                        if let gameDataList = response["game_data"].array, gameDataList.count > 0 {
                            gameDataList.forEach { gameData in
                                if let online = gameData["status"].int {
                                    gameStatus = "\(online)"
                                } else if let online = gameData["status"].string {
                                    gameStatus = online
                                }
                            
                                
//                                if let winr = gameData["winning_rule"].int {
//                                    winningRule = winr
//                                } else if let winr = gameData["winning_rule"].string {
//                                    winningRule = Int(winr) ?? -1
//                                }

                                if let timeRemaining1 = gameData["time_remaining"].int {
                                    timeRemaining = timeRemaining1
                                } else if let timeRemaining1 = gameData["time_remaining"].string {
                                    timeRemaining = Int(timeRemaining1) ?? 0
                                }
                                
//                                addedDate = gameData["added_date"].stringValue
                                game_id = gameData["id"].stringValue
                            }
                        }
                        
                        // New game started here
                        if gameStatus == "0" && !isGameBegning {
                            restartGame()
                            isGameBegning = true
                            
                            if timeRemaining > 0 {
                                // Distribute coins animation
                                //Start bet animation
                                isBetStarted = true
                                self.betEndImage.image = UIImage(named: "iv_bet_begin")
                                self.betEndImage.frame.size.height = 0.0
                                self.betEndImage.isHidden = false
                                UIView.transition(with: self.betEndImage, duration: 1) {
                                    self.betEndImage.frame.size.height = 70.0
                                } completion: { isA in
                                    self.delay(1) {
                                        self.betEndImage.isHidden = true
                                    }
                                }
                                self.setGameTimer()
                            } else {
                                self.gameStartTimer.invalidate()
                            }
                        } else if gameStatus == "0" && isGameBegning {
//                            player_pair_amount = 0
//                            banker_pair_amount = 0
//                            player_amount = 0
//                            tie_amount = 0
//                            banker_amount = 0
                            self.jackpotAmountLbl.text = "\(Constants.currencySymbol)\(response["jackpot_amount"].intValue)"
                            
                            for i in 0..<rulesModelList.count {
//                                var putbetAmount = 0
                                switch rulesModelList[i].rule_type {
                                case "SET":
                                    if let amount = response["set_amount"].int {
//                                        putbetAmount = amount - set_amount
                                        set_amount = amount
                                        rulesModelList[i].added_amount = set_amount
                                    } else if let amount = response["set_amount"].string {
//                                        putbetAmount = Int(amount) ?? 0 - set_amount
                                        set_amount = Int(amount) ?? 0
                                        rulesModelList[i].added_amount = set_amount
                                    }
                                    break
                                case "PURE SEQ":
                                    if let amount = response["pure_sequence_amount"].int {
//                                        putbetAmount = amount - pure_sequence_amount
                                        pure_sequence_amount = amount
                                        rulesModelList[i].added_amount = pure_sequence_amount
                                    } else if let amount = response["pure_sequence_amount"].string {
//                                        putbetAmount = Int(amount) ?? 0 - pure_sequence_amount
                                        pure_sequence_amount = Int(amount) ?? 0
                                        rulesModelList[i].added_amount = pure_sequence_amount
                                    }
                                    break
                                case "SEQ":
                                    if let amount = response["sequence_amount"].int {
//                                        putbetAmount = amount - sequence_amount
                                        sequence_amount = amount
                                        rulesModelList[i].added_amount = sequence_amount
                                    } else if let amount = response["sequence_amount"].string {
//                                        putbetAmount = Int(amount) ?? 0 - sequence_amount
                                        sequence_amount = Int(amount) ?? 0
                                        rulesModelList[i].added_amount = sequence_amount
                                    }
                                    break
                                case "COLOR":
                                    if let amount = response["color_amount"].int {
//                                        putbetAmount = amount - color_amount
                                        color_amount = amount
                                        rulesModelList[i].added_amount = color_amount
                                    } else if let amount = response["color_amount"].string {
//                                        putbetAmount = Int(amount) ?? 0 - color_amount
                                        color_amount = Int(amount) ?? 0
                                        rulesModelList[i].added_amount = color_amount
                                    }
                                    break
                                case "PAIR":
                                    if let amount = response["pair_amount"].int {
//                                        putbetAmount = amount - pair_amount
                                        pair_amount = amount
                                        rulesModelList[i].added_amount = pair_amount
                                    } else if let amount = response["pair_amount"].string {
//                                        putbetAmount = Int(amount) ?? 0 - pair_amount
                                        pair_amount = Int(amount) ?? 0
                                        rulesModelList[i].added_amount = pair_amount
                                    }
                                    break
                                case "HIGH":
                                    if let amount = response["high_card_amount"].int {
//                                        putbetAmount = amount - high_card_amount
                                        high_card_amount = amount
                                        rulesModelList[i].added_amount = high_card_amount
                                    } else if let amount = response["high_card_amount"].string {
//                                        putbetAmount = Int(amount) ?? 0 - high_card_amount
                                        high_card_amount = Int(amount) ?? 0
                                        rulesModelList[i].added_amount = high_card_amount
                                    }
                                    break
                                default:
                                    break
                                }
                            }
                            self.componectCollectionView.reloadData()
                        }
                        if gameStatus == "1" && !isGameBegning {
                            self.pleaseWaitView.isHidden = false
                        }
                        //iv_bet_begin, iv_bet_stops
                        if gameStatus == "1" && isGameBegning {
                            isGameBegning = false
                            self.betEndImage.isHidden = false
                            self.betEndImage.frame.size.height = 0.0
                            self.betEndImage.image = UIImage(named: "iv_bet_stops")
                            self.isCardsDisribute = true
                            UIView.transition(with: self.betEndImage, duration: 1, options: .curveEaseInOut) {
                                self.betEndImage.frame.size.height = 70.0
                                self.delay(1) { [self] in
                                    self.betEndImage.isHidden = true
                                    allCardsArray = [String]()
                                    if let gameCards = response["game_cards"].array, gameCards.count > 0 {
                                        gameCards.forEach { object in
                                            allCardsArray.append(object["card"].stringValue)
                                        }
                                        if let gameDataList = response["game_data"].array, gameDataList.count > 0 {
                                            gameDataList.forEach { gameData in
                                                self.winnerId = gameData["winning"].intValue
                                            }
                                        }
                                        cardDistributedTimer()
                                    }
                                }
                            }
                        }
                    } else if let message = apiResponse?.message {
                        Toast.makeToast(message)
                    }
                    break
                case .failure(_):
//                    Toast.makeToast(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    private func restartGame() {
        canbet = true
        placeGameAmount = 0
        self.betCollectionView.reloadData()
        self.setSetRulesValue()
        isCardsDisribute = false
        self.pleaseWaitView.isHidden = true
        self.battingLabel.text = "0.0s"
        self.jackpotWinBoxImage.image = UIImage(named: "ic_jackpot_cardsbg")
        self.cardImages.forEach { image in
            image.image = UIImage(named: "card_bg")
        }
    }
    
    private func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
}

extension Jackpot3PattiViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.betCollectionView {
            return coinsDataList.count
        }
        if collectionView == self.resultCollectionView {
            return lastWinList.count
        }
        if collectionView == self.componectCollectionView {
            return rulesModelList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.betCollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DNTCollectionViewCell.betCell, for: indexPath) as? DNTCollectionViewCell {
            cell.configure(coinsDataList[indexPath.row], highLightet: self.placeGameAmount)
            return cell
        }
        if collectionView == self.resultCollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DNTCollectionViewCell.lastBetCell, for: indexPath) as? DNTCollectionViewCell {
            cell.configureLast(lastWinList[indexPath.row], gameType: .jackpot_teen_patti)
            return cell
        }
        if collectionView == self.componectCollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JackpotCollectionViewCell.identifier, for: indexPath) as? JackpotCollectionViewCell {
            if cell.animAmountLbl != nil {
                var animatedAmount = rulesModelList[indexPath.row].added_amount
                if let prevAmt = Int(cell.addedAmtLbl.text!), prevAmt > 0, rulesModelList[indexPath.row].added_amount - prevAmt != 0 {
                    animatedAmount = rulesModelList[indexPath.row].added_amount - prevAmt
                }
                cell.animAmountLbl.text = "+\(animatedAmount)"
                if cell.animationView != nil {
                    cell.animationView.isHidden = true
                    if animatedAmount > 0 && winnerId == -1 {
//                        makeAnimation(cell.animationView)
                        cell.animBottomConstraint.constant = 150
                        cell.animationView.isHidden = false
//                        cell.animationView.frame = CGRect(x: 0.0, y: 128.0 - 40.0, width: cell.animationView.frame.size.width, height: 30.0)
                        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
//                            cell.animationView.frame = CGRect(x: 0.0, y: 0.0, width: cell.animationView.frame.size.width, height: 30.0)
//                            cell.animBottomConstraint.constant = 150.0
                            cell.layoutIfNeeded()
                        }) { (finished) in
                            cell.animationView.isHidden = true
                            cell.animBottomConstraint.constant = 20.0
                            cell.addedAmtLbl.text = "\(self.rulesModelList[indexPath.row].added_amount)"
                        }
                    }
                }
            }
            cell.configure(rulesModelList[indexPath.row])
            if cell.heightConstraint != nil {
                cell.heightConstraint.constant = 128.0
            }
            if cell.withConstraint != nil {
                cell.withConstraint.constant = (collectionView.frame.size.width - 25.0) / 6.0
            }
            if cell.winnerImage != nil {
                cell.winnerImage.image = UIImage(named: "ic_jackpot_rule_bg")
                if winnerId >= 0, self.jackpot_win_label[winnerId] == self.rulesModelList[indexPath.row].rule_type {
                    cell.winnerImage.image = UIImage.gif(name: "ic_jackpot_rule_bg_selected")
                }
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    private func makeAnimation(_ animView: UIView) {
        animView.isHidden = false
       // animView.frame = CGRect(x: 0.0, y: -50.0, width: animView.frame.size.width, height: 30.0)
//        UIView.animate(withDuration: 1.0, delay: 0, options: [.curveEaseInOut], animations: {
//            animView.frame = CGRect(x: 0.0, y: -50.0, width: animView.frame.size.width, height: 30.0)
//        }) { (finished) in
//            animView.isHidden = true
//            animView.frame = CGRect(x: 0.0, y: -50.0, width: animView.frame.size.width, height: 30.0)
//        }
    }
}

extension Jackpot3PattiViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.componectCollectionView {
            return CGSize(width: (collectionView.frame.size.width - 25.0) / 6.0, height: 128.0)
        }
        if collectionView == self.betCollectionView {
            return CGSize(width: 60.0, height: 60.0)
        }
        return CGSize(width: 80.0, height: 30.0)
    }
}

extension Jackpot3PattiViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.betCollectionView == collectionView  {
            self.placeGameAmount = coinsDataList[indexPath.row]
            self.betCollectionView.reloadData()
        } else if collectionView == self.componectCollectionView {
            if let cell = collectionView.cellForItem(at: indexPath) as? JackpotCollectionViewCell {
                let tempFrame = cell.frame
                cell.frame = CGRect(x: tempFrame.origin.x + 5, y: tempFrame.origin.y + 5, width: tempFrame.size.width, height: tempFrame.size.height)
                UIView.transition(with: cell, duration: 0.5) {
                    cell.frame = tempFrame
                } completion: { isAaa in
                    cell.frame = tempFrame
                }
            }
            if placeGameAmount <= 0 {
                Toast.makeToast("First Select Bet amount")
                return
            }
            self.placeBet(indexPath.row)
        }
    }
}


// MARK: Alert Prompt Delegate
extension Jackpot3PattiViewController: PromptViewDelegate {
    func didActionOnPromptButton(_ tag: Int) {
        switch tag {
        case 1: // Leave Table
            self.dismiss(animated: true)
            break
        default:
            break
        }
    }
}
