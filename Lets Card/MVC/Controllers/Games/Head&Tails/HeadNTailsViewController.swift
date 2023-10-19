//
//  HeadNTailsViewController.swift
//  Lets Card
//
//  Created by Durgesh on 01/05/23.
//

import UIKit
import GLKit

class HeadNTailsViewController: UIViewController {
    
    @IBOutlet weak var profileBottomView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var walletBalLbl: UILabel!
    @IBOutlet weak var betCollectionView: UICollectionView!
    
    @IBOutlet weak var resultCollectionView: UICollectionView!

    @IBOutlet weak var battingLabel: UILabel!
    @IBOutlet weak var otherUserView: UIStackView!
    @IBOutlet weak var otherUserLabel: UILabel!
    
    @IBOutlet weak var headAddedAmount: UILabel!
    @IBOutlet weak var headTotalAmount: UILabel!
    
    @IBOutlet weak var tailAddedAmount: UILabel!
    @IBOutlet weak var tailTotalAmount: UILabel!
    
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var tailView: UIView!
    @IBOutlet weak var gameMainView: UIView!
    @IBOutlet weak var gameStackView: UIStackView!
    @IBOutlet weak var headStackView: UIStackView!
    @IBOutlet weak var tailStackView: UIStackView!
    
    @IBOutlet weak var betEndImage: UIImageView!
    
    @IBOutlet weak var headAniView: UIView!
    @IBOutlet weak var tailAniView: UIView!
    
    @IBOutlet weak var winningCoinView: UIView!
    @IBOutlet weak var flipCoinImage: UIImageView!
    @IBOutlet weak var flipCoinImageHeight: NSLayoutConstraint!
    @IBOutlet weak var flipCoinImageWidth: NSLayoutConstraint!

    @IBOutlet weak var leftPlayerCollectionView: UICollectionView!
    @IBOutlet weak var rightPlayerCollectionView: UICollectionView!
    
    private var coinsDataList = [10, 50, 100, 1000, 5000]
    
    private var placeGameAmount = 0

    private var isCardsDisribute = false
    private var winnerId = -1
    private var lastWinList = [LastWinningsModel]()
    private var botUsers = [HeadTailBotModel]()
    private var game_id = ""
    private var timeRemaining = 0
    private var isGameBegning = false
    private var canbet = false
    private var added_date = ""
    private var allCardsArray = [String]()
    private var isBetStarted = false
    private var isBotPlayerSet = false

    private var timerStatus = Timer()
    private var gameStartTimer = Timer()

    private var dragon_bet = 0
    private var tiger_bet = 0
    private var tie_bet = 0
    
    private var mBetsOn = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        betEndImage.isHidden = true
        self.winningCoinView.isHidden = true
        self.headStackView.isHidden = true
        self.tailStackView.isHidden = true
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
    }
    
    private func flipImageView(imageView: UIImageView, toImage: UIImage, duration: TimeInterval, delay: TimeInterval = 0)
    {
        let t = duration / 2

        UIView.animate(withDuration: t, delay: delay, options: .curveEaseIn, animations: { () -> Void in

            // Rotate view by 90 degrees
            let p = CATransform3DMakeRotation(CGFloat(GLKMathDegreesToRadians(90)), 1.0, 0.0, 0.0)
            imageView.layer.transform = p

        }, completion: { (Bool) -> Void in

            // New image
            imageView.image = toImage

            // Rotate view to initial position
            // We have to start from 270 degrees otherwise the image will be flipped (mirrored) around Y axis
            let p = CATransform3DMakeRotation(CGFloat(GLKMathDegreesToRadians(270)), 1.0, 0.0, 0.0)
            imageView.layer.transform = p

            UIView.animate(withDuration: t, delay: 0, options: .curveEaseOut, animations: { () -> Void in

                // Back to initial position
                let p = CATransform3DMakeRotation(CGFloat(GLKMathDegreesToRadians(0)), 1.0, 0.0, 0.0)
                imageView.layer.transform = p

            }, completion: { (Bool) -> Void in
            })
        })
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
        }
        if timeRemaining < 0 {
            if gameStartTimer.isValid {
                gameStartTimer.invalidate()
            }
            self.battingLabel.isHidden = true
            canbet = false
            return
        }
        self.battingLabel.isHidden = false
        self.battingLabel.text = "\(timeRemaining).0s"
        self.makeDummyAnimation()
    }
    
    private func makeDummyAnimation() {
        let originalAniRect = CGRect(x: self.headView.frame.origin.x + self.gameStackView.frame.origin.x + 10.0, y: self.headView.frame.origin.y + self.gameStackView.frame.origin.y + 5, width: self.headView.frame.size.width, height: self.headView.frame.size.height)
        let originalAniRect1 = CGRect(x: self.tailView.frame.origin.x + self.gameStackView.frame.origin.x + 10.0, y: self.tailView.frame.origin.y + self.gameStackView.frame.origin.y + 5, width: self.tailView.frame.size.width, height: self.tailView.frame.size.height)

        //self.animationView.frame = CGRect(x: self.otherUserView.frame.origin.x, y: self.otherUserView.frame.origin.y + 10.0, width: 20.0, height: 20.0)
        
        let myNewAniView = UIView(frame: CGRect(x: self.otherUserView.frame.origin.x, y: self.otherUserView.frame.origin.y - 20.0, width: 20.0, height: 20.0))
        myNewAniView.tag = 9999
        myNewAniView.isUserInteractionEnabled = false
        let myAniSubView1 = UIView(frame: self.headAniView.frame)
//        let myAniSubView2 = UIView(frame: self.tailAniView.frame)
        myAniSubView1.isUserInteractionEnabled = false
//        myAniSubView2.isUserInteractionEnabled = false
        myNewAniView.addSubview(myAniSubView1)
//        myNewAniView.addSubview(myAniSubView2)
//        myNewAniView.backgroundColor = .black
        myNewAniView.clipsToBounds = true
        self.gameMainView.addSubview(myNewAniView)
        
        let myNewAniView1 = UIView(frame: CGRect(x: self.otherUserView.frame.origin.x, y: self.otherUserView.frame.origin.y - 20.0, width: 20.0, height: 20.0))
        myNewAniView1.tag = 9999
        myNewAniView1.isUserInteractionEnabled = false
        let myAniSubView2 = UIView(frame: self.tailAniView.frame)
        myAniSubView2.isUserInteractionEnabled = false
        myNewAniView1.addSubview(myAniSubView2)
        myNewAniView.clipsToBounds = true
        self.gameMainView.addSubview(myNewAniView1)

        var imageNameArray = [10, 50, 100, 1000, 5000]
        //imageNameArray.randomElement()
        var xFrom = 0.0
        var xTo = 20.0
        
        for _ in 0..<7 {
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                let imageView = UIImageView(image: UIImage(named: "ic_coin_\(rndNumber)_dt")) // 10, 50, 100, 1000, 5000
                imageView.frame = CGRect(x: CGFloat.random(in: xFrom...xTo), y: 10.0, width: 20.0, height: 20.0)
                imageView.isUserInteractionEnabled = false
                myAniSubView1.addSubview(imageView)
                xFrom += 20.0
                xTo += 20.0
            }
        }
        imageNameArray = [10, 50, 100, 1000, 5000]
        xFrom = 0.0
        xTo = 20.0
        for _ in 0..<7 {
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                let imageView = UIImageView(image: UIImage(named: "ic_coin_\(rndNumber)_dt")) // 10, 50, 100, 1000, 5000
                imageView.frame = CGRect(x: CGFloat.random(in: xFrom...xTo), y: 10.0, width: 20.0, height: 20.0)
                imageView.isUserInteractionEnabled = false
                myAniSubView2.addSubview(imageView)
                xFrom += 20.0
                xTo += 20.0
            }
        }

        UIView.animate(withDuration: 1) {
            myNewAniView.frame = originalAniRect
            myNewAniView1.frame = originalAniRect1
        } completion: { s in
            myNewAniView.clipsToBounds = false
            myNewAniView1.clipsToBounds = false
        }
    }
    
    private func flipCoinWinner(_ isMeWinner: Bool) {
        let delayTime1 = 0.2
        var count1 = 0
        self.winningCoinView.isHidden = false
        _ = Timer.scheduledTimer(withTimeInterval: delayTime1, repeats: true){ t1 in
            self.flipImageView(imageView: self.flipCoinImage, toImage: UIImage(named: count1 % 2 == 0 ? "tails" : "heads")!, duration: delayTime1)
            self.flipCoinImageHeight.constant += 10.0
            self.flipCoinImageWidth.constant += 10.0
            count1 += 1
            if count1 >= 10 {
                t1.invalidate()
                Toast.makeToast(self.winnerId == 1 ? "Tail wins!" : "Head wins!")
                self.delay(0.2) {
                    self.flipCoinImageHeight.constant = 150.0
                    self.flipCoinImageWidth.constant = 150.0
                    self.flipImageView(imageView: self.flipCoinImage, toImage: UIImage(named: self.winnerId == 1 ? "tails" : "heads")!, duration: delayTime1)
                    self.delay(2) {
                        self.winningCoinView.isHidden = true
                        self.makeWinner(isMeWinner)
                    }
                }
            }
        }
    }
    
    private func makeWinner(_ isMeWinner: Bool) {
        let delayTime1 = 0.1
        var count1 = 0
        _ = Timer.scheduledTimer(withTimeInterval: delayTime1, repeats: true){ t1 in
            self.makeWinnerDummyAnimation(isMeWinner)
            count1 += 1
            if count1 >= 10 {
                t1.invalidate()
                self.restartGame()
            }
        }
    }
    
    private func makeWinnerDummyAnimation(_ isMeWinner: Bool) {
        let originalAniRect = isMeWinner ? CGRect(x: self.profileBottomView.frame.origin.x + 40.0, y: self.profileBottomView.frame.origin.y + 16.0, width: 100.0, height: 100.0) : CGRect(x: self.otherUserView.frame.origin.x, y: self.otherUserView.frame.origin.y, width: 20.0, height: 20.0)

        let myNewAndarAniView = winnerId == 0 ? UIView(frame: CGRect(x:  self.gameStackView.frame.origin.x + (headView.frame.size.width / 2.0) - 10.0, y: self.gameStackView.frame.origin.y + (headView.frame.size.height / 2.0) - 20.0, width: 50.0, height: 20.0)) : UIView(frame: CGRect(x: self.gameStackView.frame.origin.x + self.tailView.frame.origin.x + (tailView.frame.size.width / 2.0) - 10.0, y: self.gameStackView.frame.origin.y + (tailView.frame.size.height / 2.0) - 20.0, width: 50.0, height: 20.0))

        myNewAndarAniView.tag = 9998
        myNewAndarAniView.isUserInteractionEnabled = false
        myNewAndarAniView.clipsToBounds = false

        self.gameMainView.addSubview(myNewAndarAniView)
        for _ in 0..<2 {
                let imageView = UIImageView(image: UIImage(named: "ic_dt_chips"))
                imageView.frame = CGRect(x: CGFloat.random(in: 0...50), y: CGFloat.random(in: 0...20), width: 15.0, height: 15.0)
                imageView.isUserInteractionEnabled = false
                myNewAndarAniView.addSubview(imageView)
        }

        UIView.animate(withDuration: 1) {
            myNewAndarAniView.frame = originalAniRect
        } completion: { s in
            myNewAndarAniView.removeFromSuperview()
        }
    }
    
    
    @IBAction func tapOnBackButton(_ sender: UIButton) {
        PromptVManager.present(self, titleString: "CONFIRMATOIN", messageString: "Are you sure, you want to Leave ?", viewTag: 1)
    }
    
    @IBAction func tapOnInfoButton(_ sender: UIButton) {
        if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: DialogInfoViewController().className) as? DialogInfoViewController {
            myObject.gameType = GameTypes.head_tails
            myObject.isInformationView = true
            self.navigationController?.present(myObject, animated: true)
        }
    }
    
    @IBAction func tapOnAddChips(_ sender: UIButton) {
        
    }
    
    @IBAction func tapOnPlaceBet(_ sender: UIButton) {
        // 0 - Head
        // 1 - Tail
        if placeGameAmount <= 0 {
            Toast.makeToast("First Select Bet amount")
            return
        }
        self.placeBet(sender.tag)
    }
}

extension HeadNTailsViewController {
    private func placeBet(_ tagIndex: Int) {
        DispatchQueue.global(qos: .background).async {
            self.mBetsOn.append("\(tagIndex)")
            DispatchQueue.main.async {
                if tagIndex == 0 {
                    self.headStackView.isHidden = false
                }
                if tagIndex == 1 {
                    self.tailStackView.isHidden = false
                }
            }
            
            APIClient.shared.post(parameters: ColourPredBetRequest(game_id: self.game_id, bet:  "\(tagIndex)", amount: "\(self.placeGameAmount)"), feed: .HeadT_place_bet, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse?.data, apiResponse?.code == 200 {
                        self.walletBalLbl.text = response["wallet"].stringValue
                    } else if let message = apiResponse?.message, !message.isEmpty {
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
        if isCardsDisribute {
            return
        }
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameDNTRequest(total_bet_dragon: "\(self.dragon_bet)", total_bet_tiger: "\(self.tiger_bet)", total_bet_tie: "\(self.tie_bet)"), feed: .HeadT_get_active_game, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let responseCode = apiResponse?.code, responseCode == 407 {
                        self.dismiss(animated: true)
                    } else if let response = apiResponse?.data {
//                        print("Response: \(response)")
                        headAddedAmount.text = " "
                        tailAddedAmount.text = " "
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
                        if let mydragonbet = response["my_dragon_bet"].int, mydragonbet > 0 {
                            headAddedAmount.text = "\(mydragonbet)"
                        } else if let mydragonbet = response["my_dragon_bet"].string {
                            headAddedAmount.text = mydragonbet
                        }
                        if let mytigerbet = response["my_tiger_bet"].int {
                            tailAddedAmount.text = "\(mytigerbet)"
                        } else if let mytigerbet = response["my_tiger_bet"].string {
                            tailAddedAmount.text = mytigerbet
                        }
//                        if let mytiebet = response["my_tie_bet"].int {
//                            myTieBetLbl.text = "\(mytiebet)"
//                        } else if let mytiebet = response["my_tie_bet"].string {
//                            myTieBetLbl.text = mytiebet
//                        }
                        
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
                            otherUserLabel.text = "\(online)"
                        } else if let online = response["online"].string {
                            otherUserLabel.text = online
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
                                    winnerId = win
                                } else if let win = gameData["winning"].string {
                                    winnerId = Int(win) ?? -1
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
                                game_id = gameData["id"].stringValue
                            }
                        }
                        
                        if dragon_bet > 0 {
                            self.headTotalAmount.text = "\(dragon_bet)"
                        }
                        if tiger_bet > 0 {
                            self.tailTotalAmount.text = "\(tiger_bet)"
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
                            }
                        }
                       // self.pleaseWaitLabel.isHidden = true
                        if gameStatus == "1" && !isGameBegning {
//                            self.pleaseWaitLabel.isHidden = false
                        }
                        //iv_bet_begin, iv_bet_stops
                        if gameStatus == "1" && isGameBegning {
                            isGameBegning = false
                            self.betEndImage.isHidden = false
                            self.betEndImage.frame.size.height = 0.0
                            UIView.transition(with: self.betEndImage, duration: 1, options: .curveEaseInOut) {
                                self.betEndImage.frame.size.height = 33.0
                                self.delay(2) { [self] in
                                    self.betEndImage.isHidden = true
                                    if let gameCards = response["game_cards"].array, gameCards.count > 0 {
                                        // Cancel game timer
                                        isBetStarted = false
                                        isCardsDisribute = true
                                        let isMeWin = mBetsOn.contains("\(winnerId)")
                                        self.flipCoinWinner(isMeWin)
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
        isCardsDisribute = false
        self.dragon_bet = 0
        self.tiger_bet = 0
        self.tie_bet = 0
        self.headStackView.isHidden = true
        self.tailStackView.isHidden = true
        mBetsOn = [String]()
        self.betCollectionView.reloadData()
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

extension HeadNTailsViewController: UICollectionViewDataSource {
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
            cell.configureLast(lastWinList[indexPath.row], gameType: .head_tails)
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

extension HeadNTailsViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 25.0, height: 25.0)
//    }
}

extension HeadNTailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.betCollectionView == collectionView  {
            self.placeGameAmount = coinsDataList[indexPath.row]
            self.betCollectionView.reloadData()
        }
    }
}


// MARK: Alert Prompt Delegate
extension HeadNTailsViewController: PromptViewDelegate {
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
