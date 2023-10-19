//
//  RouletteViewController.swift
//  Lets Card
//
//  Created by Durgesh on 05/06/23.
//

import UIKit

class RouletteViewController: UIViewController {

    @IBOutlet weak var profileBottomView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var walletBalLbl: UILabel!
    @IBOutlet weak var betCollectionView: UICollectionView!
    
    @IBOutlet weak var resultCollectionView: UICollectionView!

    @IBOutlet weak var battingLabel: UILabel!
    @IBOutlet weak var otherUserView: UIStackView!
    @IBOutlet weak var otherUserLabel: UILabel!
    
    @IBOutlet weak var betEndImage: UIImageView!
    @IBOutlet weak var wheelImage: UIImageView!

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var pleaseWaitView: UILabel!
    @IBOutlet var gameComponentView: [UIView]!

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
    private var cardDistributeCount = 0
    private var winningRule = -1
    private var tempButtonTitle = ""
    
    private var evenColor = UIColor.black
    private var oddColor = UIColor(red: 196.0 / 255.0, green: 41.0 / 255.0, blue: 27.0, alpha: 1.0)
    private var highlightColor = UIColor(red: 55.0 / 255.0, green: 0.0, blue: 179.0 / 255.0, alpha: 1.0)
    
    private var wheelResultDegree = [12.57, 14.95, 11.55, 12.9, 11.9, 15.62, 10.9, 13.59, 16.13, 14.27, 15.78, 16.48, 13.25, 10.55, 14.6, 12.23, 15.29, 11.2, 13.93, 12.05, 14.77, 11.72, 14.1, 15.96, 15.46, 11.38, 12.73, 10.7, 13.41, 13.75, 16.3, 14.43, 12.4, 15.11, 11.05, 13.07, 16.63]
    
    private var red_amount = 0
    private var black_amount = 0
    private var pair_amount = 0
    private var color_amount = 0
    private var sequence_amount = 0
    private var pure_sequence_amount = 0
    private var set_amount = 0
    
    private let RED = "RED";
    private let BLACK = "BLACK";
    private let SET = "SET";
    private let PURE_SEQ = "PURE SEQ";
    private let SEQ = "SEQ";
    private let COLOR = "COLOR";
    private let PAIR = "PAIR";

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        betEndImage.isHidden = true
        betCollectionView.reloadData()
        startGameStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setCarRotationAnimation()
//        let TOTAL_CELLS_PER_ROW = 36
//        for i in 1..<=TOTAL_CELLS_PER_ROW {
//            var ruleValue = Int((i % 12) * 3) - Int(floor(Double(i) / 12.0))
//            if ruleValue < 0 {
//                ruleValue = (TOTAL_CELLS_PER_ROW + 1 + ruleValue)
//            }
//            print(ruleValue)
//        }
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
//        self.winnerId = 0
//        delay(0.1) {
//            self.wheelImage.rotateWithAnimation(angle: self.wheelResultDegree[self.winnerId])
//            self.delay(2) {
//                self.wheelImage.transform = CGAffineTransform.identity
//                self.winnerId += 1
//                self.delay(0.1) {
//                    self.wheelImage.rotateWithAnimation(angle: self.wheelResultDegree[self.winnerId])
//                }
//            }
//        }
    }

    @IBAction func tapOnBackButton(_ sender: UIButton) {
        PromptVManager.present(self, titleString: "CONFIRMATOIN", messageString: "Are you sure, you want to Leave ?", viewTag: 1)
    }
    
    @IBAction func tapOnAddChips(_ sender: UIButton) {
       
    }
    
    @IBAction func tapOnPlaceBet(_ sender: UIButton) {
        if sender.tag == 99 {
            return
        }
//        var placeBet = -1
        if let btnTitle = sender.titleLabel?.text, let isInt = Int(btnTitle), isInt != 0 {
            if !self.tempButtonTitle.isEmpty {
                return
            }
            self.tempButtonTitle = sender.titleLabel?.text ?? ""
            sender.setImage(UIImage(named: "ic_dt_chips_small"), for: .normal)
            sender.setTitle("", for: .normal)
            self.delay(1.0) {
                sender.setTitle(self.tempButtonTitle, for: .normal)
                sender.setImage(nil, for: .normal)
                self.tempButtonTitle = ""
            }
//            placeBet = isInt
        } else {
            let tempFrame = sender.frame
            sender.frame = CGRect(x: tempFrame.origin.x + 10, y: tempFrame.origin.y + 10, width: tempFrame.size.width, height: tempFrame.size.height)
            UIView.transition(with: sender, duration: 0.5) {
                sender.frame = tempFrame
            } completion: { isAaa in
                sender.frame = tempFrame
            }
//            placeBet = sender.tag
        }
        if placeGameAmount <= 0 {
            Toast.makeToast("First Select Bet amount")
            return
        }
        
        self.placeBet(sender.tag)
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
            self.battingLabel.text = "0.0s"
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
        timeRemainingCard = allCardsArray.count
        if cardDistributeTimer.isValid {
            cardDistributeTimer.invalidate()
        }
        cardDistributeTimer = Timer(timeInterval: 1, target: self, selector: #selector(self.updateCardTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.cardDistributeTimer, forMode: .default)
        cardDistributeTimer.fire()
    }
    
    @objc private func updateCardTimer() {
        timeRemainingCard -= 1
        if timeRemainingCard < 0 {
            if cardDistributeTimer.isValid {
                cardDistributeTimer.invalidate()
            }
//            self.setWinningView(winnerId, winning_rule1: winningRule)
            self.delay(3.0) {
                // Cancel game timer
                self.gameStartTimer.invalidate()
                self.cardDistributeTimer.invalidate()
                self.makeWheelSpin()
            }
            
            return
        }
        if allCardsArray.count > 2 {
//            let cardPostion = cardDistributeCount % 3
            if cardDistributeCount > 2 {
//                self.blackCardImages[cardPostion].image = UIImage(named: allCardsArray[cardDistributeCount].lowercased())
            } else {
//                self.redCardImages[cardPostion].image = UIImage(named: allCardsArray[cardDistributeCount].lowercased())
            }
        }
        cardDistributeCount += 1
    }
    
    private func makeWheelSpin() {
        self.wheelImage.rotateWithAnimation(angle: self.wheelResultDegree[self.winnerId])
        self.pleaseWaitView.isHidden = false
        self.delay(1.0) {
            switch self.winnerId {
            case 0:
                self.resultLabel.text = "\(self.winnerId) GREEN"
                break
            case 15, 4, 2, 17, 6, 13, 11, 8, 10, 24, 33, 20, 31, 22, 29, 28, 35, 26:
                self.resultLabel.text = "\(self.winnerId) BLACK"
                break
            default:
                self.resultLabel.text = "\(self.winnerId) RED"
                break
            }
            self.resultLabel.frame.size.height = 0.0
            self.resultLabel.isHidden = false
            UIView.transition(with: self.betEndImage, duration: 1) {
                self.resultLabel.frame.size.height = 34.0
            } completion: { isA in
                self.delay(1) {
                    self.setWinner()
                }
            }
        }
        self.delay(3.0) {
            self.wheelImage.transform = CGAffineTransform.identity
        }
    }
    
    private func setWinner() {
        self.gameComponentView[self.winnerId].backgroundColor = self.winnerId % 2 == 0 ? evenColor : oddColor
        UIView.transition(with: self.betEndImage, duration: 0.5) {
            self.gameComponentView[self.winnerId].backgroundColor = self.highlightColor
        } completion: { st in
            self.gameComponentView[self.winnerId].backgroundColor = self.highlightColor
            UIView.transition(with: self.betEndImage, duration: 0.5) {
                self.gameComponentView[self.winnerId].backgroundColor = self.winnerId % 2 == 0 ? self.evenColor : self.oddColor
            } completion: { st in
                self.gameComponentView[self.winnerId].backgroundColor = self.winnerId % 2 == 0 ? self.evenColor : self.oddColor
                UIView.transition(with: self.betEndImage, duration: 1) {
                    self.gameComponentView[self.winnerId].backgroundColor = self.highlightColor
                } completion: { st in
                    self.gameComponentView[self.winnerId].backgroundColor = self.highlightColor
                    UIView.transition(with: self.betEndImage, duration: 1) {
                        self.gameComponentView[self.winnerId].backgroundColor = self.winnerId % 2 == 0 ? self.evenColor : self.oddColor
                    } completion: { st in
                        self.gameComponentView[self.winnerId].backgroundColor = self.winnerId % 2 == 0 ? self.evenColor : self.oddColor
                        self.isCardsDisribute = false
                    }
                }
            }
        }
    }
}


extension RouletteViewController {
    private func placeBet(_ tagIndex: Int) {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: ColourPredBetRequest(game_id: self.game_id, bet:  "\(tagIndex)", amount: "\(self.placeGameAmount)"), feed: .Roullet_place_bet, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse?.data, apiResponse?.code == 200 {
                        Toast.makeToast("Bet has been added successfully!")
                        self.walletBalLbl.text = response["wallet"].stringValue
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
            APIClient.shared.post(parameters: GameRouletteRequest(total_bet_red: "\(red_amount)", total_bet_black: "\(black_amount)", total_bet_pair: "\(pair_amount)", total_bet_color: "\(color_amount)", total_bet_sequence: "\(sequence_amount)", total_bet_pure_sequence: "\(pure_sequence_amount)", total_bet_set: "\(set_amount)"), feed: .Roullet_get_active_game, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let responseCode = apiResponse?.code, responseCode == 407 {
                        self.dismiss(animated: true)
                    } else if let response = apiResponse?.data {
//                        print("Response: \(response)")
//                        self.addedAmtLabels.forEach { lbl in
//                            lbl.text = ""
//                        }
                        var gameStatus = ""
                        winnerId = -1
                        lastWinList = [LastWinningsModel]()
                        
                        if let online = response["online"].int {
                            otherUserLabel.text = "\(online)"
                        } else if let online = response["online"].string {
                            otherUserLabel.text = online
                        }
//                        var walletAmt = ""
                        if let profileArrayData = response["profile"].array, profileArrayData.count > 0 {
                            let profileDataModel = ProfileData(profileArrayData[0])
                            self.usernameLbl.text = profileDataModel.name
                            self.profileImage.sd_setImage(with: URL(string: profileDataModel.profile_pic), placeholderImage: UIImage(named: "avatar"), context: [:])
                            self.walletBalLbl.text = profileDataModel.wallet.cleanValue2
//                            walletAmt = profileDataModel.wallet.cleanValue2
                        }
//                        var addedDate = ""
                        if let gameDataList = response["game_data"].array, gameDataList.count > 0 {
                            gameDataList.forEach { gameData in
                                if let online = gameData["status"].int {
                                    gameStatus = "\(online)"
                                } else if let online = gameData["status"].string {
                                    gameStatus = online
                                }
                                
                                if let win = gameData["winning"].int {
                                    winnerId = win
                                } else if let win = gameData["winning"].string {
                                    winnerId = Int(win) ?? -1
                                }
                                
                                if let winr = gameData["winning_rule"].int {
                                    winningRule = winr
                                } else if let winr = gameData["winning_rule"].string {
                                    winningRule = Int(winr) ?? -1
                                }

                                if let timeRemaining1 = gameData["time_remaining"].int {
                                    timeRemaining = timeRemaining1
                                } else if let timeRemaining1 = gameData["time_remaining"].string {
                                    timeRemaining = Int(timeRemaining1) ?? 0
                                }
                                if let lastWinnings = response["last_winning"].array, lastWinnings.count > 0 {
                                    lastWinnings.forEach { object in
                                        lastWinList.append(LastWinningsModel(object))
                                    }
                                    self.resultCollectionView.reloadData()
                                }
//                                addedDate = gameData["added_date"].stringValue
                                game_id = gameData["id"].stringValue
                            }
                        }
                        
                        // New game started here
                        if gameStatus == "0" && !isGameBegning {
                            restartGame()
                            isGameBegning = true
                            self.betEndImage.image = UIImage(named: "iv_bet_begin")
                            self.betEndImage.frame.size.height = 0.0
                            self.betEndImage.isHidden = false
                            UIView.transition(with: self.betEndImage, duration: 1) {
                                self.betEndImage.frame.size.height = 33.0
                            } completion: { isA in
                                self.delay(1) {
                                    self.betEndImage.isHidden = true
                                }
                            }
                            isBetStarted = true
                            if timeRemaining > 0 {
                                // Distribute coins animation
                                //Start bet animation
                                isBetStarted = true
                                self.setGameTimer()
                            }
                        } else if gameStatus == "0" && isGameBegning {
                            red_amount = 0
                            black_amount = 0
                            pair_amount = 0
                            color_amount = 0
                            sequence_amount = 0
                            pure_sequence_amount = 0
                            set_amount = 0
                            if let amount = response["red_amount"].int {
                                red_amount = amount
                            } else if let amount = response["red_amount"].string {
                                red_amount = Int(amount) ?? 0
                            }
                            if let amount = response["black_amount"].int {
                                black_amount = amount
                            } else if let amount = response["black_amount"].string {
                                black_amount = Int(amount) ?? 0
                            }
                            if let amount = response["pair_amount"].int {
                                pair_amount = amount
                            } else if let amount = response["pair_amount"].string {
                                pair_amount = Int(amount) ?? 0
                            }
                            if let amount = response["color_amount"].int {
                                color_amount = amount
                            } else if let amount = response["color_amount"].string {
                                color_amount = Int(amount) ?? 0
                            }
                            if let amount = response["sequence_amount"].int {
                                sequence_amount = amount
                            } else if let amount = response["sequence_amount"].string {
                                sequence_amount = Int(amount) ?? 0
                            }
                            if let amount = response["pure_sequence_amount"].int {
                                pure_sequence_amount = amount
                            } else if let amount = response["pure_sequence_amount"].string {
                                pure_sequence_amount = Int(amount) ?? 0
                            }
                            if let amount = response["set_amount"].int {
                                set_amount = amount
                            } else if let amount = response["set_amount"].string {
                                set_amount = Int(amount) ?? 0
                            }
                        }
//                        self.pleaseWaitView.isHidden = true
                        if gameStatus == "1" && !isGameBegning {
                            self.pleaseWaitView.isHidden = false
                        }
//                        if gameStatus == "1" {
//                            self.pleaseWaitView.isHidden = false
//                        }
                        //iv_bet_begin, iv_bet_stops
                        if gameStatus == "1" && isGameBegning {
                            isGameBegning = false
                            self.isCardsDisribute = true
                            self.betEndImage.isHidden = false
                            self.betEndImage.frame.size.height = 0.0
                            self.betEndImage.image = UIImage(named: "iv_bet_stops")
                            UIView.transition(with: self.betEndImage, duration: 1) {
                                self.betEndImage.frame.size.height = 33.0
                            } completion: { isA in
                                self.delay(1) {
                                    self.betEndImage.isHidden = true
                                }
                            }
                            self.delay(1) { [self] in
//                                self.betEndImage.isHidden = true
                                gameStartTimer.invalidate()
                                allCardsArray = [String]()
                                if let gameCards = response["game_cards"].array, gameCards.count > 0 {
                                    gameCards.forEach { object in
                                        allCardsArray.append(object["card"].stringValue)
                                    }
                                    cardDistributedTimer()
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
        self.resultLabel.text = ""
        self.betCollectionView.reloadData()
//        selectAmtLabels.forEach { lbl in
//            lbl.text = "0"
//        }
        isCardsDisribute = false
//        redWinImage.isHidden = true
        cardDistributeCount = 0
//        blackWinImage.isHidden = true
        self.pleaseWaitView.isHidden = true

//        self.winnerImageViews.forEach { imageV in
//            imageV.isHidden = true
//        }
//        self.redCardImages.forEach { imageV in
//            imageV.image = UIImage(named: "card_bg")
//        }
//        self.blackCardImages.forEach { imageV in
//            imageV.image = UIImage(named: "card_bg")
//        }
//        for vv in self.gameMainView.subviews {
//            if vv.tag == 9999 {
//                vv.removeFromSuperview()
//            }
//        }
    }
    
    private func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
}

extension RouletteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.betCollectionView {
            return coinsDataList.count
        }
        if collectionView == self.resultCollectionView {
            return lastWinList.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.betCollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DNTCollectionViewCell.betCell, for: indexPath) as? DNTCollectionViewCell {
            cell.configure(coinsDataList[indexPath.row], highLightet: self.placeGameAmount)
            return cell
        }
        if collectionView == self.resultCollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DNTCollectionViewCell.lastBetCell, for: indexPath) as? DNTCollectionViewCell {
            cell.configureLast(lastWinList[indexPath.row], gameType: .roulette)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension RouletteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.betCollectionView == collectionView  {
            self.placeGameAmount = coinsDataList[indexPath.row]
            self.betCollectionView.reloadData()
        }
    }
}


// MARK: Alert Prompt Delegate
extension RouletteViewController: PromptViewDelegate {
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
