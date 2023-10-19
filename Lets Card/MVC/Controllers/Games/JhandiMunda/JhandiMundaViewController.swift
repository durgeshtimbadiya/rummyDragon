//
//  JhandiMundaViewController.swift
//  Lets Card
//
//  Created by Durgesh on 30/05/23.
//

import UIKit

class JhandiMundaViewController: UIViewController {

    @IBOutlet weak var profileBottomView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var walletBalLbl: UILabel!
    @IBOutlet weak var betCollectionView: UICollectionView!
    
    
    @IBOutlet weak var battingLabel: UILabel!
    @IBOutlet weak var otherUserView: UIStackView!
    @IBOutlet weak var otherUserLabel: UILabel!
    
    @IBOutlet weak var betEndImage: UIImageView!
    
    @IBOutlet weak var leftPlayerCollectionView: UICollectionView!
    @IBOutlet weak var rightPlayerCollectionView: UICollectionView!
    
    @IBOutlet weak var pleaseWaitView: UIView!
    
    @IBOutlet weak var gameMainView: UIView!
    @IBOutlet weak var gameMainStackView: UIStackView!
    @IBOutlet weak var gameSubView1: UIStackView!
    @IBOutlet weak var gameSubView2: UIStackView!
    
    @IBOutlet var gameComponentsViews: [UIView]!
    @IBOutlet var addedAmtLabels: [UILabel]!
    @IBOutlet var selectAmtLabels: [UILabel]!
    @IBOutlet var winnerImageViews: [UIImageView]!
    
    @IBOutlet weak var girlGifImageView: UIImageView!
    @IBOutlet weak var diceImageView: UIImageView!
    
    private var coinsDataList = [10, 50, 100, 1000, 5000]
    
    private var placeGameAmount = 0

    private var isCardsDisribute = false
    private var winnerId = -1
    private var lastWinList = [LastWinningsModel]()
    private var botUsers = [HeadTailBotModel]()
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
    
    private var heart_amount = 0
    private var spade_amount = 0
    private var diamond_amount = 0
    private var club_amount = 0
    private var face_amount = 0
    private var flag_amount = 0
    
    private let HEART = "HEART"
    private let SPADE = "SPADE"
    private let DIAMOND = "DIAMOND"
    private let CLUB = "CLUB"
    private let FACE = "FACE"
    private let FLAG = "FLAG"
    
    private let HEART_VALUE = 1
    private let SPADE_VALUE = 2
    private let DIAMOND_VALUE = 3
    private let CLUB_VALUE = 4
    private let FACE_VALUE = 5
    private let FLAG_VALUE = 6
    
    private var HEART_WINCOUNT = 0
    private var SPADE_WINCOUNT = 0
    private var DIAMOND_WINCOUNT = 0
    private var CLUB_WINCOUNT = 0
    private var FACE_WINCOUNT = 0
    private var FLAG_WINCOUNT = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        girlGifImageView.image = UIImage.gif(name: "girl_char_seven")
        betEndImage.isHidden = true
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
        self.placeBet(sender.tag + 1)
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
            self.delay(1.0) { [self] in
                self.setWinningView()
                self.gameStartTimer.invalidate()
                self.cardDistributeTimer.invalidate()
            }
            return
        }
        if allCardsArray.count > 2 {
           setDiceType(allCardsArray[cardDistributeCount])
        }
        cardDistributeCount += 1
    }
    
    private func makeDummyAnimation() {
        for i in 0..<self.gameComponentsViews.count {
            var imageNameArray = [10, 50, 100, 1000, 5000, 10, 50, 100]

            let stackViewX = i > 2 ? self.gameSubView2.frame.origin.x : self.gameSubView1.frame.origin.x
            let stackViewY = i > 2 ? self.gameSubView2.frame.origin.y : self.gameSubView1.frame.origin.y
            
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
    
    @objc private func pleaseWaitAnimation(_ imageView: UIImageView) {
        imageView.alpha = 0.0
        UIView.animate(withDuration: 1.0) {
            imageView.alpha = 1.0
        } completion: { st in
            self.pleaseWaitAnimation(imageView)
        }
    }
    
    private func setWinningView() {
        let winingMax = 1
        self.gameComponentsViews.forEach { cView in
            switch cView.tag + 1 {
            case HEART_VALUE:
                if HEART_WINCOUNT > winingMax {
                    self.winnerImageViews[cView.tag].isHidden = false
                }
                break
            case SPADE_VALUE:
                if SPADE_WINCOUNT > winingMax {
                    self.winnerImageViews[cView.tag].isHidden = false
                }
                break
            case DIAMOND_VALUE:
                if DIAMOND_WINCOUNT > winingMax {
                    self.winnerImageViews[cView.tag].isHidden = false
                }
                break
            case CLUB_VALUE:
                if CLUB_WINCOUNT > winingMax {
                    self.winnerImageViews[cView.tag].isHidden = false
                }
                break
            case FACE_VALUE:
                if FACE_WINCOUNT > winingMax {
                    self.winnerImageViews[cView.tag].isHidden = false
                }
                break
            case FLAG_VALUE:
                if FLAG_WINCOUNT > winingMax {
                    self.winnerImageViews[cView.tag].isHidden = false
                }
                break
            default:
                break
            }
        }
        
        delay(3.0) {
            for vv in self.gameMainView.subviews {
                if vv.tag == 9999 || vv.tag == 99992 {
                    vv.removeFromSuperview()
                }
            }
            self.winnerImageViews.forEach { imageV in
                imageV.isHidden = true
            }
            self.isCardsDisribute = false
        }
        
//        let delayTime = 0.3
//        var count = 0
//        _ = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: true){ t in
//            count += 1
//            if count >= 10 {
//                for vv in self.gameMainView.subviews {
//                    if vv.tag == 9999 || vv.tag == 99992 {
//                        vv.removeFromSuperview()
//                    }
//                }
//                self.winnerImageViews.forEach { imageV in
//                    imageV.isHidden = true
//                }
//                t.invalidate()
//                self.isCardsDisribute = false
//            }
//        }
    }

    private func setDiceType(_ diceValue: String = "") {
        if let diceTypeInt = Int(diceValue) {
            var diceImageName = ""
            switch diceTypeInt {
            case HEART_VALUE:
                HEART_WINCOUNT += 1
                diceImageName = "dic_heart"
                break
            case SPADE_VALUE:
                SPADE_WINCOUNT += 1
                diceImageName = "dic_spade"
                break
            case DIAMOND_VALUE:
                DIAMOND_WINCOUNT += 1
                diceImageName = "dic_diamond"
                break
            case CLUB_VALUE:
                CLUB_WINCOUNT += 1
                diceImageName = "dic_club"
                break
            case FACE_VALUE:
                FACE_WINCOUNT += 1
                diceImageName = "dic_face"
                break
            case FLAG_VALUE:
                FLAG_WINCOUNT += 1
                diceImageName = "dic_flag"
                break
            default:
                break
            }
            
            let i = diceTypeInt - 1
            if i >= 0 {
                let imageView = UIImageView(image: UIImage(named: diceImageName))
                imageView.frame = CGRect(x: self.diceImageView.frame.origin.x + 20.0, y: self.diceImageView.frame.origin.y + 20.0, width: 96.0, height: 96.0)
                imageView.isUserInteractionEnabled = false
                imageView.tag = 99992
                self.gameMainView.addSubview(imageView)
                
                let stackViewX = i > 2 ? self.gameSubView2.frame.origin.x : self.gameSubView1.frame.origin.x
                let stackViewY = i > 2 ? self.gameSubView2.frame.origin.y : self.gameSubView1.frame.origin.y
                
                let originX = (self.gameMainStackView.frame.origin.x + stackViewX + self.gameComponentsViews[i].frame.origin.x) + 10.0
                let originY = (self.gameMainStackView.frame.origin.y + stackViewY + self.gameComponentsViews[i].frame.origin.y) + 10.0
                let yPlus = self.gameComponentsViews[i].frame.height - 50.0
                let xPlus = self.gameComponentsViews[i].frame.width - 50.0

                let originalAniRect = CGRect(x: CGFloat.random(in: originX...originX + xPlus), y: CGFloat.random(in: originY...originY + yPlus), width: 50.0, height: 50.0)
                
                UIView.animate(withDuration: 1) {
                    imageView.frame = originalAniRect
                } completion: { s in }
            }
        }
    }
}

extension JhandiMundaViewController {
    private func placeBet(_ tagIndex: Int) {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: ColourPredBetRequest(game_id: self.game_id, bet:  "\(tagIndex + 1)", amount: "\(self.placeGameAmount)"), feed: .JhMunda_place_bet, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse?.data, apiResponse?.code == 200 {
                        self.walletBalLbl.text = response["wallet"].stringValue
                        if let selectAmt = Int(self.selectAmtLabels[tagIndex - 1].text ?? "0") {
                            self.selectAmtLabels[tagIndex - 1].text = "\(selectAmt + self.placeGameAmount)"
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
            APIClient.shared.post(parameters: GameJhandiMundaRequest(total_bet_flag: "\(flag_amount)", total_bet_face: "\(face_amount)", total_bet_club: "\(club_amount)", total_bet_diamond: "\(diamond_amount)", total_bet_spade: "\(spade_amount)", total_bet_heart: "\(heart_amount)"), feed: .JhMunda_get_active_game, showLoading: false, responseKey: "all") { [self] result in
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
                                self.setGameTimer()
                            } else {
                                gameStartTimer.invalidate()
                            }
                        } else if gameStatus == "0" && isGameBegning {
                            flag_amount = 0
                            face_amount = 0
                            club_amount = 0
                            diamond_amount = 0
                            spade_amount = 0
                            heart_amount = 0
                            
                            self.gameComponentsViews.forEach { gameView in
                                switch gameView.tag {
                                case 0:
                                    //Heart
                                    if let amount = response["heart_amount"].int {
                                        heart_amount = amount
                                    } else if let amount = response["heart_amount"].string {
                                        heart_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(heart_amount)"
                                    break
                                case 1:
                                    //Spade
                                    if let amount = response["spade_amount"].int {
                                        spade_amount = amount
                                    } else if let amount = response["spade_amount"].string {
                                        spade_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(spade_amount)"
                                    break
                                case 2:
                                    //Diamond
                                    if let amount = response["diamond_amount"].int {
                                        diamond_amount = amount
                                    } else if let amount = response["diamond_amount"].string {
                                        diamond_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(diamond_amount)"
                                    break
                                case 3:
                                    //Club
                                    if let amount = response["club_amount"].int {
                                        club_amount = amount
                                    } else if let amount = response["club_amount"].string {
                                        club_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(club_amount)"
                                    break
                                case 4:
                                    //Face
                                    if let amount = response["face_amount"].int {
                                        face_amount = amount
                                    } else if let amount = response["face_amount"].string {
                                        face_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(face_amount)"
                                    break
                                case 5:
                                    //Flag
                                    if let amount = response["flag_amount"].int {
                                        flag_amount = amount
                                    } else if let amount = response["flag_amount"].string {
                                        flag_amount = Int(amount) ?? 0
                                    }
                                    addedAmtLabels[gameView.tag].text = "\(flag_amount)"
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
                            self.isCardsDisribute = true
                            isGameBegning = false
                            self.betEndImage.image = UIImage(named: "iv_bet_stops")
                            self.betEndImage.isHidden = false
                            self.betEndImage.frame.size.height = 0.0
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
        HEART_WINCOUNT = 0
        SPADE_WINCOUNT = 0
        DIAMOND_WINCOUNT = 0
        CLUB_WINCOUNT = 0
        FACE_WINCOUNT = 0
        FLAG_WINCOUNT = 0
        
        self.pleaseWaitView.isHidden = true

        self.winnerImageViews.forEach { imageV in
            imageV.isHidden = true
        }
        for vv in self.gameMainView.subviews {
            if vv.tag == 9999 || vv.tag == 99992 {
                vv.removeFromSuperview()
            }
        }
    }
    
    private func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
}

extension JhandiMundaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.betCollectionView {
            return coinsDataList.count
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

extension JhandiMundaViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.betCollectionView == collectionView  {
            self.placeGameAmount = coinsDataList[indexPath.row]
            self.betCollectionView.reloadData()
        }
    }
}


// MARK: Alert Prompt Delegate
extension JhandiMundaViewController: PromptViewDelegate {
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
