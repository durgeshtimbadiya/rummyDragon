//
//  AnimalRouletteViewController.swift
//  Lets Card
//
//  Created by Durgesh on 18/04/23.
//

import UIKit

class AnimalRouletteViewController: UIViewController {
    
    @IBOutlet weak var profileBottomView: UIView!
    @IBOutlet weak var profileBottomView1: UIView!
    @IBOutlet weak var profileBottomView2: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var walletBalLbl: UILabel!
    @IBOutlet weak var betCollectionView: UICollectionView!
    
    @IBOutlet weak var pleaseWaitView: UIView!

    @IBOutlet weak var resultCollectionView: UICollectionView!
    @IBOutlet weak var gamePlayView: UIView!
    @IBOutlet weak var gamePlayStackView: UIStackView!
    @IBOutlet weak var gamePlaySubStackView1: UIStackView!
    @IBOutlet weak var gamePlaySubStackView2: UIStackView!
    @IBOutlet weak var battingLabel: UILabel!

    // MARK: Cars - 0,15 - ; 1,14 - ; 2, 13 - ; 3,12 - ; 4,11 - ; 5,10 - ; 6,9 - ; 7,17 - ; 8-16;
    @IBOutlet var allCarImages: [UIImageView]!
    @IBOutlet var gamePlayingView: [UIView]!
    //@IBOutlet var gamePlayingImageView: [UIImageView]!
    @IBOutlet var gamePlayingScoreLabel: [UILabel]!
    @IBOutlet var gameTotalScoreLabel: [UILabel]!
    //@IBOutlet var gamePlayingCarNameLbl: [UILabel]!
    @IBOutlet var gamePlayingMultiLabel: [UILabel]!
    @IBOutlet var gamePlayBGImages: [UIImageView]!
    @IBOutlet var gamePBGImages: [UIImageView]!
    @IBOutlet var gamePlayCarSelectedImgs: [UIImageView]!

    @IBOutlet weak var otherUserView: UIView!
    @IBOutlet weak var otherUserLabel: UILabel!
    
    @IBOutlet weak var betSpotEnd: UIImageView!
        
    private var lastWinList = [LastWinningsModel]()
    private var coinsDataList = [Int]()
    private var placeGameAmount = 50
    
    private var timerStatus = Timer()
    private var gameStartTimer = Timer()

    private var game_id = ""
    private var winnerId = -1
    private var timeRemaining = 0
    private var isGameBegning = false
    private var added_date = ""
    private var allCardsArray = [String]()
    private var betPlaces = [String]()
    private var originalAniRect = CGRect.zero
    private var originalAniConstraint = CGFloat()
    private var isCardsDisribute = false
    private var GameAmount = 0.0
    var tempImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.betSpotEnd.isHidden = true
        for i in 0..<gamePlayCarSelectedImgs.count {
            gamePlayCarSelectedImgs[i].isHidden = true
        }
        
        self.profileBottomView1.applyGradient(isVertical: false, colorArray: [UIColor(hexString: "#353541"), UIColor(hexString: "#565c79")])
        self.profileBottomView2.applyGradient(isVertical: false, colorArray: [UIColor(hexString: "#353541"), UIColor(hexString: "#565c79")])
        
        coinsDataList.append(10)
        coinsDataList.append(50)
        coinsDataList.append(100)
        coinsDataList.append(1000)
        coinsDataList.append(5000)
        betCollectionView.reloadData()
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

    @IBAction func tapOnBetPlace(_ sender: UIButton) {
        let tempFrame = self.gamePlayBGImages[sender.tag].frame
        self.gamePlayBGImages[sender.tag].frame = CGRect(x: -10, y: -10, width: self.gamePlayBGImages[sender.tag].frame.size.width + 20.0, height: self.gamePlayBGImages[sender.tag].frame.size.height + 20.0)
        UIView.transition(with: self.gamePlayBGImages[sender.tag], duration: 0.5) {
            self.gamePlayBGImages[sender.tag].frame = tempFrame
        } completion: { isAaa in
            self.gamePlayBGImages[sender.tag].frame = tempFrame
        }
        self.placeBet(sender.tag)
    }
    
    @IBAction func tapOnBackButton(_ sender: UIButton) {
        PromptVManager.present(self, titleString: "CONFIRMATOIN", messageString: "Are you sure, you want to Leave ?", viewTag: 1)
    }
    
    @IBAction func tapOnInfoButton(_ sender: UIButton) {
        if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: DialogInfoViewController().className) as? DialogInfoViewController {
            myObject.isInformationView = true
            myObject.gameType = GameTypes.animal_roulette
            self.navigationController?.present(myObject, animated: true)
        }
    }
    
    @IBAction func tapOnAddChips(_ sender: UIButton) {
        
    }
}

extension AnimalRouletteViewController {
    private func setCarRotationAnimation(_ viewV: UIImageView, tag: Int) {
        for i in 0..<gamePlayCarSelectedImgs.count {
            gamePlayCarSelectedImgs[i].image = nil
            gamePlayCarSelectedImgs[i].isHidden = true
        }
        var count = 0
        var count1 = 0
        _ = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){ t in
            if count == 0 {
                self.gamePlayCarSelectedImgs[self.gamePlayCarSelectedImgs.count - 1].isHidden = true
            } else {
                self.gamePlayCarSelectedImgs[count - 1].isHidden = true
            }
            self.gamePlayCarSelectedImgs[count].isHidden = false
            count += 1
            if count > self.gamePlayCarSelectedImgs.count - 1 {
                count = 0
                count1 += 1
            }
            if count1 > 2 {
                // tag
                var intArrayOfCar = [Int]()
                switch tag {
                case 0:  // Panda
                    intArrayOfCar = [17, 19]
                    break
                case 1: // Pigion
                    intArrayOfCar = [3, 13, 14, 16]
                    break
                case 2: // Peakock
                    intArrayOfCar = [2, 15]
                    break
                case 3: // Egal
                    intArrayOfCar = [9, 10, 23, 25]
                    break
                case 4:// Lion
                    intArrayOfCar = [6, 21]
                    break
                case 5: // Monkey
                    intArrayOfCar = [5, 20]
                    break
                case 6: // Swall
                    intArrayOfCar = [7, 8, 24]
                    break
                default:  // Rabit
                    intArrayOfCar = [0, 1, 11, 12, 22]
                    break
                }
                
                for i in 0..<self.gamePlayCarSelectedImgs.count {
                    self.gamePlayCarSelectedImgs[i].isHidden = true
                }
                if let indexX = intArrayOfCar.randomElement() {
                    self.gamePlayCarSelectedImgs[indexX].isHidden = false
                } else {
                    self.gamePlayCarSelectedImgs[intArrayOfCar[0]].isHidden = false
                }
                // 0 Tiger - 12
                // 1 Snake - 2, 11
                // 2 Shark - 1, 10
                // 3 Fox - 7, 8, 18
                // 4 Cheetah - 5, 16
                // 5 Bear - 4, 15
                // 6 Whale - 3, 13
                // 7 Lion - 0, 9, 19
                self.delay(2) {
                    self.setWinningImage(viewV)
                }
                t.invalidate()
            }
        }
    }
    
    private func setWinningImage(_ viewV: UIImageView) {
//        for i in 0..<gamePlayCarSelectedImgs.count {
//            gamePlayCarSelectedImgs[i].image = UIImage(named: "ic_selected_square")
////            gamePlayCarSelectedImgs[i].isHidden = true
//        }
        let tempImage = viewV.image
        viewV.image = UIImage.gif(name: "ic_jackpot_rule_bg_selected")
        var count = 0
        _ = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true){ t in
            self.winningAnimation(viewV)
            count += 1
            if count >= 2 {
                viewV.image = tempImage
                self.pleaseWaitView.isHidden = false
                self.isCardsDisribute = false
                for i in 0..<self.gamePlayingScoreLabel.count {
                    self.gamePlayingScoreLabel[i].text = "0"
                }
                for i in 0..<self.gamePlayCarSelectedImgs.count {
                    self.gamePlayCarSelectedImgs[i].isHidden = true
                }
                t.invalidate()
            }
        }
    }
    
    private func winningAnimation(_ viewV: UIImageView) {
        viewV.alpha = 1.0
        UIView.transition(with: viewV, duration: 1.0, options: .transitionCrossDissolve) {
            viewV.alpha = 0.0
        } completion: { isAaa in
            viewV.alpha = 1.0
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
            self.betSpotEnd.isHidden = false
            self.betSpotEnd.frame.size.height = 0.0
            self.betSpotEnd.image = UIImage(named: "iv_bet_stops")
            UIView.transition(with: self.betSpotEnd, duration: 1, options: .curveEaseInOut) {
                self.betSpotEnd.frame.size.height = 33.0
            }
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
        self.battingLabel.text = "\(timeRemaining)"
    }
    
    private func makeDummyAnimation() {
        var imageNameArray = [10, 50, 100, 1000, 5000, 10, 50, 100]
        for i in 0..<self.gamePlayingView.count {
            let stackViewX = i > 3 ? self.gamePlaySubStackView2.frame.origin.x : self.gamePlaySubStackView1.frame.origin.x
            let stackViewY = i > 3 ? self.gamePlaySubStackView2.frame.origin.y : self.gamePlaySubStackView1.frame.origin.y

            let originX = (self.gamePlayStackView.frame.origin.x + stackViewX + self.gamePlayingView[i].frame.origin.x) + 5.0
            let originY = (self.gamePlayStackView.frame.origin.y + stackViewY + self.gamePlayingView[i].frame.origin.y) + 20.0
            
            let originalAniRect = CGRect(x: CGFloat.random(in: originX...originX + self.gamePlayingView[i].frame.size.width - 40.0), y: CGFloat.random(in: originY...originY + 10.0), width: 20.0, height: 20.0)
            var imageTag = 10
            if let rndNumber = imageNameArray.randomElement(), let indexX = imageNameArray.firstIndex(of: rndNumber) {
                imageNameArray.remove(at: indexX)
                imageTag = rndNumber
            }
            let imageView = UIImageView(image: UIImage(named: "ic_coin_\(imageTag)_dt")) // 10, 50, 100, 1000, 5000
            imageView.frame = CGRect(x: self.otherUserView.frame.origin.x + 20.0, y: self.otherUserView.frame.origin.y + 20.0, width: 20.0, height: 20.0)
                imageView.isUserInteractionEnabled = false
            imageView.tag = 9999
            self.gamePlayView.addSubview(imageView)

            UIView.animate(withDuration: 1) {
                imageView.frame = originalAniRect
            } completion: { s in }
        }
        
    }
}

extension AnimalRouletteViewController {
    private func placeBet(_ tagIndex: Int) {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: AnimalRouletteBetRequest(game_id: self.game_id, bet:  "\(self.placeGameAmount)", amount: "\(self.placeGameAmount)"), feed: .AnimalRlt_place_bet, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse?.data, apiResponse?.code == 200 {
                        self.walletBalLbl.text = response["wallet"].stringValue
                        self.gamePlayingScoreLabel[tagIndex].text = "\(placeGameAmount)"
                        Toast.makeToast("Bet has been added successfully!")
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
            APIClient.shared.post(parameters: GameAnimalRouletteRequest(), feed: .AnimalRlt_get_active_game, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let responseCode = apiResponse?.code, responseCode == 407 {
                        self.dismiss(animated: true)
                    } else if let response = apiResponse?.data, apiResponse?.code == 200 {
                        print("Response: \(response)")
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
//                            if lastWinList.count > 0 && gameDataModel.id != game_id {
//
//                            }
                            self.resultCollectionView.reloadData()
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
                            isGameBegning = true
                            self.pleaseWaitView.isHidden = true
                            if timeRemaining > 0 {
//                                self.isCardsDisribute = true
                                self.betSpotEnd.image = UIImage(named: "iv_bet_begin")
                                self.betSpotEnd.frame.size.height = 0.0
                                self.betSpotEnd.isHidden = false
                                UIView.transition(with: self.betSpotEnd, duration: 1) {
                                    self.betSpotEnd.frame.size.height = 33.0
                                } completion: { isA in
                                    self.delay(1) {
                                        self.betSpotEnd.isHidden = true
                                    }
                                }
                                setGameTimer()
                            } else {
                                gameStartTimer.invalidate()
                                gameStartTimer.invalidate()
                            }
                        } else if gameStatus == 0 && isGameBegning {
                           
                        }
                        
                        if gameStatus == 1 && !isGameBegning {
                            self.pleaseWaitView.isHidden = false
                        }
                        if gameStatus == 1 && isGameBegning {
                            isGameBegning = false
//                            self.betSpotEnd.isHidden = false
//                            self.betSpotEnd.frame.size.height = 0.0
//                            self.betSpotEnd.image = UIImage(named: "iv_bet_stops")

                            allCardsArray = [String]()
                            if let cardsArray = response["game_cards"].array, cardsArray.count > 0 {
//                                UIView.transition(with: self.betSpotEnd, duration: 1, options: .curveEaseInOut) {
//                                    self.betSpotEnd.frame.size.height = 33.0
//                                }
                                cardsArray.forEach { object in
                                    self.allCardsArray.append(object["card"].stringValue.lowercased())
                                }
                                delay(2) {
                                    self.gameStartTimer.invalidate()
                                    self.isCardsDisribute = true
//                                    self.showDiceViewAndAnimate()
                                    self.delay(Double((self.allCardsArray.count + 2))) {
                                        self.betSpotEnd.isHidden = true
//                                        let isWin = self.betPlaces.contains("\(self.winnerId)")
                                        for vv in self.gamePlayView.subviews {
                                            if vv.tag == 9999 {
                                                 vv.removeFromSuperview()
                                            }
                                        }
                                        if self.winnerId > self.gamePlayBGImages.count - 1 {
                                            self.winnerId = self.gamePlayBGImages.count - 1
                                        }
                                        self.setCarRotationAnimation(self.gamePBGImages[self.winnerId], tag: self.winnerId)
//                                        self.makeWinner(isWin)
                                    }
                                }
                            }
                        }
                        for i in 0..<self.gameTotalScoreLabel.count {
                            gameTotalScoreLabel[i].text = "0"
                        }
//                        if gameStatus != 1 {
                            let whale_amount = response["whale_amount"].intValue
                            let tiger_amount = response["tiger_amount"].intValue
                            let snake_amount = response["snake_amount"].intValue
                            let shark_amount = response["shark_amount"].intValue
                            let lion_amount = response["lion_amount"].intValue
                            let fox_amount = response["fox_amount"].intValue
                            let cheetah_amount = response["cheetah_amount"].intValue
                            let bear_amount = response["bear_amount"].intValue
//                            print("whale_amount: \(whale_amount)")
//                            print("tiger_amount: \(tiger_amount)")
//                            print("snake_amount: \(snake_amount)")
//                            print("shark_amount: \(shark_amount)")
//                            print("lion_amount: \(lion_amount)")
//                            print("fox_amount: \(fox_amount)")
//                            print("cheetah_amount: \(cheetah_amount)")
//                            print("bear_amount: \(bear_amount)")
                            for i in 0..<self.gameTotalScoreLabel.count {
                                switch i {
                                case 0: // Panda
                                    //tiger_amount
                                    self.gameTotalScoreLabel[i].text = "\(tiger_amount)"
                                    break
                                case 1: // Pigion
                                    //snake_amount
                                    self.gameTotalScoreLabel[i].text = "\(snake_amount)"
                                    break
                                case 2: // Peakock
                                    //shark_amount
                                    self.gameTotalScoreLabel[i].text = "\(shark_amount)"
                                    break
                                case 3: // Egal
                                    //fox_amount
                                    self.gameTotalScoreLabel[i].text = "\(fox_amount)"
                                    break
                                case 4: // Lion
                                    //cheetah_amount
                                    self.gameTotalScoreLabel[i].text = "\(cheetah_amount)"
                                    break
                                case 5: // Monkey
                                    // bear_amount
                                    self.gameTotalScoreLabel[i].text = "\(bear_amount)"
                                    break
                                case 6: // Swall
                                    // whale_amount
                                    self.gameTotalScoreLabel[i].text = "\(whale_amount)"
                                    break
                                case 7: // Rabit
                                    //lion_amount
                                    self.gameTotalScoreLabel[i].text = "\(lion_amount)"
                                    break
                                default:
                                    break
                                }
                            }
//                            self.gamePlayingScoreLabel[0].text = "";
//                        }
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

    }
    
    private func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
}


extension AnimalRouletteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == self.betCollectionView ? coinsDataList.count : (collectionView == self.resultCollectionView ? self.lastWinList.count : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionView == self.resultCollectionView ? DNTCollectionViewCell.lastBetCell : DNTCollectionViewCell.betCell, for: indexPath) as? DNTCollectionViewCell {
            if collectionView == self.resultCollectionView {
                cell.configureLast(lastWinList[indexPath.row], gameType: .animal_roulette)
            } else {
                cell.configure(coinsDataList[indexPath.row], highLightet: self.placeGameAmount)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension AnimalRouletteViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 25.0, height: 25.0)
//    }
}

extension AnimalRouletteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == betCollectionView {
            self.placeGameAmount = coinsDataList[indexPath.row]
            self.betCollectionView.reloadData()
        }
    }
}

// MARK: Alert Prompt Delegate
extension AnimalRouletteViewController: PromptViewDelegate {
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
