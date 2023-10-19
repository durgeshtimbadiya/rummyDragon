//
//  RedVsBlackViewController.swift
//  Lets Card
//
//  Created by Durgesh on 10/05/23.
//

import UIKit

class RedVsBlackViewController: UIViewController {

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
    
    @IBOutlet weak var leftPlayerCollectionView: UICollectionView!
    @IBOutlet weak var rightPlayerCollectionView: UICollectionView!
    
    @IBOutlet weak var pleaseWaitView: UIView!
    
    @IBOutlet var redCardImages: [UIImageView]!
    @IBOutlet var blackCardImages: [UIImageView]!
    
    @IBOutlet weak var redWinImage: UIImageView!
    @IBOutlet weak var blackWinImage: UIImageView!
    
    @IBOutlet weak var gameMainView: UIView!
    @IBOutlet weak var gameMainStackView: UIStackView!
    @IBOutlet weak var gameSubView1: UIStackView!
    @IBOutlet weak var gameSubView2: UIStackView!
    
    @IBOutlet var gameComponentsViews: [UIView]!
    @IBOutlet var addedAmtLabels: [UILabel]!
    @IBOutlet var selectAmtLabels: [UILabel]!
    @IBOutlet var winnerImageViews: [UIImageView]!

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
    private var botUsers = [HeadTailBotModel]()
    private var isBotPlayerSet = false
    
    private var timerStatus = Timer()
    private var gameStartTimer = Timer()
    private var cardDistributeTimer = Timer()
    private var cardDistributeCount = 0
    private var winningRule = -1

    private var set_amount = 0
    private var pure_sequence_amount = 0
    private var sequence_amount = 0
    private var color_amount = 0
    private var pair_amount = 0
    private var black_amount = 0
    private var red_amount = 0
        
    let RED = "RED"
    let BLACK = "BLACK"
    let SET = "SET"
    let PURE_SEQ = "PURE SEQ"
    let SEQ = "SEQ"
    let COLOR = "COLOR"
    let PAIR = "PAIR"
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        betEndImage.isHidden = true
        redWinImage.isHidden = true
        blackWinImage.isHidden = true
        self.winnerImageViews.forEach { imageV in
//            imageV.image = UIImage.gif(name: "ic_jackpot_rule_bg_selected")
            imageV.isHidden = true
        }
        betCollectionView.reloadData()
        startGameStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    @IBAction func tapOnPlaceBet(_ sender: UIButton) {
        let tempFrame = self.gameComponentsViews[sender.tag].frame
        self.gameComponentsViews[sender.tag].frame = CGRect(x: tempFrame.origin.x + 5, y: tempFrame.origin.y + 5, width: tempFrame.size.width, height: tempFrame.size.height)
        UIView.transition(with: self.gameComponentsViews[sender.tag], duration: 0.5) {
            self.gameComponentsViews[sender.tag].frame = tempFrame
        } completion: { isAaa in
            self.gameComponentsViews[sender.tag].frame = tempFrame
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
        makeDummyAnimation()
        self.battingLabel.text = "\(timeRemaining).0s"
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
            self.setWinningView(winnerId, winning_rule1: winningRule)
            self.delay(3.0) {
                // Cancel game timer
//                self.walletBalLbl.text = walletAmt
                self.gameStartTimer.invalidate()
                self.cardDistributeTimer.invalidate()
                for vv in self.gameMainView.subviews {
                    if vv.tag == 9999 {
                        vv.removeFromSuperview()
                    }
                }
                self.isCardsDisribute = false
            }
            
            return
        }
        if allCardsArray.count > 2 {
            let cardPostion = cardDistributeCount % 3
            if cardDistributeCount > 2 {
                self.blackCardImages[cardPostion].image = UIImage(named: allCardsArray[cardDistributeCount].lowercased())
            } else {
                self.redCardImages[cardPostion].image = UIImage(named: allCardsArray[cardDistributeCount].lowercased())
            }
        }
        cardDistributeCount += 1
    }
    
    private func makeDummyAnimation() {
        for i in 0..<self.gameComponentsViews.count {
            var imageNameArray = [10, 50, 100, 1000, 5000, 10, 50, 100]

            let stackViewX = i > 1 ? self.gameSubView2.frame.origin.x : self.gameSubView1.frame.origin.x
            let stackViewY = i > 1 ? self.gameSubView2.frame.origin.y : self.gameSubView1.frame.origin.y
            
            let originX = (self.gameMainStackView.frame.origin.x + stackViewX + self.gameComponentsViews[i].frame.origin.x)
            let originY = (self.gameMainStackView.frame.origin.y + stackViewY + self.gameComponentsViews[i].frame.origin.y) + 35.0
            let xPlus = self.gameComponentsViews[i].frame.width / 5.0
            
            let originalAniRect = CGRect(x: CGFloat.random(in: originX...originX + xPlus), y: CGFloat.random(in: originY...originY + 10), width: 20.0, height: 20.0)
            let originalAniRect1 = CGRect(x: CGFloat.random(in: originX + xPlus...originX + (xPlus * 2)), y: CGFloat.random(in: originY...originY + 10), width: 20.0, height: 20.0)
            let originalAniRect2 = CGRect(x: CGFloat.random(in: originX + (xPlus * 2)...originX + (xPlus * 3)), y: CGFloat.random(in: originY...originY + 10), width: 20.0, height: 20.0)
            let originalAniRect3 = CGRect(x: CGFloat.random(in: originX + (xPlus * 3)...originX + (xPlus * 4)), y: CGFloat.random(in: originY...originY + 10), width: 20.0, height: 20.0)
            let originalAniRect4 = CGRect(x: CGFloat.random(in: originX + (xPlus * 4)...originX + (xPlus * 4)), y: CGFloat.random(in: originY...originY + 10), width: 20.0, height: 20.0)
            
            var imageTag = 10
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                imageTag = rndNumber
            }
            let imageView = UIImageView(image: UIImage(named: "ic_coin_\(imageTag)_dt")) // 10, 50, 100, 1000, 5000
            imageView.frame = CGRect(x: self.otherUserView.frame.origin.x + 20.0, y: self.otherUserView.frame.origin.y + 20.0, width: 20.0, height: 20.0)
            imageView.isUserInteractionEnabled = false
            imageView.tag = 9999
            self.gameMainView.addSubview(imageView)
            
            imageTag = 10
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                imageTag = rndNumber
            }
            let imageView1 = UIImageView(image: UIImage(named: "ic_coin_\(imageTag)_dt")) // 10, 50, 100, 1000, 5000
            imageView1.frame = CGRect(x: self.otherUserView.frame.origin.x + 20.0, y: self.otherUserView.frame.origin.y + 20.0, width: 20.0, height: 20.0)
            imageView1.isUserInteractionEnabled = false
            imageView1.tag = 9999
            self.gameMainView.addSubview(imageView1)
            
            imageTag = 10
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                imageTag = rndNumber
            }
            let imageView2 = UIImageView(image: UIImage(named: "ic_coin_\(imageTag)_dt")) // 10, 50, 100, 1000, 5000
            imageView2.frame = CGRect(x: self.otherUserView.frame.origin.x + 20.0, y: self.otherUserView.frame.origin.y + 20.0, width: 20.0, height: 20.0)
            imageView2.isUserInteractionEnabled = false
            imageView2.tag = 9999
            self.gameMainView.addSubview(imageView2)
            
            imageTag = 10
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                imageTag = rndNumber
            }
            let imageView3 = UIImageView(image: UIImage(named: "ic_coin_\(imageTag)_dt")) // 10, 50, 100, 1000, 5000
            imageView3.frame = CGRect(x: self.otherUserView.frame.origin.x + 20.0, y: self.otherUserView.frame.origin.y + 20.0, width: 20.0, height: 20.0)
            imageView3.isUserInteractionEnabled = false
            imageView3.tag = 9999
            self.gameMainView.addSubview(imageView3)
            
            imageTag = 10
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                imageTag = rndNumber
            }
            let imageView4 = UIImageView(image: UIImage(named: "ic_coin_\(imageTag)_dt")) // 10, 50, 100, 1000, 5000
            imageView4.frame = CGRect(x: self.otherUserView.frame.origin.x + 20.0, y: self.otherUserView.frame.origin.y + 20.0, width: 20.0, height: 20.0)
            imageView4.isUserInteractionEnabled = false
            imageView4.tag = 9999
            self.gameMainView.addSubview(imageView4)
            
            UIView.animate(withDuration: 1) {
                imageView.frame = originalAniRect
                imageView1.frame = originalAniRect1
                imageView2.frame = originalAniRect2
                imageView3.frame = originalAniRect3
                imageView4.frame = originalAniRect4
            } completion: { s in }
        }
    }
    
    @objc private func pleaseWaitAnimation() {
        self.winnerImageViews.forEach { winImage in
            winImage.alpha = 1.0
            UIView.animate(withDuration: 2.0) {
                winImage.alpha = 1.0
            } completion: { st in
                self.pleaseWaitAnimation()
            }
        }
    }
    
    private func setWinningView(_ winning: Int, winning_rule1: Int) {
        // winning - 1 - Red
        // winning - 2 - Black
        
        if winning == 1 {
            self.redWinImage.isHidden = false
        } else if winning == 2 {
            self.blackWinImage.isHidden = false
        }
        
//        // winningRule
//        self.winnerImageViews[winning_rule1].isHidden = false
//        if winnerId > 0 {
//            self.winnerImageViews[winning - 1].isHidden = false
//        }
//        let delayTime = 0.1
//        var count = 0
//        _ = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: true){ t in
//            count += 1
//            if count >= 10 {
//                self.winnerImageViews.forEach { imageV in
//                    imageV.isHidden = true
//                }
//                t.invalidate()
//            }
//        }
    }
}

extension RedVsBlackViewController {
    private func placeBet(_ tagIndex: Int) {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: ColourPredBetRequest(game_id: self.game_id, bet:  "\(tagIndex + 1)", amount: "\(self.placeGameAmount)"), feed: .RedBl_place_bet, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse?.data, apiResponse?.code == 200 {
                        self.walletBalLbl.text = response["wallet"].stringValue
                        if let selectAmt = Int(self.selectAmtLabels[tagIndex].text ?? "0") {
                            self.selectAmtLabels[tagIndex].text = "\(selectAmt + self.placeGameAmount)"
                        }
                        
                    } else if let message = apiResponse?.message, !message.isEmpty {
                        Toast.makeToast("First select bet amount")
                    }
                    self.gameStatus()
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
            APIClient.shared.post(parameters: GameRedVsBlkRequest(total_bet_red: "\(red_amount)", total_bet_black: "\(black_amount)", total_bet_pair: "\(pair_amount)", total_bet_color: "\(color_amount)", total_bet_sequence: "\(sequence_amount)", total_bet_pure_sequence: "\(pure_sequence_amount)", total_bet_set: "\(set_amount)"), feed: .RedBl_get_active_game, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let responseCode = apiResponse?.code, responseCode == 407 {
                        self.dismiss(animated: true)
                    } else if let response = apiResponse?.data {
//                        print("Response: \(response)")
                        self.addedAmtLabels.forEach { lbl in
                            lbl.text = ""
                        }
                        var gameStatus = ""
                        winnerId = -1
                        lastWinList = [LastWinningsModel]()
                        if apiResponse?.code == 200 && !isBotPlayerSet {
                            botUsers = [HeadTailBotModel]()
                            if let botdUsers = response["bot_user"].array {
                                botdUsers.forEach { object in
                                    botUsers.append(HeadTailBotModel(object))
                                }
                                self.isBotPlayerSet = true
                                self.leftPlayerCollectionView.reloadData()
                                self.rightPlayerCollectionView.reloadData()
                            }
                        }
                       
                        
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
                            
                            if timeRemaining > 0 {
                                // Distribute coins animation
                                //Start bet animation
                                isBetStarted = true
                                self.setGameTimer()
                            } else {
                                
                            }
                        } else if gameStatus == "0" && isGameBegning {
                            red_amount = 0
                            black_amount = 0
                            pair_amount = 0
                            color_amount = 0
                            sequence_amount = 0
                            pure_sequence_amount = 0
                            set_amount = 0
                            
                            self.gameComponentsViews.forEach { gameView in
                                switch gameView.tag {
                                case 0:
                                    //Red
                                    if let amount = response["red_amount"].int {
                                        red_amount = amount
                                    } else if let amount = response["red_amount"].string {
                                        red_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(red_amount)"
                                    break
                                case 1:
                                    //Black
                                    if let amount = response["black_amount"].int {
                                        black_amount = amount
                                    } else if let amount = response["black_amount"].string {
                                        black_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(black_amount)"
                                    break
                                case 2:
                                    //Pair
                                    if let amount = response["pair_amount"].int {
                                        pair_amount = amount
                                    } else if let amount = response["pair_amount"].string {
                                        pair_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(pair_amount)"
                                    break
                                case 3:
                                    //Color
                                    if let amount = response["color_amount"].int {
                                        color_amount = amount
                                    } else if let amount = response["color_amount"].string {
                                        color_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(color_amount)"
                                    break
                                case 4:
                                    //Seq
                                    if let amount = response["sequence_amount"].int {
                                        sequence_amount = amount
                                    } else if let amount = response["sequence_amount"].string {
                                        sequence_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(sequence_amount)"
                                    break
                                case 5:
                                    //Pure Seq
                                    if let amount = response["pure_sequence_amount"].int {
                                        pure_sequence_amount = amount
                                    } else if let amount = response["pure_sequence_amount"].string {
                                        pure_sequence_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(pure_sequence_amount)"
                                    break
                                case 6:
                                    //Set
                                    if let amount = response["set_amount"].int {
                                        set_amount = amount
                                    } else if let amount = response["set_amount"].string {
                                        set_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(set_amount)"
                                    break
                                default:
                                    break
                                }
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
//                            self.betEndImage.isHidden = false
//                            self.betEndImage.frame.size.height = 0.0
//                            UIView.transition(with: self.betEndImage, duration: 1, options: .curveEaseInOut) {
//                                self.betEndImage.frame.size.height = 33.0
                            self.isCardsDisribute = true
                            self.delay(1) { [self] in
//                                self.betEndImage.isHidden = true
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
        self.betCollectionView.reloadData()
        selectAmtLabels.forEach { lbl in
            lbl.text = "0"
        }
        isCardsDisribute = false
        redWinImage.isHidden = true
        cardDistributeCount = 0
        blackWinImage.isHidden = true
        self.pleaseWaitView.isHidden = true

        self.winnerImageViews.forEach { imageV in
            imageV.isHidden = true
        }
        self.redCardImages.forEach { imageV in
            imageV.image = UIImage(named: "card_bg")
        }
        self.blackCardImages.forEach { imageV in
            imageV.image = UIImage(named: "card_bg")
        }
        for vv in self.gameMainView.subviews {
            if vv.tag == 9999 {
                vv.removeFromSuperview()
            }
        }
    }
    
    private func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
}

extension RedVsBlackViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.betCollectionView {
            return coinsDataList.count
        }
        if collectionView == self.resultCollectionView {
            return lastWinList.count
        }
        if collectionView == self.leftPlayerCollectionView {
            return self.botUsers.count > 3 ? 3 : self.botUsers.count
        }
        if collectionView == self.rightPlayerCollectionView {
            return self.botUsers.count - 3 > 0 ? self.botUsers.count - 3 : 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.betCollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DNTCollectionViewCell.betCell, for: indexPath) as? DNTCollectionViewCell {
            cell.configure(coinsDataList[indexPath.row], highLightet: self.placeGameAmount)
            return cell
        }
        if collectionView == self.resultCollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DNTCollectionViewCell.lastBetCell, for: indexPath) as? DNTCollectionViewCell {
            cell.configureLast(lastWinList[indexPath.row], gameType: .red_vs_black)
            return cell
        }
        if collectionView == self.leftPlayerCollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DNTCollectionViewCell.playerCell, for: indexPath) as? DNTCollectionViewCell {
            cell.configureBotUsers(self.botUsers[indexPath.row])
            return cell
        }
        if collectionView == self.rightPlayerCollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DNTCollectionViewCell.playerCell, for: indexPath) as? DNTCollectionViewCell {
            cell.configureBotUsers(self.botUsers[indexPath.row + 3])
            return cell
        }
        return UICollectionViewCell()
    }
}

extension RedVsBlackViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 25.0, height: 25.0)
//    }
}

extension RedVsBlackViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.betCollectionView == collectionView  {
            self.placeGameAmount = coinsDataList[indexPath.row]
            self.betCollectionView.reloadData()
        }
    }
}


// MARK: Alert Prompt Delegate
extension RedVsBlackViewController: PromptViewDelegate {
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
