//
//  BaccaratViewController.swift
//  Lets Card
//
//  Created by Durgesh on 22/05/23.
//

import UIKit

class BaccaratViewController: UIViewController {
    
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
    
    @IBOutlet weak var pleaseWaitView: UIView!
    
    @IBOutlet var pCardImages: [UIImageView]!
    @IBOutlet var bCardImages: [UIImageView]!
    
    @IBOutlet weak var gameMainView: UIView!
    @IBOutlet weak var gameMainSubView: UIView!
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
    private var isBotPlayerSet = false
    
    private var timerStatus = Timer()
    private var gameStartTimer = Timer()
    private var cardDistributeTimer = Timer()
    private var cardDistributeCount = 0
    private var winningRule = -1
    
    private var tie_amount = 0
    private var player_amount = 0
    private var banker_amount = 0
    private var banker_pair_amount = 0
    private var player_pair_amount = 0
    
    private var player_pair = 0
    private var banker_pair = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        betCollectionView.reloadData()
        self.winnerImageViews.forEach { imageV in
//            imageV.image = UIImage.gif(name: "ic_jackpot_rule_bg_selected")
            imageV.isHidden = true
        }
        startGameStatus()
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
    
    @IBAction func tapOnPlaceBet(_ sender: UIButton) {
        var animationIndex = 0
        switch sender.tag {
        case 0:
            // 2 Player
            animationIndex = 2
            break
        case 1:
            // 4 Banker
            animationIndex = 4
            break
        case 2:
            // 3 Tie
            animationIndex = 3
            break
        case 3:
            // 0 Player Pair
            animationIndex = 0
            break
        case 4:
            // 1 Banker Pair
            animationIndex = 1
            break
        default:
            break
        }
        
        let tempFrame = self.gameComponentsViews[animationIndex].frame
        self.gameComponentsViews[animationIndex].frame = CGRect(x: tempFrame.origin.x + 5, y: tempFrame.origin.y + 5, width: tempFrame.size.width, height: tempFrame.size.height)
        UIView.transition(with: self.gameComponentsViews[animationIndex], duration: 0.5) {
            self.gameComponentsViews[animationIndex].frame = tempFrame
        } completion: { isAaa in
            self.gameComponentsViews[animationIndex].frame = tempFrame
        }
        if placeGameAmount <= 0 {
            Toast.makeToast("First Select Bet amount")
            return
        }
        self.placeBet(sender.tag, viewIndexx: animationIndex)
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
        makeDummyAnimation()
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
            self.setWinningView()
            
            return
        }
        if allCardsArray.count > 1 {
            let cardPostion = cardDistributeCount % 2
            if cardDistributeCount > 1 {
                self.bCardImages[cardPostion].image = UIImage(named: allCardsArray[cardDistributeCount].lowercased())
            } else {
                self.pCardImages[cardPostion].image = UIImage(named: allCardsArray[cardDistributeCount].lowercased())
            }
        }
        cardDistributeCount += 1
    }
    
    private func makeDummyAnimation() {
        for i in 0..<self.gameComponentsViews.count {
            var imageNameArray = [10, 50, 100, 1000, 5000, 10, 50, 100]

            let stackViewX = i > 1 ? self.gameSubView2.frame.origin.x : self.gameSubView1.frame.origin.x
            let stackViewY = i > 1 ? self.gameSubView2.frame.origin.y : self.gameSubView1.frame.origin.y
            
            let originX = (self.gameMainStackView.frame.origin.x + self.gameMainSubView.frame.origin.x + stackViewX + self.gameComponentsViews[i].frame.origin.x)
            let originY = (self.gameMainStackView.frame.origin.y + self.gameMainSubView.frame.origin.y + stackViewY + self.gameComponentsViews[i].frame.origin.y) + 35.0
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
    
    private func setWinningView() {
        // winningRule
        var winningIndex = 3
        switch winnerId {
        case 0:
            //Player
            winningIndex = 2
            break
        case 1:
            winningIndex = 4
            //Banker
            break
        case 2:
            //Tie
            winningIndex = 3
            break
        case 3:
            //Player Pair
            if player_pair == 1 {
                winningIndex = 0
            } else {
                winningIndex = 2
            }
            break
        case 4:
            //Backer Pair
            if banker_pair == 1 {
                winningIndex = 1
            } else {
                winningIndex = 4
            }
            break
        default:
            break
        }
        self.winnerImageViews[winningIndex].isHidden = false
        self.delay(2.0) {
            self.gameStartTimer.invalidate()
            self.cardDistributeTimer.invalidate()
            for vv in self.gameMainView.subviews {
                if vv.tag == 9999 {
                    vv.removeFromSuperview()
                }
            }
            self.delay(2.0) {
                // Cancel game timer
                self.isCardsDisribute = false
                self.winnerImageViews.forEach { imageV in
                    imageV.isHidden = true
                }
            }
        }
        
    }
}

extension BaccaratViewController {
    private func placeBet(_ tagIndex: Int, viewIndexx: Int) {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: ColourPredBetRequest(game_id: self.game_id, bet:  "\(tagIndex + 1)", amount: "\(self.placeGameAmount)"), feed: .Baccart_place_bet, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse?.data, apiResponse?.code == 200 {
                        self.walletBalLbl.text = response["wallet"].stringValue
                        if let selectAmt = Int(self.selectAmtLabels[viewIndexx].text ?? "0") {
                            self.selectAmtLabels[viewIndexx].text = "\(selectAmt + self.placeGameAmount)"
                        }
                    } else if let message = apiResponse?.message, !message.isEmpty {
                        Toast.makeToast("First select bet amount")
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
            APIClient.shared.post(parameters: GameBaccaratRequest(total_bet_banker: "\(banker_amount)", total_bet_player: "\(player_amount)", total_bet_banker_pair: "\(banker_pair_amount)", total_bet_player_pair: "\(player_amount)", total_bet_tie: "\(tie_amount)"), feed: .Baccart_get_active_game, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let responseCode = apiResponse?.code, responseCode == 407 {
                        self.dismiss(animated: true)
                    } else if let response = apiResponse?.data, apiResponse?.code == 200 {
//                        print("Response: \(response)")
                        self.addedAmtLabels.forEach { lbl in
                            lbl.text = ""
                        }
                        var gameStatus = ""
                        winnerId = -1
                        lastWinList = [LastWinningsModel]()
                        if let lastWinnings = response["last_winning"].array, lastWinnings.count > 0 {
                            lastWinnings.forEach { object in
                                lastWinList.append(LastWinningsModel(object))
                            }
                            self.resultCollectionView.reloadData()
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
                                
                                if let playerpair = gameData["player_pair"].int {
                                    player_pair = playerpair
                                } else if let playerpair = gameData["player_pair"].string {
                                    player_pair = Int(playerpair) ?? 0
                                }
                                
                                if let bankerpair = gameData["banker_pair"].int {
                                    banker_pair = bankerpair
                                } else if let bankerpair = gameData["banker_pair"].string {
                                    banker_pair = Int(bankerpair) ?? 0
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
                                    self.betEndImage.frame.size.height = 33.0
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
                            player_pair_amount = 0
                            banker_pair_amount = 0
                            player_amount = 0
                            tie_amount = 0
                            banker_amount = 0

                            self.gameComponentsViews.forEach { gameView in
                                switch gameView.tag {
                                case 0:
                                    //Red
                                    if let amount = response["player_pair_amount"].int {
                                        player_pair_amount = amount
                                    } else if let amount = response["player_pair_amount"].string {
                                        player_pair_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(player_pair_amount)"
                                    break
                                case 1:
                                    //Black
                                    if let amount = response["banker_pair_amount"].int {
                                        banker_pair_amount = amount
                                    } else if let amount = response["banker_pair_amount"].string {
                                        banker_pair_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(banker_pair_amount)"
                                    break
                                case 2:
                                    //Pair
                                    if let amount = response["player_amount"].int {
                                        player_amount = amount
                                    } else if let amount = response["player_amount"].string {
                                        player_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(player_amount)"
                                    break
                                case 3:
                                    //Color
                                    if let amount = response["tie_amount"].int {
                                        tie_amount = amount
                                    } else if let amount = response["tie_amount"].string {
                                        tie_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(tie_amount)"
                                    break
                                case 4:
                                    //Seq
                                    if let amount = response["banker_amount"].int {
                                        banker_amount = amount
                                    } else if let amount = response["banker_amount"].string {
                                        banker_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(banker_amount)"
                                    break
                                default:
                                    break
                                }
                            }
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
                                self.betEndImage.frame.size.height = 33.0
                                self.delay(1) { [self] in
                                    self.betEndImage.isHidden = true
                                    allCardsArray = [String]()
                                    if let gameCards = response["game_cards"].array, gameCards.count > 0 {
                                        gameCards.forEach { object in
                                            allCardsArray.append(object["card"].stringValue)
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
        selectAmtLabels.forEach { lbl in
            lbl.text = "0"
        }
        isCardsDisribute = false
        cardDistributeCount = 0
        self.pleaseWaitView.isHidden = true

        self.winnerImageViews.forEach { imageV in
            imageV.isHidden = true
        }
        self.pCardImages.forEach { imageV in
            imageV.image = UIImage(named: "card_bg")
        }
        self.bCardImages.forEach { imageV in
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

extension BaccaratViewController: UICollectionViewDataSource {
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
            cell.configureLast(lastWinList[indexPath.row], gameType: .bacarate)
            return cell
        }
        return UICollectionViewCell()
    }
}

extension BaccaratViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 25.0, height: 25.0)
//    }
}

extension BaccaratViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.betCollectionView == collectionView  {
            self.placeGameAmount = coinsDataList[indexPath.row]
            self.betCollectionView.reloadData()
        }
    }
}


// MARK: Alert Prompt Delegate
extension BaccaratViewController: PromptViewDelegate {
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
