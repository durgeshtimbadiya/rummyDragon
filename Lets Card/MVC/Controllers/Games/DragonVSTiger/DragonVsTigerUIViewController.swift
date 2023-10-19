//
//  DragonVsTigerUIViewController.swift
//  Lets Card
//
//  Created by Durgesh on 28/02/23.
//

import UIKit

class DragonVsTigerTableViewController: UIViewController {
    
    @IBOutlet weak var dragonGifImage: UIImageView!
    @IBOutlet weak var tigerGifImage: UIImageView!
    @IBOutlet weak var firstCardImage: UIImageView!
    @IBOutlet weak var secondCardImage: UIImageView!
    @IBOutlet weak var timeDownLabel: UILabel!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    @IBOutlet weak var onlineAmtLbl: UILabel!
    
    @IBOutlet weak var leftPlayerCollectionView: UICollectionView!
    @IBOutlet weak var rightPlayerCollectionView: UICollectionView!
    
    @IBOutlet weak var myDragonBetLbl: UILabel!
    @IBOutlet weak var myTieBetLbl: UILabel!
    @IBOutlet weak var myTigerBetLbl: UILabel!
    
    @IBOutlet weak var dragonTotalBetLbl: UILabel!
    @IBOutlet weak var tieTotalBetLbl: UILabel!
    @IBOutlet weak var tigerTotalBetLbl: UILabel!
    
    @IBOutlet weak var dragonChipsImg: UIImageView!
    @IBOutlet weak var tieChipsImg: UIImageView!
    @IBOutlet weak var tigerChipsImg: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var walletBalLbl: UILabel!
    @IBOutlet weak var betCollectionView: UICollectionView!
    
    @IBOutlet weak var pleaseWaitLabel: UIImageView!
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var aniSubView1: UIView!
    @IBOutlet weak var aniSubView2: UIView!
    @IBOutlet weak var aniSubView3: UIView!
    @IBOutlet weak var gameMainView: UIView!
    @IBOutlet weak var otherUserView: UIStackView!
    @IBOutlet weak var animationWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var profileBottomView: UIView!
    @IBOutlet weak var profileBottomView1: UIView!
    @IBOutlet weak var profileBottomView2: UIView!
    @IBOutlet weak var gameWinView: UIView!
    @IBOutlet weak var gameWinImage: UIImageView!
    @IBOutlet weak var betStartImage: UIImageView!
    @IBOutlet weak var betEndImage: UIImageView!

    private var dragon_bet = 0
    private var tiger_bet = 0
    private var tie_bet = 0
    private var game_id = ""
    private var timerStatus = Timer()
    private var isGameBegning = false
    private var placeGameAmount = 50
    private var bet_id = ""
    private var wallet = ""
    private var coinsDataList = [Int]()
    private var mBetsOn = [String]()
    private var canBet = false
    
    private var gameStartTimer = Timer()
    private var gameStartTime = 17
    private var originalAniRect = CGRect.zero
    private var originalAniConstraint = CGFloat()
    private var isBetStarted = false
    private var lastWinList = [LastWinningsModel]()
    private var botUsers = [HeadTailBotModel]()
    private var isBotPlayerSet = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.animationView.isHidden = true
        self.gameWinView.isHidden = true
        self.betStartImage.isHidden = true
        self.betEndImage.isHidden = true
        
        self.pleaseWaitLabel.image = UIImage.gif(name: "waiting_for_next")
        self.betStartImage.image = UIImage.gif(name: "place_your_bet")
        self.betEndImage.image = UIImage.gif(name: "stop_betting")
        
        self.profileBottomView1.applyGradient(isVertical: false, colorArray: [UIColor(hexString: "#353541"), UIColor(hexString: "#565c79")])
        self.profileBottomView2.applyGradient(isVertical: false, colorArray: [UIColor(hexString: "#353541"), UIColor(hexString: "#565c79")])
//        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.colors = [UIColor(hexString: "#353541").cgColor, UIColor(hexString: "#565c79").cgColor]
////        gradient.locations = [0.0, 0.5, 1.0]
//        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
//        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
//
//        gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width - 20.0, height: self.profileBottomView1.bounds.height)
//        self.profileBottomView1.layer.insertSublayer(gradient, at: 0)//(gradient)
        
        self.pleaseWaitLabel.isHidden = true
        if let profileData = ProfileData.getData() {
            self.usernameLbl.text = profileData.name
            self.profileImage.sd_setImage(with: URL(string: profileData.profile_pic), placeholderImage: UIImage(named: "avatar"), context: [:])
            self.walletBalLbl.text = "\(Constants.currencySymbol)\(profileData.wallet.cleanValue2)"
        }
        
        coinsDataList.append(10)
        coinsDataList.append(50)
        coinsDataList.append(100)
        coinsDataList.append(1000)
        coinsDataList.append(5000)
        self.restartGame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerStatus.invalidate()
        timerStatus.invalidate()
    }
    
    private func startGameStatus() {
        if timerStatus.isValid {
            timerStatus.invalidate()
        }
        timerStatus = Timer(timeInterval: 8, target: self, selector: #selector(self.gameStatus), userInfo: nil, repeats: true)
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
        gameStartTime -= 1
        if gameStartTime == 0 {
            self.timeDownLabel.isHidden = true
        }
        if gameStartTime < 0 {
            if gameStartTimer.isValid {
                gameStartTimer.invalidate()
            }
            gameStartTime = 16
            return
        }
        makeDummyAnimation()
        self.timeDownLabel.isHidden = false
        self.timeDownLabel.text = "\(gameStartTime).0s"
    }
    
    private func makeDummyAnimation() {
        originalAniRect = self.animationView.frame
        originalAniConstraint = self.animationWidthConstraint.constant
        self.animationView.isHidden = true

        self.animationView.frame = CGRect(x: self.otherUserView.frame.origin.x, y: self.otherUserView.frame.origin.y + 10.0, width: 20.0, height: 20.0)
        
        let myNewAniView = UIView(frame: CGRect(x: self.otherUserView.frame.origin.x, y: self.otherUserView.frame.origin.y + 10.0, width: 20.0, height: 20.0))
        myNewAniView.tag = 9999
        myNewAniView.isUserInteractionEnabled = false
        let myAniSubView1 = UIView(frame: self.aniSubView1.frame)
        let myAniSubView2 = UIView(frame: self.aniSubView2.frame)
        let myAniSubView3 = UIView(frame: self.aniSubView3.frame)
        myAniSubView1.isUserInteractionEnabled = false
        myAniSubView2.isUserInteractionEnabled = false
        myAniSubView3.isUserInteractionEnabled = false
        myNewAniView.addSubview(myAniSubView1)
        myNewAniView.addSubview(myAniSubView2)
        myNewAniView.addSubview(myAniSubView3)
//        myNewAniView.backgroundColor = .black
        myNewAniView.clipsToBounds = true

        self.gameMainView.addSubview(myNewAniView)

        var imageNameArray = [10, 50, 100, 1000, 5000]
        //imageNameArray.randomElement()
        var xFrom = 0.0
        var xTo = 20.0
        
        for _ in 0..<5 {
            let yRandomNumber = CGFloat.random(in: 0...15)
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                let imageView = UIImageView(image: UIImage(named: "ic_coin_\(rndNumber)_dt")) // 10, 50, 100, 1000, 5000
                imageView.frame = CGRect(x: CGFloat.random(in: xFrom...xTo), y: yRandomNumber, width: 20.0, height: 20.0)
                imageView.isUserInteractionEnabled = false
                myAniSubView1.addSubview(imageView)
                xFrom += 20.0
                xTo += 20.0
            }
        }
        imageNameArray = [10, 50, 100, 1000, 5000]
        xFrom = 0.0
        xTo = 20.0
        for _ in 0..<5 {
            let yRandomNumber = CGFloat.random(in: 0...15)
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                let imageView = UIImageView(image: UIImage(named: "ic_coin_\(rndNumber)_dt")) // 10, 50, 100, 1000, 5000
                imageView.frame = CGRect(x: CGFloat.random(in: xFrom...xTo), y: yRandomNumber, width: 20.0, height: 20.0)
                imageView.isUserInteractionEnabled = false
                myAniSubView2.addSubview(imageView)
                xFrom += 20.0
                xTo += 20.0
            }
        }
        imageNameArray = [10, 50, 100, 1000, 5000]
        xFrom = 0.0
        xTo = 20.0
        for _ in 0..<5 {
            let yRandomNumber = CGFloat.random(in: 0...15)
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                let imageView = UIImageView(image: UIImage(named: "ic_coin_\(rndNumber)_dt")) // 10, 50, 100, 1000, 5000
                imageView.frame = CGRect(x: CGFloat.random(in: xFrom...xTo), y: yRandomNumber, width: 20.0, height: 20.0)
                imageView.isUserInteractionEnabled = false
                myAniSubView3.addSubview(imageView)
                xFrom += 20.0
                xTo += 20.0
            }
        }

        UIView.animate(withDuration: 1) {
            myNewAniView.frame = self.originalAniRect
        } completion: { s in
            myNewAniView.clipsToBounds = false
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
}

// MARK: Action
extension DragonVsTigerTableViewController {
    @IBAction func tapOnDragonTieTigerBtn(_ sender: UIButton) {
        // 0 - Dragon
        // 1 - Tiger
        // 2 - Tie
        if !isBetStarted {
            Toast.makeToast("Can't Place Bet, Game Has Been Ended")
            return
        }
        if sender.tag == 0 {
            self.dragonChipsImg.isHidden = false
        }
        if sender.tag == 1 {
            self.tigerChipsImg.isHidden = false
        }
        if sender.tag == 2 {
            self.tieChipsImg.isHidden = false
        }
        placeBet(sender.tag)
    }
    
    @IBAction func tapOnAddChips(_ sender: UIButton) {
        
    }
    
    @IBAction func tapOnBackButton(_ sender: UIButton) {
        PromptVManager.present(self, titleString: "CONFIRMATOIN", messageString: "Are you sure, you want to Leave ?", viewTag: 1)
    }
    
    @IBAction func tapOnInfoButton(_ sender: UIButton) {
        if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: DialogInfoViewController().className) as? DialogInfoViewController {
            myObject.isInformationView = true
            self.navigationController?.present(myObject, animated: true)
        }
    }
}

// MARK: Alert Prompt Delegate
extension DragonVsTigerTableViewController: PromptViewDelegate {
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

// MARK: API Calls
extension DragonVsTigerTableViewController {
    
    private func placeBet(_ type: Int) {
        DispatchQueue.global(qos: .background).async {
            self.mBetsOn.append("\(type)")
            APIClient.shared.post(parameters: DNTPlaceBetRequest(game_id: self.game_id, bet: "\(type)", amount: "\(self.placeGameAmount)"), feed: .DT_place_bet, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse?.data {
                        if let mydragonbet = response["bet_id"].int {
                            bet_id = "\(mydragonbet)"
                        } else if let mydragonbet = response["bet_id"].string {
                            bet_id = mydragonbet
                        }
                        wallet = response["wallet"].stringValue
                        self.walletBalLbl.text = response["wallet"].stringValue
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
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameDNTRequest(total_bet_dragon: "\(self.dragon_bet)", total_bet_tiger: "\(self.tiger_bet)", total_bet_tie: "\(self.tie_bet)"), feed: .DT_get_active_game, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let responseCode = apiResponse?.code, responseCode == 407 {
                        self.dismiss(animated: true)
                    } else if let response = apiResponse?.data {
                        
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
//                        print("Response: \(response)")
                        myDragonBetLbl.text = "0"
                        myTigerBetLbl.text = "0"
                        myTieBetLbl.text = "0"
                        var gameStatus = ""
                        var winning = ""
                        var time_remaining = 0
                        lastWinList = [LastWinningsModel]()
                        if let mydragonbet = response["my_dragon_bet"].int, mydragonbet > 0 {
                            myDragonBetLbl.text = "\(mydragonbet)"
                        } else if let mydragonbet = response["my_dragon_bet"].string {
                            myDragonBetLbl.text = mydragonbet
                        }
                        if let mytigerbet = response["my_tiger_bet"].int {
                            myTigerBetLbl.text = "\(mytigerbet)"
                        } else if let mytigerbet = response["my_tiger_bet"].string {
                            myTigerBetLbl.text = mytigerbet
                        }
                        if let mytiebet = response["my_tie_bet"].int {
                            myTieBetLbl.text = "\(mytiebet)"
                        } else if let mytiebet = response["my_tie_bet"].string {
                            myTieBetLbl.text = mytiebet
                        }
                        
                        if let dragonBet = response["dragon_bet"].int {
                            dragon_bet = dragonBet
                        } else if let dragonBet = response["dragon_bet"].string {
                            dragon_bet = Int(dragonBet) ?? 0
                        }
                        if let tigerBet = response["tiger_bet"].int {
                            tiger_bet = tigerBet
                        } else if let tigerBet = response["tiger_bet"].string {
                            tiger_bet = Int(tigerBet) ?? 0
                        }
                        if let tieBet = response["tie_bet"].int {
                            tie_bet = tieBet
                        } else if let tieBet = response["tie_bet"].string {
                            tie_bet = Int(tieBet) ?? 0
                        }
                        
                        if let online = response["online"].int {
                            onlineAmtLbl.text = "\(online)"
                        } else if let online = response["online"].string {
                            onlineAmtLbl.text = online
                        }
                        
                        if let profileArrayData = response["profile"].array, profileArrayData.count > 0 {
                            let profileDataModel = ProfileData(profileArrayData[0])
                            self.usernameLbl.text = profileDataModel.name
                            self.profileImage.sd_setImage(with: URL(string: profileDataModel.profile_pic), placeholderImage: UIImage(named: "avatar"), context: [:])
                            self.walletBalLbl.text = profileDataModel.wallet.cleanValue2
                        }
                        
                        if let gameDataList = response["game_data"].array, gameDataList.count > 0 {
                            gameDataList.forEach { gameData in
                                if let online = gameData["status"].int {
                                    gameStatus = "\(online)"
                                } else if let online = gameData["status"].string {
                                    gameStatus = online
                                }
                                
                                if let win = gameData["winning"].int {
                                    winning = "\(win)"
                                } else if let win = gameData["winning"].string {
                                    winning = win
                                }

                                if let timeRemaining = gameData["time_remaining"].int {
                                    time_remaining = timeRemaining
                                } else if let timeRemaining = gameData["time_remaining"].string {
                                    time_remaining = Int(timeRemaining) ?? 0
                                }
                                if let lastWinnings = response["last_winning"].array, lastWinnings.count > 0 {
                                    lastWinnings.forEach { object in
                                        lastWinList.append(LastWinningsModel(object))
                                    }
                                    self.resultCollectionView.reloadData()
        //                                    print("Last winnings: \(lastWinnings)")
        //                            if game_id == gameData["id"].stringValue {
        //                                // Added bet
        //                            }
                                }
                                
                                game_id = gameData["id"].stringValue
                            }
                        }
                        
                        if dragon_bet > 0 {
                            self.dragonTotalBetLbl.text = "\(dragon_bet)"
                        }
                        if tiger_bet > 0 {
                            self.tigerTotalBetLbl.text = "\(tiger_bet)"
                        }
                        if tie_bet > 0 {
                            self.tieTotalBetLbl.text = "\(tie_bet)"
                        }
                        // New game started here
                        if gameStatus == "0" && !isGameBegning {
                            restartGame()
                            isGameBegning = true
                            if time_remaining > 0 {
                                // Distribute coins animation
                                //Start bet animation
                                isBetStarted = true
                                self.betStartImage.isHidden = false
//                                self.betStartImage.frame.size.height = 0.0
//                                UIView.transition(with: self.betStartImage, duration: 1, options: .curveEaseInOut) {
//                                    self.betStartImage.frame.size.height = 33.0
                                    self.delay(1) {
//                                        self.betStartImage.isHidden = true
                                        self.timeDownLabel.isHidden = false
                                        self.setGameTimer()
                                    }
//                                }
                            }
                        }
                        self.pleaseWaitLabel.isHidden = true
                        if gameStatus == "1" && !isGameBegning {
                            self.pleaseWaitLabel.isHidden = false
                        }
                        //iv_bet_begin, iv_bet_stops
                        if gameStatus == "1" && isGameBegning {
                            isGameBegning = false
                            self.betStartImage.isHidden = true
                            self.betEndImage.isHidden = false
//                            self.betEndImage.frame.size.height = 0.0
//                            UIView.transition(with: self.betEndImage, duration: 1, options: .curveEaseInOut) {
//                                self.betEndImage.frame.size.height = 33.0
                                self.delay(2) { [self] in
                                    self.betEndImage.isHidden = true
                                    if let gameCards = response["game_cards"].array, gameCards.count > 0 {
                                        // Cancel game timer
                                        isBetStarted = false
                                        self.firstCardImage.image = UIImage(named: gameCards[0]["card"].stringValue.lowercased())
                                        if gameCards.count > 1 {
                                            self.secondCardImage.image = UIImage(named: gameCards[1]["card"].stringValue.lowercased())
                                        }
                                        let isWin = mBetsOn.contains(winning)
                                        if isWin {
                                            // Set animation to my profile
                                            for vv in self.gameMainView.subviews {
                                                if vv.tag == 9999 {
                                                    UIView.animate(withDuration: 1) {
                                                        vv.frame = CGRect(x: self.profileBottomView.frame.origin.x + 30, y: self.profileBottomView.frame.origin.y, width: 20.0, height: 20.0)
                                                    } completion: { s in
                                                        vv.removeFromSuperview()
                                                    }
                                                }
                                            }
                                        } else {
                                            for vv in self.gameMainView.subviews {
                                                if vv.tag == 9999 {
                                                    UIView.animate(withDuration: 1) {
                                                        vv.frame = CGRect(x: self.otherUserView.frame.origin.x + 10, y: self.otherUserView.frame.origin.y + 10.0, width: 20.0, height: 20.0)
                                                    } completion: { s in
                                                        vv.removeFromSuperview()
                                                    }
                                                }
                                            }
                                            // Set animation to user profile
                                        }
                                        if gameStartTimer.isValid {
                                            gameStartTimer.invalidate()
                                        }
                                        gameStartTime = 17
                                        if timerStatus.isValid {
                                            timerStatus.invalidate()
                                        }
                                        self.timeDownLabel.isHidden = true
                                        delay(2) {
                                            self.gameWinView.isHidden = false
                                            if let winInteVal = Int(winning) {
                                                if winInteVal == 0 || winInteVal == 1 {
                                                    self.gameWinImage.image = UIImage.gif(name: winInteVal == 0 ? "gif_dragon_animated" : "gif_tiger_animated")
                                                } else {
                                                    self.gameWinImage.image = UIImage(named: "ic_dt_tiegame")
                                                }
                                            }
                                            self.delay(3) {
                                                self.gameWinView.isHidden = true
                                                self.restartGame()
                                            }
                                        }
                                    }
//                                }
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
        for vv in self.gameMainView.subviews {
            if vv.tag == 9999 {
                vv.removeFromSuperview()
            }
        }
        
        dragonGifImage.image = UIImage.gif(name: "ic_dragon_gif")
        tigerGifImage.image = UIImage.gif(name: "ic_tiger_gif")
        firstCardImage.image = UIImage.gif(name: "fire_card")
        secondCardImage.image = UIImage.gif(name: "fire_card")
        
        mBetsOn = [String]()
        canBet = true
        dragon_bet = 0
        tiger_bet = 0
        tie_bet = 0
        
        myDragonBetLbl.text = "0"
        myTigerBetLbl.text = "0"
        myTieBetLbl.text = "0"
        
        dragonTotalBetLbl.text = "0"
        tieTotalBetLbl.text = "0"
        tigerTotalBetLbl.text = "0"
        
        self.dragonChipsImg.isHidden = true
        self.tieChipsImg.isHidden = true
        self.tigerChipsImg.isHidden = true
        
        startGameStatus()
    }
}

extension DragonVsTigerTableViewController: UICollectionViewDataSource {
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//
//        let totalCellWidth = 60 * coinsDataList.count
//        let totalSpacingWidth = 10 * (coinsDataList.count - 1)
//
//        let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
//        let rightInset = leftInset
//
//        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.betCollectionView {
            return coinsDataList.count
        }
        if collectionView == self.resultCollectionView {
            return self.lastWinList.count
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
        if (collectionView == self.resultCollectionView || collectionView == self.betCollectionView), let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView == self.resultCollectionView ? DNTCollectionViewCell.lastBetCell : DNTCollectionViewCell.betCell, for: indexPath) as? DNTCollectionViewCell {
            if collectionView == self.resultCollectionView {
                cell.configureLast(lastWinList[indexPath.row], gameType: .none)
            } else {
                cell.configure(coinsDataList[indexPath.row], highLightet: self.placeGameAmount)
            }
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

extension DragonVsTigerTableViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == betCollectionView {
            self.placeGameAmount = coinsDataList[indexPath.row]
            self.betCollectionView.reloadData()
        }
    }
}

extension CALayer {
    func moveTo(point: CGPoint, animated: Bool) {
        if animated {
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = value(forKey: "position")
            animation.toValue = NSValue(cgPoint: point)
            animation.fillMode = .forwards
            self.position = point
            add(animation, forKey: "position")
        } else {
            self.position = point
        }
    }

    func resize(to size: CGSize, animated: Bool) {
        let oldBounds = bounds
        var newBounds = oldBounds
        newBounds.size = size

        if animated {
            let animation = CABasicAnimation(keyPath: "bounds")
            animation.fromValue = NSValue(cgRect: oldBounds)
            animation.toValue = NSValue(cgRect: newBounds)
            animation.fillMode = .forwards
            self.bounds = newBounds
            add(animation, forKey: "bounds")
        } else {
            self.bounds = newBounds
        }
    }

    func resizeAndMove(frame: CGRect, animated: Bool, duration: TimeInterval = 0) {
        if animated {
            let positionAnimation = CABasicAnimation(keyPath: "position")
            positionAnimation.fromValue = value(forKey: "position")
            positionAnimation.toValue = NSValue(cgPoint: CGPoint(x: frame.midX, y: frame.midY))

            let oldBounds = bounds
            var newBounds = oldBounds
            newBounds.size = frame.size

            let boundsAnimation = CABasicAnimation(keyPath: "bounds")
            boundsAnimation.fromValue = NSValue(cgRect: oldBounds)
            boundsAnimation.toValue = NSValue(cgRect: newBounds)

            let groupAnimation = CAAnimationGroup()
            groupAnimation.animations = [positionAnimation, boundsAnimation]
            groupAnimation.fillMode = .forwards
            groupAnimation.duration = duration
            groupAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            DispatchQueue.main.asyncAfter(deadline: .now() + duration - 0.2) {
                self.frame = frame
            }
            
            add(groupAnimation, forKey: "frame")

        } else {
            self.frame = frame
        }
    }
}
