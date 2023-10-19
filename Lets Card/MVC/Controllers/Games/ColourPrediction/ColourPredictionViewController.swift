//
//  ColourPredictionViewController.swift
//  Lets Card
//
//  Created by Durgesh on 21/04/23.
//

import UIKit

class ColourPredictionViewController: UIViewController {
    @IBOutlet weak var profileBottomView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var walletBalLbl: UILabel!
    @IBOutlet weak var betCollectionView: UICollectionView!
    
    @IBOutlet weak var battingLabel: UILabel!
    @IBOutlet weak var otherUserView: UIStackView!
    @IBOutlet weak var otherUserLabel: UILabel!
    @IBOutlet weak var gameView2: UIView!
    @IBOutlet weak var txtGameBets: UILabel!

    @IBOutlet weak var colourCollectionView: UICollectionView!
    @IBOutlet weak var wheelImageView: UIImageView!

    private var coinsDataList = [10, 50, 100, 1000, 5000]
    private var gameColoursImage = ["join_zero_update", "join_one_update", "join_two_update", "join_three_update", "join_four_update", "join_five_update", "join_six_update", "join_seven_update", "join_eight_update", "join_nine_update"]
    private var placeGameAmount = 0

    private var isCardsDisribute = false
    private var winnerId = -1
    private var lastWinList = [LastWinningsModel]()
    private var game_id = ""
    private var timeRemaining = 0
    private var isGameBegning = false
    private var canbet = false
    private var added_date = ""
    private var allCardsArray = [String]()
    private var wheelResultDegree = [7.3, 6.65, 6.0, 5.35, 4.7, 4.05, 9.75, 9.1, 8.45, 7.8]

    private var timerStatus = Timer()
    private var gameStartTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        betCollectionView.reloadData()
        colourCollectionView.reloadData()
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
    
    private func startWinningAnimation() {
        let delayTime = 0.2
        var count = 0
        _ = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: true){ t in
            self.makeWinnerDummyAnimation()
            count += 1
            if count >= 10 {
                t.invalidate()
            }
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
            self.battingLabel.text = "0"
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
        self.battingLabel.text = "\(timeRemaining)"
    }
    
    @IBAction func tapOnBackButton(_ sender: UIButton) {
        PromptVManager.present(self, titleString: "CONFIRMATOIN", messageString: "Are you sure, you want to Leave ?", viewTag: 1)
    }
    
    @IBAction func tapOnInfoButton(_ sender: UIButton) {
        if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: DialogInfoViewController().className) as? DialogInfoViewController {
            myObject.gameType = GameTypes.color_prediction
            myObject.isInformationView = true
            self.navigationController?.present(myObject, animated: true)
        }
    }
    
    @IBAction func tapOnAddChips(_ sender: UIButton) {
        
    }
    
    @IBAction func tapOnPlaceBet(_ sender: UIButton) {
        //12 - Red
        //11 - Violet
        //10 - Green
        if canbet {
            if placeGameAmount != 0 {
                self.placeBet(sender.tag)
                Toast.makeToast("\(sender.tag)")
            } else {
                Toast.makeToast("Please select a valid amount to Bet")
            }
        } else {
            Toast.makeToast("Game Already Started You can not Bet")
        }
    }
    
    private func makeWinnerDummyAnimation() {
        let originalAniRect = CGRect(x: self.otherUserView.frame.origin.x, y: self.otherUserView.frame.origin.y, width: 20.0, height: 20.0)

        let winnerW = winnerId > 4 ? ((winnerId - 5) * 10) : winnerId * 10
        let winnerWidth = (70.0 * Double(winnerId > 4 ? winnerId - 5 : winnerId))
        let winnderHeight = winnerId > 4 ? 70.0 : 0.0
        let myNewAndarAniView = UIView(frame: CGRect(x: self.colourCollectionView.frame.origin.x +  (winnerWidth + Double(winnerW)), y: (self.colourCollectionView.frame.origin.y + winnderHeight), width: 70.0, height: 60.0))

        myNewAndarAniView.tag = 9998
        myNewAndarAniView.isUserInteractionEnabled = false
        myNewAndarAniView.clipsToBounds = false

        self.gameView2.addSubview(myNewAndarAniView)
        for _ in 0..<3 {
            let imageView = UIImageView(image: UIImage(named: "ic_dt_chips"))
            imageView.frame = CGRect(x: 30.0, y: 25.0, width: 15.0, height: 15.0)
                imageView.isUserInteractionEnabled = false
            myNewAndarAniView.addSubview(imageView)
        }

        UIView.animate(withDuration: 1) {
            myNewAndarAniView.frame = originalAniRect
        } completion: { s in
            myNewAndarAniView.removeFromSuperview()
        }
    }
}

extension ColourPredictionViewController {
    private func placeBet(_ tagIndex: Int) {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: ColourPredBetRequest(game_id: self.game_id, bet:  "\(tagIndex)", amount: "\(self.placeGameAmount)"), feed: .CPre_place_bet, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse?.data, apiResponse?.code == 200 {
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
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameColourPredRequest(), feed: .CPre_get_active_game, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let responseCode = apiResponse?.code, responseCode == 407 {
                        self.dismiss(animated: true)
                    } else if let response = apiResponse?.data, apiResponse?.code == 200 {
//                        print("Response: \(response)")
                        var gameStatus = -1
                        winnerId = -1
                        self.otherUserLabel.text = "0"
                        if let onlineUsers = response["online_users"].array {
                            self.otherUserLabel.text = "\(onlineUsers.count)"
                        }

                        lastWinList = [LastWinningsModel]()
                        if let lastWinnings = response["last_winning"].array, lastWinnings.count > 0 {
                            lastWinnings.forEach { object in
                                lastWinList.append(LastWinningsModel(object))
                            }
                        }
                        
                        if let gameArrayData = response["game_data"].array, gameArrayData.count > 0 {
                            let gameDataModel = ABGGameData(gameArrayData[0])
                            gameStatus = gameDataModel.status
                            game_id = gameDataModel.id
                            winnerId = gameDataModel.winning
                            added_date = gameDataModel.added_date
                            timeRemaining = gameDataModel.time_remaining
                        }
                        
                        if let profileArrayData = response["profile"].array, profileArrayData.count > 0 {
                            let profileDataModel = ProfileData(profileArrayData[0])
                            self.usernameLbl.text = profileDataModel.name
                            self.profileImage.sd_setImage(with: URL(string: profileDataModel.profile_pic), placeholderImage: UIImage(named: "avatar"), context: [:])
                            self.walletBalLbl.text = profileDataModel.wallet.cleanValue2
                        }
                        
                        if gameStatus == 0 && !isGameBegning {
                            restartGame()
                            if timeRemaining > 0 {
                                setGameTimer()
                            }
                        }
                        
                        if gameStatus == 1 && isGameBegning {
                            isGameBegning = false
                            allCardsArray = [String]()
                            if let cardsArray = response["game_cards"].array, cardsArray.count > 0 {
                                cardsArray.forEach { object in
                                    self.allCardsArray.append(object["card"].stringValue.lowercased())
                                }
                                delay(1) {
                                    self.gameStartTimer.invalidate()
                                    self.isCardsDisribute = true
                                    self.wheelImageView.rotateWithAnimation(angle: self.wheelResultDegree[self.winnerId])
                                    self.delay(Double((self.allCardsArray.count + 2))) {
                                        self.colourCollectionView.reloadData()
                                        self.startWinningAnimation()
                                        self.delay(4) {
                                            self.wheelImageView.transform = CGAffineTransform.identity
                                            self.isCardsDisribute = false
                                            self.winnerId = -1
                                            self.colourCollectionView.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                        self.txtGameBets.isHidden = gameStatus == 1
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
        isGameBegning = true
        canbet = true
        placeGameAmount = 0
        self.betCollectionView.reloadData()
    }
    
    private func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
    
    private func rotateView(targetView: UIView, duration: Double = 2.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(6))
//            targetView.transform = targetView.transform.rotated(by: CGFloat(55+360))
        }) { finished in
           // targetView.transform = targetView.transform.rotated(by: CGFloat(53+360))
           // self.rotateView(targetView: self.wheelImageView, duration: duration)
            // 2 - CGFloat(Double.pi + 9.15)
            // 3 - CGFloat(Double.pi + 2.20)
            // 5 - CGFloat(Double.pi + 26.15)
            // 6 - CGFloat(Double.pi + 19.15)
            // 7 - CGFloat(Double.pi - 0.35)
            // 8 - CGFloat(Double.pi - 0.95)
            // 9 - CGFloat(Double.pi - 1.55)
            // 0 - CGFloat(Double.pi - 2.20)
        }
    }
}

extension ColourPredictionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.betCollectionView == collectionView ? coinsDataList.count : gameColoursImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.betCollectionView == collectionView ? DNTCollectionViewCell.betCell : DNTCollectionViewCell.cellColourIdentifier, for: indexPath) as? DNTCollectionViewCell {
            if self.betCollectionView == collectionView  {
                cell.configure(coinsDataList[indexPath.row], highLightet: self.placeGameAmount)
            } else {
                cell.configureColour(gameColoursImage[indexPath.row], isWinner: winnerId == indexPath.row)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension ColourPredictionViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 25.0, height: 25.0)
//    }
}

extension ColourPredictionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.betCollectionView == collectionView  {
            self.placeGameAmount = coinsDataList[indexPath.row]
            self.betCollectionView.reloadData()
        }
    }
}

// MARK: Alert Prompt Delegate
extension ColourPredictionViewController: PromptViewDelegate {
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
