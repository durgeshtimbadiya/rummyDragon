//
//  AndarBaharViewController.swift
//  Lets Card
//
//  Created by Durgesh on 15/03/23.
//

import UIKit

class AndarBaharViewController: UIViewController {
    
    @IBOutlet weak var waitingBetImages: UIImageView!
    @IBOutlet weak var placeBetImages: UIImageView!
    @IBOutlet weak var andarCollectionView: UICollectionView!
    @IBOutlet weak var baharCollectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var andarMainLabel: UILabel!
    @IBOutlet weak var baharMainLabel: UILabel!
    @IBOutlet weak var betEndImage: UIImageView!
    
    @IBOutlet weak var andarAmountLabel: UILabel!
    @IBOutlet weak var baharAmountLabel: UILabel!
    
    @IBOutlet weak var leftPlayerCollectionView: UICollectionView!
    @IBOutlet weak var rightPlayerCollectionView: UICollectionView!
    
    @IBOutlet weak var andarBetButton: UIButton!
    @IBOutlet weak var baharBetButton: UIButton!
    
    @IBOutlet weak var andarHighlightedView: UIView!
    @IBOutlet weak var baharHighlightedView: UIView!
    @IBOutlet weak var andarCircleImage: UIImageView!
    @IBOutlet weak var baharCircleImage: UIImageView!
    @IBOutlet weak var otherUserView: UIView!
    
    @IBOutlet weak var profileBottomView: UIView!
    @IBOutlet weak var profileBottomView1: UIView!
    @IBOutlet weak var profileBottomView2: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var walletBalLbl: UILabel!
    @IBOutlet weak var betCollectionView: UICollectionView!
    
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var aniSubView1: UIView!
    @IBOutlet weak var aniSubView2: UIView!
    @IBOutlet weak var animationWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fromWinnerMainView: UIView!
    @IBOutlet weak var fromWinnerSubView: UIStackView!
    @IBOutlet weak var fromWinnerAndarView: UIView!
    @IBOutlet weak var fromWinnerBaharView: UIView!
    
    private var coinsDataList = [Int]()
    private var placeGameAmount = 0
    private var originalAniRect = CGRect.zero
    private var originalAniConstraint = CGFloat()
    
    private var timerStatus = Timer()
    private var cardTimer = Timer()
    private var gameStartTimer = Timer()
    private var totalBetAndar = 0
    private var totalBetBahar = 0
    private var isGameBegning = false
    private var timeRemaining = 0
    private var allCardsArray = [String]()
    private var andarCardsArray = [String]()
    private var baharCardsArray = [String]()
    private var cardIndex = 0
    private var betPlace = -1
    private var canbet = false
    private var bet_id = ""
    private var betValue = 0
    private var wallet = ""
    private var game_id = ""
    private var betPlaces = [String]()
    private var botUsers = [HeadTailBotModel]()
    private var isBotPlayerSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.animationView.isHidden = true
        self.betEndImage.isHidden = true
        coinsDataList.append(10)
        coinsDataList.append(50)
        coinsDataList.append(100)
        coinsDataList.append(1000)
        coinsDataList.append(5000)
        placeBetImages.image = UIImage.gif(name: "place_your_bet")
        placeBetImages.isHidden = true
        waitingBetImages.image = UIImage.gif(name: "waiting_for_next")
        self.betCollectionView.reloadData()
        self.cardImage.image = UIImage(named: "backside_card")
        self.betEndImage.image = UIImage.gif(name: "stop_betting")
        
        self.profileBottomView1.applyGradient(isVertical: false, colorArray: [UIColor(hexString: "#353541"), UIColor(hexString: "#565c79")])
        self.profileBottomView2.applyGradient(isVertical: false, colorArray: [UIColor(hexString: "#353541"), UIColor(hexString: "#565c79")])
        startGameStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerStatus.invalidate()
        timerStatus.invalidate()
        if gameStartTimer.isValid {
            gameStartTimer.invalidate()
            gameStartTimer.invalidate()
        }
        if cardTimer.isValid {
            cardTimer.invalidate()
            cardTimer.invalidate()
        }
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
            canbet = false
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
    
    private func startCardDistributtion(_ totalTime: Int) {
        if timerStatus.isValid {
            timerStatus.invalidate()
        }
        if cardTimer.isValid {
            cardTimer.invalidate()
        }
        andarCardsArray = [String]()
        baharCardsArray = [String]()
        if betPlaces.count <= 0 {
            Toast.makeToast("You have not Bet yet.")
        }
        timerStatus = Timer(timeInterval: 0.2, target: self, selector: #selector(self.addCardIntoArray), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timerStatus, forMode: .default)
        timerStatus.fire()
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
    
    @objc private func addCardIntoArray() {
        if allCardsArray.count > cardIndex {
            if cardIndex % 2 == 0 {
                andarCardsArray.append(allCardsArray[cardIndex])
                if andarCardsArray.count > 1 {
                    andarCollectionView.reloadData()
                    self.andarCollectionView.isHidden = false
                }
            } else {
                baharCardsArray.append(allCardsArray[cardIndex])
                if baharCardsArray.count > 1 {
                    baharCollectionView.reloadData()
                    self.baharCollectionView.isHidden = false
                }
            }
            cardIndex += 1
        } else {
            allCardsArray = [String]()
            if cardTimer.isValid {
                cardTimer.invalidate()
            }
            cardIndex = 0
            self.waitingBetImages.isHidden = false

            delay(3) {
                self.andarCollectionView.isHidden = true
                self.baharCollectionView.isHidden = true
                self.startGameStatus()
            }
        }
    }
    
    @IBAction func tapOnAddChips(_ sender: UIButton) {
        
    }
    
    @IBAction func tapOnBackButton(_ sender: UIButton) {
        PromptVManager.present(self, titleString: "CONFIRMATOIN", messageString: "Are you sure, you want to Leave ?", viewTag: 1)
    }
    
    @IBAction func tapOnInfoButton(_ sender: UIButton) {
        if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: DialogInfoViewController().className) as? DialogInfoViewController {
            myObject.isInformationView = true
            myObject.gameType = GameTypes.andar_bahar
            self.navigationController?.present(myObject, animated: true)
        }
    }
    
    @IBAction func tapOnAndarBetButton(_ sender: UIButton) {
        if !canbet {
            Toast.makeToast("Game Already Started You can not Bet")
        }
        if placeGameAmount <= 0 {
            Toast.makeToast("Please Select Bet amount First")
            return
        }
        if betPlace == 1 {
            betValue = 0
        }
        betPlace = 0
        betValue += placeGameAmount
        if betValue > 0 {
            betPlaces.append("\(betPlace)")
            placeBet(betPlace)
        }
    }
    
    @IBAction func tapOnbaharBetButton(_ sender: UIButton) {
        if !canbet {
            Toast.makeToast("Game Already Started You can not Bet")
        }
        if placeGameAmount <= 0 {
            Toast.makeToast("Please Select Bet amount First")
            return
        }
        if betPlace == 0 {
            betValue = 0
        }
        betValue += placeGameAmount
        betPlace = 1
        if betValue > 0 {
            betPlaces.append("\(betPlace)")
            placeBet(betPlace)
        }
    }
    
    private func restartGame() {
        for vv in self.view.subviews {
            if vv.tag == 9999 {
                vv.removeFromSuperview()
            } else if vv.tag == 9998 {
                vv.removeFromSuperview()
            }
        }
        canbet = true
        isGameBegning = true
        waitingBetImages.isHidden = true
        self.andarHighlightedView.isHidden = true
        self.baharHighlightedView.isHidden = true
        self.andarCircleImage.isHidden = true
        self.baharCircleImage.isHidden = true
        self.andarCollectionView.isHidden = true
        self.baharCollectionView.isHidden = true
        self.andarBetButton.setTitle("", for: .normal)
        self.baharBetButton.setTitle("", for: .normal)
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
        myAniSubView1.isUserInteractionEnabled = false
        myAniSubView2.isUserInteractionEnabled = false
        myNewAniView.addSubview(myAniSubView1)
        myNewAniView.addSubview(myAniSubView2)
        myNewAniView.clipsToBounds = true

        self.view.addSubview(myNewAniView)

        var imageNameArray = [10, 50, 100, 1000, 5000]
        //imageNameArray.randomElement()
        var xFrom = 20.0
        var xTo = 40.0
        let yRandomNumber = CGFloat.random(in: 10...25)
        for _ in 0..<5 {
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
        xFrom = 20.0
        xTo = 40.0
        for _ in 0..<5 {
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

        UIView.animate(withDuration: 1) {
            myNewAniView.frame = self.originalAniRect
        } completion: { s in
            myNewAniView.clipsToBounds = false
        }
    }
    
    
    private func makeWinner(_ isMeWinner: Bool) {
        let delayTime = 0.2
        var count = 0
        _ = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: true){ t in
            self.makeWinnerDummyAnimation(true, isMeWinner: isMeWinner)
            count += 1
            if count >= 10 {
                t.invalidate()
            }
        }
        
        let delayTime1 = 0.2
        var count1 = 0
        _ = Timer.scheduledTimer(withTimeInterval: delayTime1, repeats: true){ t1 in
            self.makeWinnerDummyAnimation(false, isMeWinner: isMeWinner)
            count1 += 1
            if count1 >= 10 {
                t1.invalidate()
            }
        }
    }
    
    private func makeWinnerDummyAnimation(_ isAndar: Bool, isMeWinner: Bool) {
        originalAniRect = isMeWinner ? CGRect(x: self.profileBottomView.frame.origin.x + 40.0, y: self.profileBottomView.frame.origin.y + 16.0, width: 100.0, height: 100.0) : CGRect(x: self.otherUserView.frame.origin.x - 20.0, y: self.otherUserView.frame.origin.y, width: 20.0, height: 20.0)

        let myNewAndarAniView = UIView(frame: CGRect(x: self.fromWinnerMainView.frame.origin.x + self.fromWinnerSubView.frame.origin.x + (isAndar ? fromWinnerAndarView.frame.origin.x : fromWinnerBaharView.frame.origin.x) + (fromWinnerAndarView.frame.size.width / 2.0) - 10.0, y: self.fromWinnerMainView.frame.origin.y + self.fromWinnerSubView.frame.origin.y + (isAndar ? fromWinnerAndarView.frame.origin.y : fromWinnerBaharView.frame.origin.y) + (fromWinnerAndarView.frame.size.height / 2.0) - 10.0, width: 50.0, height: 20.0))

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
}

// MARK: API calls
extension AndarBaharViewController {
    
    private func placeBet(_ type: Int) {
        DispatchQueue.global(qos: .background).async {
            //self.mBetsOn.append("\(type)")
            APIClient.shared.post(parameters: ABGPlaceBetRequest(game_id: self.game_id, bet: "\(type)", amount: "\(self.betValue)"), feed: .ABG_place_bet, showLoading: false, responseKey: "all") { [self] result in
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
                    /*if type == 0 {
                        self.andarCircleImage.isHidden = false
                    } else {
                        self.baharCircleImage.isHidden = false
                    }*/
                    betValue = 0
                    self.gameStatus()
                    break
                case .failure(_):
                    break
                }
            }
        }
    }
    
    @objc private func gameStatus() {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameABGRequest(total_bet_ander: "\(self.totalBetAndar)", total_bet_bahar: "\(self.totalBetBahar)"), feed: .ABG_get_active_game, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let responseCode = apiResponse?.code, responseCode == 407 {
                        self.dismiss(animated: true)
                    } else if let response = apiResponse?.data, apiResponse?.code == 200 {
                        
                        if !isBotPlayerSet {
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
                        var gameStatus = -1
                        var mybaharbet_ = 0
                        var myanderbet_ = 0
                        if let myandarbet = response["my_ander_bet"].int {
                            myanderbet_ = myandarbet
//                            andarBetButton.setTitle("\(myandarbet)", for: .normal)
                        } else if let myandarbet = response["my_ander_bet"].string {
                            myanderbet_ = Int(myandarbet) ?? 0
//                            andarBetButton.setTitle(myandarbet, for: .normal)
                        }
                        
                        if let mybaharbet = response["my_bahar_bet"].int {
                            mybaharbet_ = mybaharbet
                            baharBetButton.setTitle("\(mybaharbet)", for: .normal)
                        } else if let mybaharbet = response["my_bahar_bet"].string {
                            mybaharbet_ = Int(mybaharbet) ?? 0
//                            baharBetButton.setTitle(mybaharbet, for: .normal)
                        }
                        
                        totalBetAndar = 0
                        totalBetBahar = 0
                        var winning = ""
                        if let andarbet = response["ander_bet"].int {
                            totalBetAndar = andarbet
                        } else if let andarbet = response["ander_bet"].string {
                            totalBetAndar = Int(andarbet) ?? 0
                        }
                        
                        if let baharbet = response["bahar_bet"].int {
                            totalBetBahar = baharbet
                        } else if let baharbet = response["bahar_bet"].string {
                            totalBetBahar = Int(baharbet) ?? 0
                        }
                        
                        self.andarMainLabel.text = "\(myanderbet_) / 0"
                        self.baharMainLabel.text = "\(mybaharbet_) / 0"
                        
                        if let gameArrayData = response["game_data"].array, gameArrayData.count > 0 {
                            let gameDataModel = ABGGameData(gameArrayData[0])
                            self.cardImage.image = UIImage(named: gameDataModel.main_card)
                            gameStatus = gameDataModel.status
                            timeRemaining = gameDataModel.time_remaining
                            game_id = gameDataModel.id
                            winning = "\(gameDataModel.winning)"
                        }
                        
                        if let profileArrayData = response["profile"].array, profileArrayData.count > 0 {
                            let profileDataModel = ProfileData(profileArrayData[0])
                            self.userNameLabel.text = profileDataModel.name
                            self.profileImage.sd_setImage(with: URL(string: profileDataModel.profile_pic), placeholderImage: UIImage(named: "avatar"), context: [:])
                            self.walletBalLbl.text = profileDataModel.wallet.cleanValue2
                        }
                        
                        if gameStatus == 0 {
                            if totalBetAndar > 0 {
                                self.andarMainLabel.text = "\(myanderbet_) / \(totalBetAndar)"
                            }
                            if totalBetBahar > 0 {
                                self.baharMainLabel.text = "\(mybaharbet_) / \(totalBetBahar)"
                            }
                        }
                        if gameStatus == 0 && !isGameBegning {
                            if cardTimer.isValid {
                                cardTimer.invalidate()
                            }
                            restartGame()
                            setGameTimer()
                        }
                        if gameStatus == 1 && !isGameBegning {
                            self.waitingBetImages.isHidden = false
                        }
                        if gameStatus == 1 && isGameBegning {
                            isGameBegning = false
                            self.betEndImage.isHidden = false
                            allCardsArray = [String]()
                            delay(2.0) { [self] in
                                self.betEndImage.isHidden = true
                                if let cardsArray = response["game_cards"].array, cardsArray.count > 0 {
                                    cardsArray.forEach { object in
                                        allCardsArray.append(object["card"].stringValue.lowercased())
                                    }
                                    self.startCardDistributtion(allCardsArray.count)
                                    delay(Double((allCardsArray.count + 1)) * 0.2) {
                                        self.waitingBetImages.isHidden = false
                                        let isWin = self.betPlaces.contains(winning)
                                        for vv in self.view.subviews {
                                            if vv.tag == 9999 {
                                                vv.removeFromSuperview()
                                            }
                                        }
                                        self.makeWinner(isWin)
                                        self.andarHighlightedView.isHidden = winning != "0"
                                        self.baharHighlightedView.isHidden = winning == "0"
                                    }
                                }
                            }
                        }
                        self.placeBetImages.isHidden = gameStatus == 1
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
}

extension AndarBaharViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.andarCollectionView {
            return andarCardsArray.count
        }
        if collectionView == self.baharCollectionView {
            return baharCardsArray.count
        }
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
        if collectionView == self.andarCollectionView || collectionView == self.baharCollectionView {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as? CardCollectionViewCell {
                cell.cardImage.image = UIImage(named: collectionView == self.andarCollectionView ? self.andarCardsArray[indexPath.row] : self.baharCardsArray[indexPath.row])
                return cell
            }
        } else if collectionView == self.betCollectionView, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DNTCollectionViewCell.betCell, for: indexPath) as? DNTCollectionViewCell {
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

extension AndarBaharViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == betCollectionView {
            self.placeGameAmount = coinsDataList[indexPath.row]
            self.betCollectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return collectionView == self.andarCollectionView || collectionView == self.baharCollectionView ? CGSize(width: 18.0, height: 20.0) : CGSize(width: 60.0, height: 60.0)
    }
}

// MARK: Alert Prompt Delegate
extension AndarBaharViewController: PromptViewDelegate {
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
