//
//  SevenUpDownViewController.swift
//  Lets Card
//
//  Created by Durgesh on 22/03/23.
//

import UIKit

class SevenUpDownViewController: UIViewController {
    
    @IBOutlet weak var pleaseWaitLabel: UIImageView!
    @IBOutlet weak var dealerImage: UIImageView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var otherUserView: UIStackView!
    @IBOutlet weak var collectionResultView: UICollectionView!
    @IBOutlet weak var twoSixCoinView: UIStackView!
    @IBOutlet weak var sevenCoinView: UIStackView!
    @IBOutlet weak var eightTwelCoinView: UIStackView!
    
    @IBOutlet weak var leftPlayerCollectionView: UICollectionView!
    @IBOutlet weak var rightPlayerCollectionView: UICollectionView!
    
    @IBOutlet weak var twoSixMainView: UIView!
    @IBOutlet weak var sevenMainView: UIView!
    @IBOutlet weak var eightTwelMainView: UIView!
    
    @IBOutlet weak var otherUserWLabel: UILabel!
    @IBOutlet weak var twoSixBetLabel: UILabel!
    @IBOutlet weak var sevenBetLabel: UILabel!
    @IBOutlet weak var eightTwelBetLabel: UILabel!
    
    @IBOutlet weak var twoSixTotalLabel: UILabel!
    @IBOutlet weak var sevenTotalLabel: UILabel!
    @IBOutlet weak var eightTweTotalLabel: UILabel!

    @IBOutlet weak var profileBottomView: UIView!
    @IBOutlet weak var profileBottomView1: UIView!
    @IBOutlet weak var profileBottomView2: UIView!
    @IBOutlet weak var gameMainView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var walletBalLbl: UILabel!
    @IBOutlet weak var betCollectionView: UICollectionView!
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var aniSubView1: UIView!
    @IBOutlet weak var aniSubView2: UIView!
    @IBOutlet weak var aniSubView3: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var betStartImage: UIImageView!
    @IBOutlet weak var betEndImage: UIImageView!
    @IBOutlet weak var animationWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var diceMainView: UIView!
    @IBOutlet weak var dice1Image: UIImageView!
    @IBOutlet weak var dice2Image: RotatableImageView!

    @IBOutlet weak var winTwoSixImage: UIImageView!
    @IBOutlet weak var winSevenImage: UIImageView!
    @IBOutlet weak var winEightTwelImage: UIImageView!

    private var coinsDataList = [Int]()
    private var lastWinList = [LastWinningsModel]()
    private var placeGameAmount = 50
    
    private var timerStatus = Timer()
    private var all_up_bet = 0
    private var all_down_bet = 0
    private var all_tie_bet = 0
    private var game_id = ""
    private var timeRemaining = 0
    private var isGameBegning = false
    private var gameStartTimer = Timer()
    private var allCardsArray = [String]()
    private var betPlaces = [String]()
    private var originalAniRect = CGRect.zero
    private var originalAniConstraint = CGFloat()
    private var winnerId = -1
    private var bet_id = ""
    private var botUsers = [HeadTailBotModel]()
    private var isBotPlayerSet = false
    
    static let BETUPET = "UP"
    static let BETDOWNTS = "DOWN"
    static let BETTIES = "TIE"
    
    let BETUP_VALUEET = 1
    let BETDOWN_VALUETS = 0
    let BETTIE_VALUES = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.twoSixCoinView.isHidden = true
        self.sevenCoinView.isHidden = true
        self.eightTwelCoinView.isHidden = true
        self.betEndImage.isHidden = true
        self.betStartImage.isHidden = true
        self.diceMainView.isHidden = true
        
        self.pleaseWaitLabel.image = UIImage.gif(name: "waiting_for_next")
        self.betStartImage.image = UIImage.gif(name: "place_your_bet")
        self.betEndImage.image = UIImage.gif(name: "stop_betting")
        self.dealerImage.image = UIImage.gif(name: "seven_girl")
        
        self.profileBottomView1.applyGradient(isVertical: false, colorArray: [UIColor(hexString: "#353541"), UIColor(hexString: "#565c79")])
        self.profileBottomView2.applyGradient(isVertical: false, colorArray: [UIColor(hexString: "#353541"), UIColor(hexString: "#565c79")])

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
        betCollectionView.reloadData()
        startGameStatus()
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
    }
    
    private func startGameStatus() {
        if timerStatus.isValid {
            timerStatus.invalidate()
        }
        timerStatus = Timer(timeInterval: 8, target: self, selector: #selector(self.gameStatus), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timerStatus, forMode: .default)
        timerStatus.fire()
    }
    
    @IBAction func tapOnAddChips(_ sender: UIButton) {
        
    }
    
    @IBAction func tapOnBackButton(_ sender: UIButton) {
        PromptVManager.present(self, titleString: "CONFIRMATOIN", messageString: "Are you sure, you want to Leave ?", viewTag: 1)
    }
    
    @IBAction func tapOnPlaceBet(_ sender: UIButton) {
        placeBet(sender.tag)
    }
    
    @objc private func pleaseWaitAnimation() {
        if winnerId == 0 {
            // Two six
            self.winTwoSixImage.alpha = 1.0
            UIView.animate(withDuration: 2.0) {
                self.winTwoSixImage.alpha = 0.5
            } completion: { st in
                self.pleaseWaitAnimation()
            }
        } else if winnerId == 1 {
            // Eight Twel
            self.winEightTwelImage.alpha = 1.0
            UIView.animate(withDuration: 2.0) {
                self.winEightTwelImage.alpha = 0.5
            } completion: { st in
                self.pleaseWaitAnimation()
            }
        } else if winnerId == 2 {
            // Seven
            self.winSevenImage.alpha = 1.0
            UIView.animate(withDuration: 2.0) {
                self.winSevenImage.alpha = 0.5
            } completion: { st in
                self.pleaseWaitAnimation()
            }
        }
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
            self.timerLabel.isHidden = true
        }
        if timeRemaining < 0 {
            if gameStartTimer.isValid {
                gameStartTimer.invalidate()
            }
            return
        }
        makeDummyAnimation()
        self.timerLabel.isHidden = false
        self.timerLabel.text = "\(timeRemaining)"
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
        let xFrom = 0.0
        let xTo = 100.0
        for _ in 0..<1 {
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                let imageView = UIImageView(image: UIImage(named: "ic_coin_\(rndNumber)_dt")) // 10, 50, 100, 1000, 5000
                imageView.frame = CGRect(x: CGFloat.random(in: xFrom...xTo), y: 0.0, width: 20.0, height: 20.0)
                imageView.isUserInteractionEnabled = false
                myAniSubView1.addSubview(imageView)
            }
        }
        imageNameArray = [10, 50, 100, 1000, 5000]
        for _ in 0..<1 {
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                let imageView = UIImageView(image: UIImage(named: "ic_coin_\(rndNumber)_dt")) // 10, 50, 100, 1000, 5000
                imageView.frame = CGRect(x: CGFloat.random(in: xFrom...xTo), y: 0.0, width: 20.0, height: 20.0)
                imageView.isUserInteractionEnabled = false
                myAniSubView2.addSubview(imageView)
            }
        }
        imageNameArray = [10, 50, 100, 1000, 5000]
        for _ in 0..<1 {
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                let imageView = UIImageView(image: UIImage(named: "ic_coin_\(rndNumber)_dt")) // 10, 50, 100, 1000, 5000
                imageView.frame = CGRect(x: CGFloat.random(in: xFrom...xTo), y: 0.0, width: 20.0, height: 20.0)
                imageView.isUserInteractionEnabled = false
                myAniSubView3.addSubview(imageView)
            }
        }

        UIView.animate(withDuration: 1) {
            myNewAniView.frame = self.originalAniRect
        } completion: { s in
            myNewAniView.clipsToBounds = false
        }
    }
    
    private func makeDummyAnimation1() {
        var imageNameArray = [10, 50, 100, 1000, 5000]
        var imageTag = 10
        if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
            imageNameArray.remove(at: indexX)
            imageTag = rndNumber
        }
        let imageView = UIImageView(image: UIImage(named: "ic_coin_\(imageTag)_dt")) // 10, 50, 100, 1000, 5000
        imageView.tag = 9999
        var originX = (self.gameMainView.frame.origin.x + self.animationView.frame.origin.x + self.aniSubView1.frame.origin.x + 20.0)
        var originY = (self.gameMainView.frame.origin.y + self.animationView.frame.origin.y + self.aniSubView1.frame.origin.y)
        
        imageView.frame = CGRect(x: -originX, y: CGFloat.random(in: -originY...originY), width: 20.0, height: 20.0)
        imageView.isUserInteractionEnabled = false
        self.aniSubView1.addSubview(imageView)
        
        imageTag = 10
        if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
            imageNameArray.remove(at: indexX)
            imageTag = rndNumber
        }
        
        originX = (self.gameMainView.frame.origin.x + self.animationView.frame.origin.x + self.aniSubView2.frame.origin.x + 20.0)
        originY = (self.gameMainView.frame.origin.y + self.animationView.frame.origin.y + self.aniSubView2.frame.origin.y)
        
        let imageView1 = UIImageView(image: UIImage(named: "ic_coin_\(imageTag)_dt"))
        imageView1.tag = 9999
        imageView1.frame = CGRect(x: -originX, y: CGFloat.random(in: -originY...originY), width: 20.0, height: 20.0)
        imageView1.isUserInteractionEnabled = false
        self.aniSubView2.addSubview(imageView1)
        
        imageTag = 10
        if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
            imageNameArray.remove(at: indexX)
            imageTag = rndNumber
        }
        
        originX = UIScreen.main.bounds.size.width - (self.gameMainView.frame.origin.x + self.animationView.frame.origin.x + self.aniSubView3.frame.origin.x)
        originY = (self.gameMainView.frame.origin.y + self.animationView.frame.origin.y + self.aniSubView3.frame.origin.y)
        
        let imageView2 = UIImageView(image: UIImage(named: "ic_coin_\(imageTag)_dt"))
        imageView2.tag = 9999
        imageView2.frame = CGRect(x: originX, y:-CGFloat.random(in: -originY...originY), width: 20.0, height: 20.0)
        imageView2.isUserInteractionEnabled = false
        self.aniSubView3.addSubview(imageView2)
        
        UIView.animate(withDuration: 1) {
            imageView.frame = CGRect(x: CGFloat.random(in: 0.0...self.aniSubView1.frame.size.width - 20.0), y: 0.0, width: 20.0, height: 20.0)
            imageView1.frame = CGRect(x: CGFloat.random(in: 0.0...self.aniSubView2.frame.size.width - 20.0), y: 0.0, width: 20.0, height: 20.0)
            imageView2.frame = CGRect(x: CGFloat.random(in: 0.0...self.aniSubView3.frame.size.width - 20.0), y: 0.0, width: 20.0, height: 20.0)
        } completion: { s in }
    }
    
    private func makeWinner(_ isMeWinner: Bool) {
        pleaseWaitAnimation()
        let delayTime = 0.1
        var count = 0
        _ = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: true){ t in
            self.makeWinnerDummyAnimation(isMeWinner)
            count += 1
            if count >= 10 {
                t.invalidate()
            }
        }
        
        let delayTime1 = 0.1
        var count1 = 0
        _ = Timer.scheduledTimer(withTimeInterval: delayTime1, repeats: true){ t1 in
            self.makeWinnerDummyAnimation(isMeWinner)
            count1 += 1
            if count1 >= 10 {
                t1.invalidate()
                self.winnerId = -1
                self.diceMainView.isHidden = true
                self.winTwoSixImage.alpha = 1.0
                self.winEightTwelImage.alpha = 1.0
                self.winSevenImage.alpha = 1.0
            }
        }
    }
    
    private func makeWinnerDummyAnimation(_ isMeWinner: Bool) {
        originalAniRect = isMeWinner ? CGRect(x: self.profileBottomView.frame.origin.x + 40.0, y: self.profileBottomView.frame.origin.y + 16.0, width: 100.0, height: 100.0) : CGRect(x: self.otherUserView.frame.origin.x + 80.0, y: self.otherUserView.frame.origin.y + 50.0, width: 20.0, height: 20.0)

        let myNewAndarAniView = winnerId == BETDOWN_VALUETS ? UIView(frame: CGRect(x: self.gameMainView.frame.origin.x + self.mainStackView.frame.origin.x + twoSixMainView.frame.origin.x + (twoSixMainView.frame.size.width / 2.0) - 10.0, y: self.gameMainView.frame.origin.y + self.mainStackView.frame.origin.y + self.twoSixMainView.frame.origin.y + (twoSixMainView.frame.size.height / 2.0) - 20.0, width: 50.0, height: 20.0)) : (winnerId == BETUP_VALUEET ? UIView(frame: CGRect(x: self.gameMainView.frame.origin.x + self.mainStackView.frame.origin.x + eightTwelMainView.frame.origin.x + (eightTwelMainView.frame.size.width / 2.0) - 10.0, y: self.gameMainView.frame.origin.y + self.mainStackView.frame.origin.y + self.eightTwelMainView.frame.origin.y + (eightTwelMainView.frame.size.height / 2.0) - 20.0, width: 50.0, height: 20.0)) : UIView(frame: CGRect(x: self.gameMainView.frame.origin.x + self.mainStackView.frame.origin.x + sevenMainView.frame.origin.x + (sevenMainView.frame.size.width / 2.0) - 10.0, y: self.gameMainView.frame.origin.y + self.mainStackView.frame.origin.y + self.sevenMainView.frame.origin.y + (sevenMainView.frame.size.height / 2.0) - 20.0, width: 50.0, height: 20.0)))

        myNewAndarAniView.tag = 9998
        myNewAndarAniView.isUserInteractionEnabled = false
        myNewAndarAniView.clipsToBounds = false

        self.view.addSubview(myNewAndarAniView)
        for _ in 0..<2 {
                let imageView = UIImageView(image: UIImage(named: "ic_dt_chips"))
                imageView.frame = CGRect(x: CGFloat.random(in: 0...50), y: CGFloat.random(in: 0...20), width: 15.0, height: 15.0)
                imageView.isUserInteractionEnabled = false
                myNewAndarAniView.addSubview(imageView)
        }

        UIView.animate(withDuration: 1) {
            myNewAndarAniView.frame = self.originalAniRect
        } completion: { s in
            myNewAndarAniView.removeFromSuperview()
        }
    }
    
    private func showDiceViewAndAnimate() {
        self.diceMainView.isHidden = false
        let delayTime1 = 0.1
        var count1 = 0
        _ = Timer.scheduledTimer(withTimeInterval: delayTime1, repeats: true){ t1 in
            self.dice1Image.image = UIImage(named: "dots_\(Int.random(in: 1...6))")
            self.dice2Image.image = UIImage(named: "dots_\(Int.random(in: 1...6))")
            count1 += 1
            if count1 >= 20 {
                t1.invalidate()
                let dicevalue = Int(self.allCardsArray[0])!
                let diceseqrate = Double(dicevalue) / 2.0
                var dice1 = Int(Double.rounded(diceseqrate)())
                
                if dice1 == 0 {
                    dice1 = 1
                }
                
                if dicevalue == dice1 {
                    dice1 -= 1
                } else if dicevalue == 2 {
                    dice1 = 1
                }
                
                var dice2 = dicevalue - dice1
                dice2 = dice2 == 0 ? 1 : dice2
                self.dice1Image.image = UIImage(named: "dots_\(dice1)")
                self.dice2Image.image = UIImage(named: "dots_\(dice2)")
            }
        }
    }
}

// MARK: API
extension SevenUpDownViewController {
    
    private func placeBet(_ type: Int) {
        DispatchQueue.global(qos: .background).async {
            self.betPlaces.append("\(type)")
            APIClient.shared.post(parameters: DNTPlaceBetRequest(game_id: self.game_id, bet: "\(type)", amount: "\(self.placeGameAmount)"), feed: .SevenUp_place_bet, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse?.data {
                        if let mydragonbet = response["bet_id"].int {
                            bet_id = "\(mydragonbet)"
                        } else if let mydragonbet = response["bet_id"].string {
                            bet_id = mydragonbet
                        }
                        self.walletBalLbl.text = response["wallet"].stringValue
                    }
                    if let code = apiResponse?.code, code == 200 {
                        Toast.makeToast("Bet has been added successfully!")
                    } else if var message = apiResponse?.message, !message.isEmpty {
                        Toast.makeToast(message)
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
            APIClient.shared.post(parameters: GameSevenUDRequest(total_bet_up: "\(self.all_up_bet)", total_bet_down: "\(self.all_down_bet)", total_bet_tie: "\(self.all_tie_bet)"), feed: .SevenUp_get_active_game, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let responseCode = apiResponse?.code, responseCode == 407 {
                        self.dismiss(animated: true)
                    } else if let response = apiResponse?.data, apiResponse?.code == 200 {
//                        print("Response: \(response)")
                        
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
                        
                        var gameStatus = -1
                        var my_up_bet = 0
                        var my_down_bet = 0
                        var my_tie_bet = 0
                        winnerId = -1
                        self.twoSixBetLabel.text = " " // Down
                        self.sevenBetLabel.text = " " // Tie
                        self.eightTwelBetLabel.text = " " // Up
                        
                        self.twoSixTotalLabel.text = " "
                        self.sevenTotalLabel.text = " "
                        self.eightTweTotalLabel.text = " "
                        if let myupbet = response["my_up_bet"].int {
                            my_up_bet = myupbet
                        } else if let myupbet = response["my_up_bet"].string {
                            my_up_bet = Int(myupbet) ?? 0
                        }
                        if let mydownbet = response["my_down_bet"].int {
                            my_down_bet = mydownbet
                        } else if let mydownbet = response["my_down_bet"].string {
                            my_down_bet = Int(mydownbet) ?? 0
                        }
                        if let mytiebet = response["my_tie_bet"].int {
                            my_tie_bet = mytiebet
                        } else if let mytiebet = response["my_tie_bet"].string {
                            my_tie_bet = Int(mytiebet) ?? 0
                        }
                        
                        if my_down_bet > 0 {
                            self.twoSixBetLabel.text = "\(my_down_bet)"
                        }
                        if my_tie_bet > 0 {
                            self.sevenBetLabel.text = "\(my_tie_bet)"
                        }
                        if my_up_bet > 0 {
                            self.eightTwelBetLabel.text = "\(my_up_bet)"
                        }
                        
                        all_up_bet = 0
                        all_down_bet = 0
                        all_tie_bet = 0
                        if let upbet = response["up_bet"].int {
                            all_up_bet = upbet
                        } else if let upbet = response["up_bet"].string {
                            all_up_bet = Int(upbet) ?? 0
                        }
                        if let downbet = response["down_bet"].int {
                            all_down_bet = downbet
                        } else if let downbet = response["down_bet"].string {
                            all_down_bet = Int(downbet) ?? 0
                        }
                        if let tiebet = response["tie_bet"].int {
                            all_tie_bet = tiebet
                        } else if let tiebet = response["tie_bet"].string {
                            all_tie_bet = Int(tiebet) ?? 0
                        }
                        
                        self.twoSixTotalLabel.text = ""
                        self.sevenTotalLabel.text = ""
                        self.eightTweTotalLabel.text = ""

                        lastWinList = [LastWinningsModel]()
                        
                        if let lastWinnings = response["last_winning"].array, lastWinnings.count > 0 {
                            lastWinnings.forEach { object in
                                lastWinList.append(LastWinningsModel(object))
                            }
                            self.collectionResultView.reloadData()
                        }
                        
                        if let gameArrayData = response["game_data"].array, gameArrayData.count > 0 {
                            let gameDataModel = ABGGameData(gameArrayData[0])
//                            self.cardImage.image = UIImage(named: gameDataModel.main_card)
                            gameStatus = gameDataModel.status
                            timeRemaining = gameDataModel.time_remaining
                            game_id = gameDataModel.id
                            winnerId = gameDataModel.winning
                        }
                        
                        if let profileArrayData = response["profile"].array, profileArrayData.count > 0 {
                            let profileDataModel = ProfileData(profileArrayData[0])
                            self.usernameLbl.text = profileDataModel.name
                            self.profileImage.sd_setImage(with: URL(string: profileDataModel.profile_pic), placeholderImage: UIImage(named: "avatar"), context: [:])
                            self.walletBalLbl.text = profileDataModel.wallet.cleanValue2
                        }
                        
//                        if gameStatus == 0 {
//                            if totalBetAndar > 0 {
//                                self.andarMainLabel.text = "\(totalBetAndar)"
//                            }
//                            if totalBetBahar > 0 {
//                                self.baharMainLabel.text = "\(totalBetBahar)"
//                            }
//                        }
                        if gameStatus == 0 && !isGameBegning {
//                            if cardTimer.isValid {
//                                cardTimer.invalidate()
//                            }
                            restartGame()
                            if timeRemaining > 0 {
                                self.betStartImage.isHidden = false
                                setGameTimer()
                                if all_down_bet > 0 {
                                    self.twoSixTotalLabel.text = "\(all_down_bet)"
                                }
                                if all_tie_bet > 0 {
                                    self.sevenTotalLabel.text = "\(all_tie_bet)"
                                }
                                if all_up_bet > 0 {
                                    self.eightTweTotalLabel.text = "\(all_up_bet)"
                                }
                            } else {
                                gameStartTimer.invalidate()
                                gameStartTimer.invalidate()
                            }
                        } else if gameStatus == 0 && isGameBegning {
                            if all_down_bet > 0 {
                                self.twoSixTotalLabel.text = "\(all_down_bet)"
                            }
                            if all_tie_bet > 0 {
                                self.sevenTotalLabel.text = "\(all_tie_bet)"
                            }
                            if all_up_bet > 0 {
                                self.eightTweTotalLabel.text = "\(all_up_bet)"
                            }
                        }
                        
                        if gameStatus == 1 && !isGameBegning {
                            self.pleaseWaitLabel.isHidden = false
                        }
                        if gameStatus == 1 && isGameBegning {
                            isGameBegning = false
                            self.betStartImage.isHidden = true
                            self.betEndImage.isHidden = false
                            allCardsArray = [String]()
                            if let cardsArray = response["game_cards"].array, cardsArray.count > 0 {
                                self.timerLabel.text = "0"
                                delay(2) {
                                    cardsArray.forEach { object in
                                        self.allCardsArray.append(object["card"].stringValue.lowercased())
                                    }
                                    self.betEndImage.isHidden = true
                                    self.gameStartTimer.invalidate()
                                    self.showDiceViewAndAnimate()
                                    self.delay(Double((self.allCardsArray.count + 2))) {
                                        let isWin = self.betPlaces.contains("\(self.winnerId)")
                                        for vv in self.aniSubView1.subviews {
                                            if vv.tag == 9999 {
                                                vv.removeFromSuperview()
                                            }
                                        }
                                        for vv in self.aniSubView2.subviews {
                                            if vv.tag == 9999 {
                                                vv.removeFromSuperview()
                                            }
                                        }
                                        for vv in self.aniSubView3.subviews {
                                            if vv.tag == 9999 {
                                                vv.removeFromSuperview()
                                            }
                                        }
                                        self.makeWinner(isWin)
    //                                    self.andarHighlightedView.isHidden = winning != "0"
    //                                    self.baharHighlightedView.isHidden = winning == "0"
                                    }
                                }
                            }
                        }
                        self.pleaseWaitLabel.isHidden = gameStatus != 1
                    } else if let message = apiResponse?.message {
                        Toast.makeToast(message)
                    }
                    break
                case .failure(_):
                    break
                }
            }
        }
    }
    
    private func restartGame() {
        self.betPlaces = [String]()
        for vv in self.aniSubView1.subviews {
            if vv.tag == 9999 {
                vv.removeFromSuperview()
            }
        }
        for vv in self.aniSubView2.subviews {
            if vv.tag == 9999 {
                vv.removeFromSuperview()
            }
        }
        for vv in self.aniSubView3.subviews {
            if vv.tag == 9999 {
                vv.removeFromSuperview()
            }
        }
        self.twoSixCoinView.isHidden = true
        self.sevenCoinView.isHidden = true
        self.eightTwelCoinView.isHidden = true
        isGameBegning = true
    }
    
    private func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
}

extension SevenUpDownViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.betCollectionView {
            return coinsDataList.count
        }
        if collectionView == self.collectionResultView {
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
        if (collectionView == self.collectionResultView || collectionView == self.betCollectionView), let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView == self.collectionResultView ? DNTCollectionViewCell.lastBetCell : DNTCollectionViewCell.betCell, for: indexPath) as? DNTCollectionViewCell {
            if collectionView == self.collectionResultView {
                cell.configureLast(lastWinList[indexPath.row], gameType: .seven_up_down)
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

extension SevenUpDownViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == betCollectionView {
            self.placeGameAmount = coinsDataList[indexPath.row]
            self.betCollectionView.reloadData()
        }
    }
}

// MARK: Alert Prompt Delegate
extension SevenUpDownViewController: PromptViewDelegate {
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
