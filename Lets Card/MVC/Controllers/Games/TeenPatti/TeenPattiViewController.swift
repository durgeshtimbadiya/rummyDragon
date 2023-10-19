//
//  TeenPattiViewController.swift
//  Lets Card
//
//  Created by Durgesh on 29/12/22.
//

import UIKit
import SDWebImage
import SwiftyJSON

/*
//animations
1. Amount from player to main table for active users
2. User for all play animation player ti main table
 3. Winning main table to player and refry
 */

class TeenPattiViewController: UIViewController {
    
    @IBOutlet var playerViews: [UIView]!
    @IBOutlet var playerButtons: [UIButton]!
    @IBOutlet var playerGiftBtns: [UIButton]!
    @IBOutlet var playerImages: [UIImageView]!
    @IBOutlet var playerProgresses: [CircularProgressView]!
    @IBOutlet var playerNamesLbl: [UILabel]!
    @IBOutlet var playerAmountView: [UIView]!
    @IBOutlet var playerAmountLbl: [UILabel]!
    @IBOutlet var playerInviteImages: [UIImageView]!
    @IBOutlet var playerCardView: [UIView]!
    @IBOutlet var playerShowCardView: [UIStackView]!
    @IBOutlet var playerCardTopImages: [UIImageView]!
    @IBOutlet var winnerImages: [UIImageView]!
    @IBOutlet var winnerGIFImages: [UIImageView]!
    @IBOutlet var winnerStarGIFImages: [UIImageView]!
    
    @IBOutlet var player1CardImages: [UIImageView]!
    @IBOutlet var player2CardImages: [UIImageView]!
    @IBOutlet var player3CardImages: [UIImageView]!
    @IBOutlet var player4CardImages: [UIImageView]!
    @IBOutlet var player5CardImages: [UIImageView]!
    @IBOutlet var playerCardAnimationViews: [UIView]!
    @IBOutlet var playerMoneyViews: [UIView]!
    @IBOutlet var playerMoneyLabels: [UILabel]!
    @IBOutlet var sideShowPlayerLbl: [UILabel]!
    
    @IBOutlet weak var myCardButton: UIButton!
    @IBOutlet weak var cardMainImageView: UIImageView!
    @IBOutlet weak var cardMainImageView1: UIImageView!

    @IBOutlet weak var totalBalanceLbl: UILabel!
    @IBOutlet weak var chaalBalLabel: UILabel!
    
    @IBOutlet weak var countDownView: UIStackView!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var refryImageView: UIImageView!
    @IBOutlet weak var goldImageView: UIImageView!
    
    @IBOutlet weak var bigMoneyAddView: UIView!
    @IBOutlet weak var bigMoneyAddAmount: UILabel!
    
    @IBOutlet weak var smallMoneyAddView: UIView!
    @IBOutlet weak var smallMoneyAddAmount: UILabel!
    
    @IBOutlet weak var smallMoneyView1: UIView!
    @IBOutlet weak var smallMoney1Amount: UILabel!
    
    @IBOutlet weak var betMoneyAddView: UIView!
    @IBOutlet weak var betMoneyAddAmount: UILabel!
    
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var minusBottomButton: UIButton!
    @IBOutlet weak var plusBottomButton: UIButton!
    @IBOutlet weak var blindChaalButton: UIButton!
    @IBOutlet weak var imageBlindChaalLbl: UILabel!
    
    @IBOutlet weak var sideShowRequestView: UIView!
    @IBOutlet weak var sideShowLabel: UILabel! // is Asking for Side Show
    
    private var allPlayerCardImages = [[UIImageView]]()

    var table_id = -1
    var boot_value = ""
    var isPrivateTable = false
    var isCustomBoot = false
    
    private var playerGameData = [GameTablePlayer]()
    private var timerStatus = Timer()
    private var active_game_id = ""
    private var currentChaalId = -1
    private var winner_user_id = -1
    private var game_status = 0
    private var table_amount = -1.0
    private var tableDetail = TableDetailData()
    private var game_logs = [GameLogData]()
    private var game_users = [GameCardModel]()
    private var game_amount = 0.0
    private var game_gifts = [String]()
    private let myUserId = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    private var isStartProgress = false
    
    private var gameStartTimer = Timer()
    private var gameStartTime = 8
    
    private var playerCountTotal = 0
    private var user_packs = [1, 1, 1, 1, 1]
    private var progressStart = [false, false, false, false, false]

    private var isSeenUser = false
    private var slidshow_id = -1
    private var sentamounttype = 0
    private var updatedamount = 0.0
    private var isCardAnimationDone = true
    private var isSlideShow = false
    private var sideShowModel = GameSideShowModel()
    let group = DispatchGroup()
    private var cardAniDura = 0.3
    private var previouseChaalId = -1
    private var gameGiftTag = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.minusBottomButton.isEnabled = false
        allPlayerCardImages = [[UIImageView]]()
        allPlayerCardImages.append(self.player1CardImages)
        allPlayerCardImages.append(self.player2CardImages)
        allPlayerCardImages.append(self.player3CardImages)
        allPlayerCardImages.append(self.player4CardImages)
        allPlayerCardImages.append(self.player5CardImages)
        self.cardMainImageView.isHidden = true
        self.refryImageView.image = UIImage.gif(name: "girle_character_teen")
        if table_id == -1 {
            getTables()
        } else {
            checkGameStatus()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setGameTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerStatus.invalidate()
        timerStatus.invalidate()
        gameStartTimer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        playerToMainTable([0, 1, 3])
    }
    
    private func setGameTimer() {
        if gameStartTimer.isValid {
            gameStartTimer.invalidate()
        }
        gameStartTimer = Timer(timeInterval: 1, target: self, selector: #selector(self.updateGameStartTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.gameStartTimer, forMode: .default)
        gameStartTimer.fire()
    }
    
    private func checkGameStatus() {
        if timerStatus.isValid {
            timerStatus.invalidate()
        }
        timerStatus = Timer(timeInterval: 8, target: self, selector: #selector(self.gameStatus), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timerStatus, forMode: .default)
        timerStatus.fire()
    }
    
    @objc private func updateGameStartTimer() {
        gameStartTime -= 1
        if gameStartTime == 0 {
            self.isCardAnimationDone = false
            self.plusBottomButton.isEnabled = true
            self.startGame()
        }
        if gameStartTime < 0 {
            self.countDownView.isHidden = true
            if gameStartTimer.isValid {
                gameStartTimer.invalidate()
            }
            gameStartTime = 8
            checkGameStatus()
            return
        }
        self.countDownView.isHidden = false
        self.countDownLabel.text = "Round will start in \(gameStartTime) second"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: Actions
extension TeenPattiViewController {
    
    @IBAction func tapOnPlayerGift(_ sender: UIButton) {
        gameGiftTag = sender.tag
        if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: DialogInfoViewController().className) as? DialogInfoViewController {
            myObject.isGiftView = true
            myObject.delegate = self
            self.navigationController?.present(myObject, animated: true)
        }
    }
    
    @IBAction func tapOnPlayer(_ sender: UIButton) {
        let referal_code = UserDefaults.standard.value(forKey: Constants.UserDefault.referralCode)
        let referal_link = UserDefaults.standard.value(forKey: Constants.UserDefault.referralLink)
        let content = "Download letsplaycard APP and Enjoy With Your Friends Use the referral code \(referal_code ?? "") Download the App now. Link:- \(referal_link ?? ""). To join table use this link :- https://www.deeplinkurl.com/teenpattipublic?table_id=\(table_id)"
        let controller = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        controller.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
         }
        self.present(controller, animated: true)
    }
    
    @IBAction func tapOnTopButtons(_ sender: UIButton) {
        switch sender.tag {
        case 0: // 0 - Back
            if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: DialogInfoViewController().className) as? DialogInfoViewController {
                myObject.isBackView = true
                myObject.delegate = self
                self.navigationController?.present(myObject, animated: true)
            }
            break
        case 1: // 1 - Help
            if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: DialogInfoViewController().className) as? DialogInfoViewController {
                myObject.isInformationView = true
                myObject.gameType = GameTypes.teen_patti
                self.navigationController?.present(myObject, animated: true)
            }
            break
        case 2: // 2 - Play tutorial
            if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: DialogInfoViewController().className) as? DialogInfoViewController {
                myObject.gameInfoValues = [self.tableDetail.boot_value.cleanValue0, self.tableDetail.maximum_blind.cleanValue0, self.tableDetail.chaal_limit.cleanValue0, self.tableDetail.pot_limit.cleanValue0]
                self.navigationController?.present(myObject, animated: true)
            }
            break
        case 3: // 3 - Settings
            if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: DialogInfoViewController().className) as? DialogInfoViewController {
                myObject.isSettingView = true
                self.navigationController?.present(myObject, animated: true)
            }
            break
        case 4: // 4 - Message
            if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: PopupViewController().className) as? PopupViewController {
                myObject.myProfilePicURL = self.playerGameData.count > 0 ? self.playerGameData[0].profile_pic : ""
                myObject.isChatPopup = true
                myObject.game_id = self.active_game_id
                self.navigationController?.present(myObject, animated: true)
            }
            break
        default:
            break
        }
    }
    
    @IBAction func tapOnBottomButtons(_ sender: UIButton) {
        switch sender.tag {
        case 0: // 0 - Pack
            self.packGame("0")
            break
        case 1: // 1 - Show
            if self.playerCountTotal > 2 {
                if user_packs.last == 0 {
                    self.sideShowGame(self.playerGameData.last?.user_id ?? -1)
                } else if user_packs[3] == 0 {
                    self.sideShowGame(self.playerGameData[3].user_id)
                } else if user_packs[2] == 0 {
                    self.sideShowGame(self.playerGameData[2].user_id)
                } else {
                    Toast.makeToast("Side Show Coming Soon.")
                }
            } else {
                self.showGame()
            }
            break
        case 2: // 2 - Add Coin
            // Redirected to Buy chips
            break
        case 3: // 3 - Chaal minus
            sentamounttype = 0
            updatedamount = table_amount
            self.chaalBalLabel.text = "CHHAL \(updatedamount)"
            break
        case 4: // 4 - Chaal plus
            self.minusBottomButton.isEnabled = true
            self.sentamounttype = 1
            updatedamount = table_amount * 2.0
            self.chaalBalLabel.text = "CHHAL \(updatedamount)"
            break
        case 5: // 5 - Blind / Chaal
            sender.isEnabled = false
            self.chaalOnGame(self.currentChaalId)
            break
        default:
            break
        }
    }
    
    @IBAction func tapOnSeenCard(_ sender: UIButton) {
        sender.isEnabled = false
        self.seenGameCard()
    }
    
    @IBAction func tapOnSideShowRequest(_ sender: UIButton) {
        if sender.tag == 0 { // Denied
            self.sideShowGameAction("2")
        } else if sender.tag == 1 { // Accepted
            self.sideShowGameAction("1")
        }
    }
    
    @IBAction func tapOnTips(_ sender: UIButton) {
        if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: TipsPopupViewController().className) as? TipsPopupViewController {
            myObject.delegate = self
            self.navigationController?.present(myObject, animated: true)
        }
    }
}

// MARK: Tips Delegate
extension TeenPattiViewController: TipsPopupDelegate {
    func setDealerImage(_ imageName: String) {
        if !imageName.isEmpty {
            self.refryImageView.image = UIImage(named: imageName)
        }
    }
}


// API: API Call
extension TeenPattiViewController {
    private func getTables() {
        DispatchQueue.global(qos: .background).async { [self] in
            APIClient.shared.post(parameters: GameJoinRequest(boot_value: boot_value, table_id: table_id == -1 ? "" : "\(table_id)"), feed: isPrivateTable ? .Game_get_private_table : (isCustomBoot ? .Game_get_customise_table : .Game_get_table), showLoading: false, responseKey: "table_data") { result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse, response.code == 200, let tableDataArr = response.data_array, tableDataArr.count > 0 {
                        var tableArr = [GameTablePlayer]()
                        tableDataArr.forEach { object in
                            tableArr.append(GameTablePlayer(object))
                        }
                        self.table_id = tableArr.first?.table_id ?? -1
                        self.checkGameStatus()
                    } else if let code = apiResponse?.code, code == 406 {
                        self.leaveGame()
                        if let message = apiResponse?.message {
                            Toast.makeToast(message)
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
    
    private func leaveGame(_ value: Int = 0) {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameRequest(), feed: .Game_leave_table, showLoading: false, responseKey: "") { result in
                switch result {
                case .success(_):
                    if value == 1 {
                        exit(0)
                    } else {
                        self.dismiss(animated: true)
                        self.navigationController?.popViewController(animated: true)
                    }
                    break
                case .failure(_):
//                    Toast.makeToast(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    private func switchTable() {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameRequest(), feed: .Game_switch_table, showLoading: false, responseKey: "table_data") { result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse, response.code == 200, let tableDataArr = response.data_array, tableDataArr.count > 0 {
                        var tableArr = [GameTablePlayer]()
                        tableDataArr.forEach { object in
                            tableArr.append(GameTablePlayer(object))
                        }
                        self.table_id = tableArr.first?.table_id ?? -1
                        self.gameStartTimer.invalidate()
                        self.setGameTimer()
                    }
                    break
                case .failure(_):
                    //                    Toast.makeToast(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    private func joinTable() {
        DispatchQueue.global(qos: .background).async { [self] in
            APIClient.shared.post(parameters: GameJoinRequest(boot_value: boot_value, table_id: table_id == -1 ? "" : "\(table_id)"), feed: .Game_join_table, showLoading: false, responseKey: "table_data") { result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse, response.code == 200, let tableDataArr = response.data_array, tableDataArr.count > 0 {
                    }/* else if let message = apiResponse?.message {
                      Toast.makeToast(message)
                      }*/
                    //                self.startGame()
                    break
                case .failure(_):
//                    Toast.makeToast(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    private func startGame() {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameRequest(), feed: .Game_start_game, showLoading: false, responseKey: "") { result in
                switch result {
                case .success(_):
//                    if let response = apiResponse, response.code == 200 {
//                        print(response)
//                    }
                    //                else if let message = apiResponse?.message {
                    //                    Toast.makeToast(message)
                    //                }
                    self.gameStatus()
                    break
                case .failure(_):
//                    Toast.makeToast(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    private func packGame(_ type: String) {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GamePackRequest(timeout: type), feed: .Game_pack_game, showLoading: false, responseKey: "") { result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse, response.code == 200 {
                        self.stopAllProgress()
                        self.bottomView.isHidden = true
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
    
    private func showGame() {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameRequest(), feed: .Game_show_game, showLoading: false, responseKey: "") { result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse, response.code == 200 {
                        self.stopAllProgress()
                        self.bottomView.isHidden = true
                        self.winner_user_id = -1
                        if let winner = response.data?["winner"].string {
                            self.winner_user_id = Int(winner) ?? -1
                        }
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
    
    private func sideShowGame(_ prev_user_id: Int) {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameSideShowRequest(prev_user_id: prev_user_id), feed: .Game_slide_show, showLoading: false, responseKey: "all") { result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse, response.code == 200 {
                        if let slideShowId = response.data?["slide_id"].int {
                            self.slidshow_id = slideShowId
                        } else if let slideShowId = response.data?["slide_id"].string {
                            self.slidshow_id = Int(slideShowId) ?? -1
                        }
                        // show time side show for 20 second
                    }
                    break
                case .failure(_):
//                    Toast.makeToast(error.localizedDescription)
                    break
                }
            }
        }
    }
    
    private func sideShowGameAction(_ type: String) {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameSideShowActionRequest(slide_id: self.sideShowModel.id, type: type), feed: .Game_do_slide_show, showLoading: false, responseKey: "") { result in
                self.sideShowRequestView.isHidden = true
                self.isSlideShow = false
                switch result {
                case .success(_):
                    break
                case .failure(_):
//                    Toast.makeToast(error.localizedDescription)
                    break
                }
                self.gameStatus()
            }
        }
    }
    

    private func chaalOnGame(_ prev_user_id: Int) {
        if !Reachability.isConnectedToNetwork() {
            Toast.makeToast()
            return
        }
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                self.playerMoneyLabels[0].text = "\(Constants.currencySymbol)\(self.updatedamount.cleanValue2)"
                self.playerToMainTable([0])
            }
            APIClient.shared.post(parameters: GameChaalRequest(plus: self.sentamounttype), feed: .Game_chaal, showLoading: false, responseKey: "") { result in
                self.sentamounttype = 0
                self.stopAllProgress()
                self.gameStatus()
                self.blindChaalButton.isEnabled = true
                self.plusBottomButton.isEnabled = true
                self.minusBottomButton.isEnabled = true
                switch result {
                case .success(let aPIResponse):
                    if let message = aPIResponse?.message, message.isEmpty {
                        Toast.makeToast(message)
                    }
                    break
                case .failure(_):
                    break
                }
            }
        }
    }
    
    private func seenGameCard() {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameRequest(), feed: .Game_see_card, showLoading: false, responseKey: "cards") { result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse, let cardsArray = response.data_array {
                        self.myCardButton.isHidden = true
                        self.imageBlindChaalLbl.text = "Chaal"
                        if cardsArray.count > 0 {
                            self.resetAllPlayerCards()
//                            self.setCardImages(GameCardModel(cardsArray[0]), userid: self.currentChaalId)
                        }
                    } else if let message = apiResponse?.message {
                        Toast.makeToast(message)
                    }
                    self.gameStatus()
                    break
                case .failure(_):
//                    Toast.makeToast(error.localizedDescription)
                    break
                }
                self.myCardButton.isEnabled = true
            }
        }
    }
    
    @objc private func gameStatus() {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameStatusRequest(game_id: self.active_game_id, table_id: self.table_id == -1 ? "" : "\(self.table_id)"), feed: .Game_status, showLoading: false, responseKey: "all") { [self] result in
                switch result {
                case .success(let apiResponse):
//                    print("Current Chaal:  \(apiResponse?.data?["chaal"].string ?? "-1")")
                    self.playerGameData = [GameTablePlayer]()
                    if let responseCode = apiResponse?.code, responseCode == 407 {
                        self.dismiss(animated: true)
                        self.navigationController?.popViewController(animated: true)
                    } else if let response = apiResponse, var tableUsersArray = response.data?["table_users"].array {
                        var myPositionIdx = -1
                        for i in 0..<tableUsersArray.count {
                            let gamePlayer = GameTablePlayer(tableUsersArray[i])
                            if gamePlayer.user_id == myUserId {
                                self.playerGameData.append(gamePlayer)
                                myPositionIdx = i
                            } else if myPositionIdx != -1 {
                                self.playerGameData.append(gamePlayer)
                            }
                        }
                        if myPositionIdx >= 0 {
                            tableUsersArray.remove(at: myPositionIdx)
                        }
                        for i in 0..<tableUsersArray.count {
                            let gamePlayer = GameTablePlayer(tableUsersArray[i])
                            if i < myPositionIdx {
                                self.playerGameData.append(gamePlayer)
                            }
//                            print("\(myPositionIdx) : \(i)")
                        }
                        
//                        tableUsersArray.forEach { object in
//                            let gamePlayer = GameTablePlayer(object)
//                            if gamePlayer.user_id == self.myUserId {
//                                self.playerGameData.insert(gamePlayer, at: 0)
//                            } else {
//                                self.playerGameData.append(gamePlayer)
//                            }
//                        }
                        if let gameAmount = response.data?["game_amount"].double {
                            self.game_amount = gameAmount
                        } else if let gameAmount = response.data?["game_amount"].string {
                            self.game_amount = Double(gameAmount) ?? 0.0
                        }
                        if self.playerGameData.count > 0 && self.playerGameData[0].user_id != self.myUserId {
                            if self.timerStatus.isValid {
                                Toast.makeToast("Your are timeout from this table Join again.")
                            }
                            self.timerStatus.invalidate()
                            self.gameStartTimer.invalidate()
                            self.dismiss(animated: true)
                            self.navigationController?.popViewController(animated: true)
                        }
                        if let tableDetail = response.data?["table_detail"].dictionary {
                            self.tableDetail = TableDetailData(JSON(tableDetail))
                        }
                        self.active_game_id = ""
                        if let activeGameId = response.data?["active_game_id"].string, activeGameId != "0" {
                            self.active_game_id = activeGameId
                        }
                        if let gameStatus = response.data?["game_status"].int {
                            self.game_status = gameStatus
                        }
                        table_amount = -1.0
                        if let tableAmount = response.data?["table_amount"].doubleValue {
                            self.table_amount = tableAmount
                        }
                        self.currentChaalId = -1
                        self.winner_user_id = -1
                        if response.code == 200, let chaal = response.data?["chaal"].string {
                            self.currentChaalId = Int(chaal) ?? -1
                        }
                        
                        if self.currentChaalId <= 0 {
                            if let winnerUserId = response.data?["winner_user_id"].string {
                                self.winner_user_id = Int(winnerUserId) ?? -1
                            }
                        }
                        if self.currentChaalId == -1 && self.winner_user_id != -1 {
                            isSeenUser = false
                            self.plusBottomButton.isEnabled = true
                        }
                        self.game_logs = [GameLogData]()
                        if let gameLogs = response.data?["game_log"].array {
                            gameLogs.forEach { object in
                                self.game_logs.append(GameLogData(object))
                            }
                        }
                        
                        if game_logs.count > 0 {
                            let gameLog = game_logs[0]
                            if gameLog.action == 2 && currentChaalId != myUserId {
                                for plyr in 0..<playerGameData.count {
                                    if plyr != 0 && playerGameData[plyr].user_id == currentChaalId {
//                                        self.playerToMainTable([plyr])
                                        break
                                    }
                                }
                            }
                        }
                        
                        self.game_gifts = [String]()
                        if let gameGifts = response.data?["game_gifts"].array {
                            gameGifts.forEach { object in
                                self.game_gifts.append(object.stringValue)
                            }
                        }
                        
                        self.setGamePlayer()
                        if let cards = response.data?["cards"].array, cards.count > 0 {
//                            print("cards:\(cards)")
                            self.resetAllPlayerCards()
                            self.setCardImages(GameCardModel(cards[0]), userid: self.myUserId)
                            self.myCardButton.isHidden = true
                            self.imageBlindChaalLbl.text = "Chaal"
                        } else {
                            self.imageBlindChaalLbl.text = "Blind"
                        }
                        
                        self.game_users = [GameCardModel]()
                        self.playerCountTotal = 0
                        if let gameUsers = response.data?["game_users"].array {
                            if gameUsers.contains(where: { $0["user_id"].intValue == myUserId }) {
                                for i in 0..<gameUsers.count {
                                    let gameUsr = GameCardModel(gameUsers[i])
                                    if gameUsr.packed == 0 {
                                        self.playerCountTotal += 1
                                    }
                                    self.makeSeencard(gameUsr.user_id, cardSeen: gameUsr.seen)
                                    if self.game_logs.count > 0, self.game_logs[0].action == 3 {
                                        self.setCardImages(GameCardModel(gameUsers[i]), userid: gameUsr.user_id)
                                    }
                                    self.game_users.append(gameUsr)
                                }
                            }
                        }
                     
                        if self.sideShowRequestView.isHidden, let slideShow = response.data?["slide_show"].array, slideShow.count > 0 {
                            sideShowModel = GameSideShowModel(slideShow[0])
                            if sideShowModel.status == 0 {
                                //print("Side show User id: \(sideShowModel.user_id) --- My: \(myUserId)")
                                isSlideShow = sideShowModel.user_id == myUserId
                                self.sideShowRequestView.isHidden = true
                                
                                if sideShowModel.prev_id == myUserId {
                                    self.sideShowRequestView.isHidden = false
                                    self.sideShowLabel.text = "\(sideShowModel.name) is Asking for Side Show"
                                    delay(8.0) {
                                        self.sideShowGameAction("2")
                                    }
                                }
                                
                                let fromUserId = sideShowModel.user_id
                                let toUserId = sideShowModel.prev_id
                                for i in 0..<playerGameData.count {
                                    if playerGameData[i].user_id == fromUserId {
                                        self.sideShowPlayerLbl[i].text = "Side Show"
                                        self.sideShowPlayerLbl[i].isHidden = false
                                    }
                                    if playerGameData[i].user_id == toUserId {
                                        self.sideShowPlayerLbl[i].text = "Show"
                                        self.sideShowPlayerLbl[i].isHidden = false
                                    }
                                }
                            } else {
                                isSlideShow = false
                                for i in 0..<sideShowPlayerLbl.count {
                                    self.sideShowPlayerLbl[i].isHidden = true
                                }
                            }
                        } else {
                            isSlideShow = false
                            for i in 0..<sideShowPlayerLbl.count {
                                self.sideShowPlayerLbl[i].isHidden = true
                            }
                        }
                        var slide_ShowFromCard = GameCardModel()
                        var slide_ShowToCard = GameCardModel()
                        if let slideShowFromCards = response.data?["slide_show_from_cards"].array, slideShowFromCards.count > 0 {
                            slide_ShowFromCard = GameCardModel(slideShowFromCards[0])
                        }
                        if let slideShowToCards = response.data?["slide_show_to_cards"].array, slideShowToCards.count > 0 {
                            slide_ShowToCard = GameCardModel(slideShowToCards[0])
                        }
                        if self.game_users.count > 0 {
                            for i in 0..<self.game_users.count {
                                if self.game_users[i].packed == 1 {
                                    for j in 0..<self.playerGameData.count {
                                        if self.game_users[i].user_id == playerGameData[j].user_id {
                                            user_packs[j] = 1
                                            self.playerInviteImages[j].image = UIImage(named: "pack_new")
                                            self.playerInviteImages[j].isHidden = false
                                            self.playerCardView[j].isHidden = true
                                            self.playerShowCardView[j].isHidden = true
                                        }
                                    }
                                    /*if sideShowModel.status == 1 && (slide_ShowFromCard.user_id == game_users[i].user_id || slide_ShowToCard.user_id == game_users[i].user_id) {
                                     self.setCardImages(slide_ShowFromCard, userid: game_users[i].user_id)
                                     }*/
                                } else {
                                    if self.game_logs.count > 0, self.game_logs[0].action == 3 {
                                        self.setCardImages(game_users[i], userid: game_users[i].user_id)
                                    }
                                }
                            }
                        }
                        
                        if table_amount > 0 && tableDetail.chaal_limit > 0 {
                            if isSeenUser {
                                if table_amount >= tableDetail.chaal_limit {
                                    self.plusBottomButton.isEnabled = false
                                }
                            } else {
                                if table_amount >= tableDetail.chaal_limit / 2.0 {
                                    self.plusBottomButton.isEnabled = false
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
}

// MARK: Game Play
extension TeenPattiViewController {
    
    private func setGamePlayer() {
        self.resetPlayerView()
        var totalPlayers = [Int]()
        for i in 0..<playerGameData.count {
            if playerGameData[i].user_id == self.winner_user_id {
                self.stopAllProgress()
                if game_users.contains(where: { $0.user_id == myUserId }) {
                    self.winnerImages[i].isHidden = false
                    self.winnerGIFImages[i].isHidden = false
                    self.winnerStarGIFImages[i].isHidden = false
                    self.winnerGIFImages[i].image = UIImage.gif(name: "giphy")
                    self.winnerStarGIFImages[i].image = UIImage.gif(name: "star")
    //                self.playerShowCardView[i].isHidden = false
    //                self.playerCardView[i].isHidden = false
                    
                    if timerStatus.isValid {
                        timerStatus.invalidate()
                    }
                    setGameTimer()
                    self.smallMoneyAddView.isHidden = false
                    self.smallMoneyView1.isHidden = false
                    self.smallMoney1Amount.text = "\(Constants.currencySymbol)\(((self.game_amount * 10.0) / 100.0).cleanValue2)"
                    self.smallMoneyAddAmount.text = "\(Constants.currencySymbol)\(self.game_amount.cleanValue2)"
                    self.startAnimation1(from: CGPoint(x: self.smallMoneyAddView.frame.origin.x, y: self.smallMoneyAddView.frame.origin.y), toPoint: CGPoint(x: self.playerMoneyViews[i].frame.origin.x, y: self.playerMoneyViews[i].frame.origin.y), view: self.smallMoneyAddView, durarion: 1.5)
                    self.startAnimation1(from: CGPoint(x: self.smallMoneyAddView.frame.origin.x, y: self.smallMoneyAddView.frame.origin.y), toPoint: CGPoint(x: self.refryImageView.frame.origin.x, y: self.refryImageView.frame.origin.y), view: self.smallMoneyView1, durarion: 1.5)
                    
                    delay(0.47) {
                        self.smallMoneyAddView.isHidden = true
                        self.smallMoneyView1.isHidden = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        self.winner_user_id = -1
                        self.currentChaalId = -1
                        self.resetAllPlayerCards()
                        self.gameStatus()
                    }
                }
                
            } else {
                if playerGameData[i].user_id == 0 {
                    playerInviteImages[i].isHidden = true//false
                } else {
                    if game_users.contains(where: { $0.user_id == myUserId }) {
                        if playerGameData[i].user_id == self.currentChaalId {
                            startProgress(i)
                            self.bigMoneyAddView.isHidden = false
                            self.bigMoneyAddAmount.text = "\(Constants.currencySymbol)\(self.game_amount.cleanValue2)"
                        } else if self.currentChaalId == -1 {
                            self.playerInviteImages[i].image = UIImage(named: "waiting_bt")
                        }
                        
                        if i == 0 {
                            playerInviteImages[i].isHidden = true
                            playerShowCardView[i].isHidden = false
                        }
                        if self.currentChaalId != -1 {
                            totalPlayers.append(i)
                            playerCardView[i].isHidden = false
                            playerInviteImages[i].isHidden = true
                            playerCardTopImages[i].isHidden = false
                        }
                        
                        if self.game_logs.count > 0, self.game_logs[0].action == 3 {
                            myCardButton.isHidden = true
                            playerShowCardView[i].isHidden = false
                            playerCardView[i].isHidden = false
                        }
                    } else {
                        if i == 0 {
                            self.playerInviteImages[i].isHidden = true
                        }
                        self.playerInviteImages[i].image = UIImage(named: "waiting_bt")
                    }
                    if i != 0 {
                        self.playerGiftBtns[i].isHidden = false
                    }
                    playerImages[i].sd_setImage(with: URL(string: playerGameData[i].profile_pic), placeholderImage: Constants.profileDefaultImage, context: nil)
                    playerNamesLbl[i].text = playerGameData[i].name
                    playerAmountLbl[i].text = playerGameData[i].wallet.cleanValue2
                    playerAmountView[i].isHidden = false
                }
            }
        }
        if !isCardAnimationDone && totalPlayers.count > 0 {
            playerToMainTable(totalPlayers)
            setCardAnimation(totalPlayers)
            delay(Double(totalPlayers.count) * (cardAniDura * 3.0)) {
                self.isCardAnimationDone = true
                self.cardMainImageView.isHidden = true
                self.cardMainImageView1.isHidden = true
                self.myCardButton.isHidden = false
            }
        }
    }
    
    private func playerToMainTable(_ totalPlayer: [Int]) {
        for playerIdx in totalPlayer {
            self.playerMoneyLabels[playerIdx].text = "\(Constants.currencySymbol)\(table_amount.cleanValue2)"
            self.playerMoneyViews[playerIdx].isHidden = false
            self.startAnimation1(from: CGPoint(x: self.playerMoneyViews[playerIdx].frame.origin.x, y: self.playerMoneyViews[playerIdx].frame.origin.y), toPoint: CGPoint(x: self.bigMoneyAddView.frame.origin.x, y: self.bigMoneyAddView.frame.origin.y), view: self.playerMoneyViews[playerIdx], durarion: 0.8)
        }
        self.bigMoneyAddView.isHidden = false
        delay(0.75) {
            for ply in self.playerMoneyViews {
                ply.isHidden = true
            }
        }
    }
    
    private func resetPlayerView() {
        self.bottomView.isHidden = true
        self.bigMoneyAddView.isHidden = true
        for i in 0..<self.playerViews.count {
            playerImages[i].image = Constants.profileDefaultImage
            self.bigMoneyAddAmount.text = "\(Constants.currencySymbol)0.00"
            self.playerInviteImages[i].image = UIImage(named: "invite_user")
            playerNamesLbl[i].text = ""
            playerAmountView[i].isHidden = true
            playerCardTopImages[i].isHidden = true
            playerCardView[i].isHidden = true
            playerShowCardView[i].isHidden = true
            playerInviteImages[i].isHidden = false
            playerProgresses[i].isHidden = false
            self.winnerImages[i].isHidden = true
            self.winnerGIFImages[i].isHidden = true
            self.playerGiftBtns[i].isHidden = true
            self.winnerStarGIFImages[i].isHidden = true
//            playerProgresses[i].progress = 0.0
//            playerProgresses[i].resetProgress()
        }
    }
    
    private func startProgress(_ indexPly: Int) {
        playerProgresses[indexPly].isHidden = false
        if !progressStart[indexPly] {
            if self.game_logs.count > 0 && self.game_logs[0].user_id != myUserId {
                for j in 0..<self.playerGameData.count {
                    if self.playerGameData[j].user_id == self.game_logs[0].user_id {
//                        print("Current Animation: \(j)")
                        previouseChaalId = self.game_logs[0].user_id
                        self.playerToMainTable([j])
                        break
                    }
                }
            }
            playerProgresses[indexPly].trackColor = .lightGray
            playerProgresses[indexPly].progressColor = .goldenYellow
            playerProgresses[indexPly].progress = 1.0
            progressStart[indexPly] = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 38.0) {
//                self.stopAllProgress()
//            }
        }
        if self.currentChaalId == self.myUserId {
            self.bottomView.isHidden = false
            self.totalBalanceLbl.text = playerGameData[indexPly].wallet.cleanValue2
            self.chaalBalLabel.text = "CHAAL \(self.table_amount.cleanValue2)"
        }
    }
    
    private func stopAllProgress() {
        for i in 0..<playerProgresses.count {
            playerProgresses[i].isHidden = true
            playerProgresses[i].resetProgress()
            progressStart[i] = false
        }
    }
    
    private func makeSeencard(_ userId: Int, cardSeen: Int) {
        for i in 0..<playerGameData.count {
            if playerGameData[i].user_id == userId {
                user_packs[i] = 0
                if i == 0 {
                    self.isSeenUser = cardSeen != 0
                } else {
                    if cardSeen == 0 {
                        self.playerCardTopImages[i].image = UIImage(named: "blind")
                    } else {
                        self.playerCardTopImages[i].image = UIImage(named: "seen")
                    }
                }
                return
            }
        }
    }
    
    private func setCardImages(_ cardModel: GameCardModel, userid: Int) {
        for playerIndex in 0..<playerGameData.count {
            if userid == playerGameData[playerIndex].user_id {
                allPlayerCardImages[playerIndex][0].image = UIImage(named: cardModel.card1)
                allPlayerCardImages[playerIndex][1].image = UIImage(named: cardModel.card2)
                allPlayerCardImages[playerIndex][2].image = UIImage(named: cardModel.card3)
                playerCardView[playerIndex].isHidden = false
                playerShowCardView[playerIndex].isHidden = false
                playerCardTopImages[playerIndex].isHidden = true
                if playerIndex > 0 {
                    playerCardView[playerIndex].isHidden = true
                }
                break
            }
        }
       
    }
    
    private func resetAllPlayerCards() {
        for i in 0..<allPlayerCardImages.count {
            for j in 0..<allPlayerCardImages[i].count {
                allPlayerCardImages[i][j].image = UIImage(named: "backside_card")
            }
        }
        self.playerShowCardView.forEach { object in
            object.isHidden = true
        }
    }
    
    private func player1FirstCard() {
        self.myCardButton.isHidden = true
        self.playerCardView[0].isHidden = false
        self.player1CardImages[0].isHidden = true
        self.player1CardImages[1].isHidden = true
        self.player1CardImages[2].isHidden = true
        self.startAnimation(from: CGPoint(x: self.cardMainImageView.frame.origin.x, y: self.cardMainImageView.frame.origin.y), toPoint: CGPoint(x: self.playerCardView[0].frame.origin.x, y: (self.playerCardView[0].frame.origin.y + 20.0)), view: self.cardMainImageView)
        delay(cardAniDura) {
            self.player1CardImages[0].isHidden = false
        }
//        self.startAnimation(from: CGPoint(x: self.cardMainImageView.frame.origin.x, y: self.cardMainImageView.frame.origin.y), toPoint: CGPoint(x: self.playerCardView[0].frame.origin.x, y: (self.playerCardView[0].frame.origin.y)), view: self.cardMainImageView)
    }
    private func player1SecondCard() {
        self.startAnimation(from: CGPoint(x: self.cardMainImageView.frame.origin.x, y: self.cardMainImageView.frame.origin.y), toPoint: CGPoint(x: self.playerCardView[0].frame.origin.x + (self.player1CardImages[0].frame.size.width * 1.0), y: (self.playerCardView[0].frame.origin.y + 20.0)), view: self.cardMainImageView)
        delay(cardAniDura) {
            self.player1CardImages[1].isHidden = false
        }
    }
    private func player1ThirdCard() {
        self.startAnimation(from: CGPoint(x: self.cardMainImageView.frame.origin.x, y: self.cardMainImageView.frame.origin.y), toPoint: CGPoint(x: self.playerCardView[0].frame.origin.x + (self.player1CardImages[0].frame.size.width * 2.0), y: (self.playerCardView[0].frame.origin.y + 20.0)), view: self.cardMainImageView)
        delay(cardAniDura) {
            self.player1CardImages[2].isHidden = false
        }
    }
    
    private func otherPlayerCard(_ index: Int, cardIndex: Int) {
        if index == 0 && cardIndex > 0 {
            if cardIndex == 1 {
                player1FirstCard()
            } else if cardIndex == 2 {
                player1SecondCard()
            } else {
                player1ThirdCard()
            }
        } else {
//        let playerX = index != 0 ? self.playerCardAnimationViews[index].frame.origin.x + self.playerViews[index].frame.origin.x - 10.0 : self.playerCardAnimationViews[index].frame.origin.x + 10.0
//        let playerY = self.playerCardAnimationViews[index].frame.origin.y + 30.0
            self.startAnimation(from: CGPoint(x: self.cardMainImageView.frame.origin.x, y: self.cardMainImageView.frame.origin.y), toPoint: CGPoint(x: self.playerCardAnimationViews[index].frame.origin.x, y: self.playerCardAnimationViews[index].frame.origin.y), view: self.cardMainImageView)
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
    
    private func setCardAnimation(_ players: [Int]) {
        let delayTime = cardAniDura
        self.cardMainImageView.isHidden = false
        self.cardMainImageView1.isHidden = false
        if players.count > 0 {
            var count = 0
            _ = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: true){ t in
                self.otherPlayerCard(players[count], cardIndex: 1)
                count += 1
                if count >= players.count {
                    t.invalidate()
                }
            }
            
            delay(delayTime * Double(players.count)) {
                var count1 = 0
                _ = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: true){ t in
                    self.otherPlayerCard(players[count1], cardIndex: 2)
                    count1 += 1
                    if count1 >= players.count {
                        t.invalidate()
                    }
                }
            }
            
            delay((delayTime * Double(players.count) * 2.0)) {
                var count2 = 0
                _ = Timer.scheduledTimer(withTimeInterval: delayTime, repeats: true){ t in
                    self.otherPlayerCard(players[count2], cardIndex: 3)
                    count2 += 1
                    if count2 >= players.count {
                        t.invalidate()
                    }
                }
            }
            
            
            //player1 first card
            /*self.otherPlayerCard(players[0], cardIndex: 1)
            self.delay(delayTime) {
                if players.count > 1 {
                    //Player2 first card
                    self.otherPlayerCard(players[1], cardIndex: 1)
                    self.delay(delayTime) {
                        if players.count > 2 {
                            //Player3 first card
                            self.otherPlayerCard(players[2], cardIndex: 1)
                            self.delay(delayTime) {
                                if players.count > 3 {
                                    //Player4 first card
                                    self.otherPlayerCard(players[3], cardIndex: 1)
                                    self.delay(delayTime) {
                                        if players.count > 4 {
                                            self.delay(delayTime) {  //Player5 first card
                                                self.otherPlayerCard(players[4], cardIndex: 1)
                                                self.delay(delayTime) { //player1 Second card
                                                    self.otherPlayerCard(players[0], cardIndex: 2)
                                                    self.delay(delayTime) { //Player2 second card
                                                        self.otherPlayerCard(players[1], cardIndex: 2)
                                                        self.delay(delayTime) { //Player3 second card
                                                            self.otherPlayerCard(players[2], cardIndex: 2)
                                                            self.delay(delayTime) { //Player4 second card
                                                                self.otherPlayerCard(players[3], cardIndex: 2)
                                                                self.delay(delayTime) { //Player5 second card
                                                                    self.otherPlayerCard(players[4], cardIndex: 2)
                                                                    self.delay(delayTime) { //player1 third card
                                                                        self.otherPlayerCard(players[0], cardIndex: 3)
                                                                        self.delay(delayTime) { //player2 third card
                                                                            self.otherPlayerCard(players[1], cardIndex: 3)
                                                                            self.delay(delayTime) { //player3 third card
                                                                                self.otherPlayerCard(players[2], cardIndex: 3)
                                                                                self.delay(delayTime) {  //player4 third card
                                                                                    self.otherPlayerCard(players[3], cardIndex: 3)
                                                                                    self.delay(delayTime) {
                                                                                        //player5 third card
                                                                                        self.otherPlayerCard(players[4], cardIndex: 3)
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            //player1 Second card
                                            self.otherPlayerCard(players[0], cardIndex: 2)
                                            self.delay(delayTime) {
                                                //Player2 second card
                                                self.otherPlayerCard(players[1], cardIndex: 2)
                                                self.delay(delayTime) {
                                                    //Player3 second card
                                                    self.otherPlayerCard(players[2], cardIndex: 2)
                                                    self.delay(delayTime) {
                                                        //Player4 second card
                                                        self.otherPlayerCard(players[3], cardIndex: 2)
                                                        self.delay(delayTime) {
                                                            //player1 third card
                                                            self.otherPlayerCard(players[0], cardIndex: 3)
                                                            self.delay(delayTime) {
                                                                //player2 third card
                                                                self.otherPlayerCard(players[1], cardIndex: 3)
                                                                self.delay(delayTime) {
                                                                    //player3 third card
                                                                    self.otherPlayerCard(players[2], cardIndex: 3)
                                                                    self.delay(delayTime) {
                                                                        //player4 third card
                                                                        self.otherPlayerCard(players[3], cardIndex: 3)
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    //player1 Second card
                                    self.otherPlayerCard(players[0], cardIndex: 2)
                                    self.delay(delayTime) {
                                        //Player2 second card
                                        self.otherPlayerCard(players[1], cardIndex: 2)
                                        self.delay(delayTime) {
                                            //Player3 second card
                                            self.otherPlayerCard(players[2], cardIndex: 2)
                                            self.delay(delayTime) {
                                                //player1 third card
                                                self.otherPlayerCard(players[0], cardIndex: 3)
                                                self.delay(delayTime) {
                                                    //player2 third card
                                                    self.otherPlayerCard(players[1], cardIndex: 3)
                                                    self.delay(delayTime) {
                                                        //player3 third card
                                                        self.otherPlayerCard(players[2], cardIndex: 3)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        } else {
                            //player1 Second card
                            self.otherPlayerCard(players[0], cardIndex: 2)
                            //Player2 second card
                            self.delay(delayTime) {
                                self.otherPlayerCard(players[1], cardIndex: 3)
                                //player1 third card
                                self.delay(delayTime) {
                                    self.otherPlayerCard(players[0], cardIndex: 3)
                                    //player2 third card
                                    self.delay(delayTime) {
                                        self.otherPlayerCard(players[1], cardIndex: 3)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    self.otherPlayerCard(players[0], cardIndex: 2)
                    self.delay(delayTime) {
                        self.otherPlayerCard(players[0], cardIndex: 3)
                    }
                }
            }*/
        }
        
        /* for i in 0..<players.count {
         if players[i] == 1 {
         //                    self.startAnimation(from: CGPoint(x: self.cardMainImageView.frame.origin.x, y: self.cardMainImageView.frame.origin.y), toPoint: CGPoint(x: self.playerCardView[i].frame.origin.x, y: (self.playerCardView[i].frame.origin.y)), view: self.cardMainImageView)
         //                    delay(delayTime) {
         //                        self.startAnimation(from: CGPoint(x: self.cardMainImageView.frame.origin.x, y: self.cardMainImageView.frame.origin.y), toPoint: CGPoint(x: self.playerCardView[i].frame.origin.x + (self.player1CardImages[0].frame.size.width * 1.0), y: (self.playerCardView[i].frame.origin.y)), view: self.cardMainImageView)
         //                        self.delay(delayTime) {
         //                            self.startAnimation(from: CGPoint(x: self.cardMainImageView.frame.origin.x, y: self.cardMainImageView.frame.origin.y), toPoint: CGPoint(x: self.playerCardView[i].frame.origin.x + (self.player1CardImages[0].frame.size.width * 2.0), y: (self.playerCardView[i].frame.origin.y)), view: self.cardMainImageView)
         //                        }
         //                    }
         //                } else {
         delay(delayTime) {
         self.startAnimation(from: CGPoint(x: self.cardMainImageView.frame.origin.x, y: self.cardMainImageView.frame.origin.y), toPoint: CGPoint(x: self.playerCardAnimationViews[i].frame.origin.x, y: self.playerCardAnimationViews[i].frame.origin.y), view: self.cardMainImageView)
         self.delay(delayTime) {
         self.startAnimation(from: CGPoint(x: self.cardMainImageView.frame.origin.x, y: self.cardMainImageView.frame.origin.y), toPoint: CGPoint(x: self.playerCardAnimationViews[i].frame.origin.x, y: self.playerCardAnimationViews[i].frame.origin.y), view: self.cardMainImageView)
         self.delay(delayTime) {
         self.startAnimation(from: CGPoint(x: self.cardMainImageView.frame.origin.x, y: self.cardMainImageView.frame.origin.y), toPoint: CGPoint(x: self.playerCardAnimationViews[i].frame.origin.x, y: self.playerCardAnimationViews[i].frame.origin.y), view: self.cardMainImageView)
         }
         }
         }
         //                }
         }
         }*/
    }
    
    private func startAnimation(from fromPoint: CGPoint, toPoint: CGPoint, view: UIView) {
        let guide = view.safeAreaLayoutGuide
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = [fromPoint.x + guide.layoutFrame.width, fromPoint.y + guide.layoutFrame.height]
        animation.toValue = [toPoint.x, toPoint.y]
        
        animation.duration = cardAniDura
        view.layer.add(animation, forKey: "basic")
    }
    
    private func startAnimation1(from fromPoint: CGPoint, toPoint: CGPoint, view: UIView, durarion: Double) {
        let guide = view.safeAreaLayoutGuide
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = [fromPoint.x, fromPoint.y]
        animation.toValue = [toPoint.x + guide.layoutFrame.width, toPoint.y + guide.layoutFrame.height]
        
        animation.duration = durarion
        view.layer.add(animation, forKey: "basic")
    }
}

extension TeenPattiViewController: DialogViewDelegate {
    func setDialogData(_ model: GiftDataModel, senderTag: Int) {
        if senderTag == -1 {
            if gameGiftTag > 0 {
                self.playerGiftBtns[gameGiftTag].sd_setImage(with: URL(string: model.image), for: .normal, placeholderImage: UIImage(named: "gift"), context: [:])
            }
        } else {
            switch senderTag {
            case 0: // Close
                break
            case 1: // Back to lobby
                leaveGame()
                break
            case 2: // Exit Game
                leaveGame(1)
                break
            case 3: // Switch Table
                switchTable()
                break
            default:
                break
            }
        }
        
    }
}
