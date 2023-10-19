//
//  RummyPointViewController.swift
//  Lets Card
//
//  Created by Durgesh on 20/01/23.
//

import UIKit
import SwiftyJSON

class RummyPointViewController: UIViewController {
    
    @IBOutlet weak var scrollViewV: UIScrollView!
    @IBOutlet weak var cardsView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var collectionViewV: UICollectionView!
    @IBOutlet weak var mainLabelStackView: UIStackView!

    @IBOutlet weak var dropButton: UIButton!
    @IBOutlet weak var changeCardButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var declareButton: UIButton!
    @IBOutlet weak var groupButton: UIButton!
    @IBOutlet weak var discardButton: UIButton!
    @IBOutlet weak var splitCardButton: UIButton!

    @IBOutlet weak var countDownView: UIStackView!
    @IBOutlet weak var countDownLabel: UILabel!
    @IBOutlet weak var gameIdLabel: UILabel!
    
    @IBOutlet weak var gameMessageView: UIStackView!
    @IBOutlet weak var gameMessageLbl: UILabel!
    
    @IBOutlet var playerViews: [UIView]!
    @IBOutlet var playerImages: [UIImageView]!
    @IBOutlet var playerProgresses: [CircularProgressView]!
    @IBOutlet var playerNamesLbl: [UILabel]!
    @IBOutlet var playerAmountView: [UIView]!
    @IBOutlet var playerAmountLbl: [UILabel]!
    @IBOutlet var winnerLbl: [UILabel]!
    @IBOutlet var winnerGIFImages: [UIImageView]!
    @IBOutlet var winnerStarGIFImages: [UIImageView]!
    
    @IBOutlet weak var jokerCard: RotatableImageView!
    @IBOutlet weak var middleCardImage: UIImageView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var finishCardImage: UIImageView!
    @IBOutlet weak var finishJockerIconCard: UIImageView!

    @IBOutlet weak var middleCardImage1: UIImageView!
    @IBOutlet weak var pickCardImage1: UIImageView!
    @IBOutlet weak var middleCardView: UIView!
    @IBOutlet weak var middleJockerIconCard: UIImageView!
    @IBOutlet weak var dropHereView: UIView!
    
    @IBOutlet weak var firstLifeImage: UIImageView!
    @IBOutlet weak var secondLifeImage: UIImageView!
    
    @IBOutlet weak var resultGameIdLbl: UILabel!
    @IBOutlet weak var getReadyTextLbl: UILabel!
    @IBOutlet weak var jockerWinnerImage: UIImageView!
    @IBOutlet weak var winnerView: UIView!
    @IBOutlet weak var pickCardView: UIView!
    @IBOutlet weak var tableViewWinner: UITableView!
    @IBOutlet weak var playerXMidConstraint: NSLayoutConstraint!
    @IBOutlet weak var playerYMidConstraint: NSLayoutConstraint!

    var isPlayer2 = false
    var table_id = -1
    var boot_value = ""
    var min_entry = 0

    private var active_game_id = ""
    private var timerStatus = Timer()
    private var gameStartTimer = Timer()
    private var nextGameTimer = Timer()
    private var declareGameTimer = Timer()
    private var gameStartTime = 2
    private var nextGameTime = 30
    private var declareGameTime = 30
    private let myUserId = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    private var table_amount = 0.0
    private var currentChaalId = -1
    private var winner_user_id = -1
    private var game_status = 0
    
    private var playerGameData = [GameTablePlayer]()
    private var tableDetail = TableDetailData()
    private var game_users = [GameCardModel]()
    private var game_users_cards = [GameCardModel]()
    private var myCardList = [RummyCardModel]()
    private var myGroupCardList = [[RummyCardModel]]()
    private var myGroupCardValList = [Int]()
    private var selectedCards = [RummyCardModel]()
    private var selectedCardButtons = [IndexPath]()
    private var gameUsersCardList = [RummyGameUser]()
    private var isGameStatus = false
      
    private var isGamePacked = false
    private var isGameStarted = false
    private var game_declare = false
    private var opponent_game_declare = false
    private var isFirstGame = false
    private var isCardPick = false
    private var isFinishDesk = false
    private var hasSetMyCards = false
    private var jokerCardName = ""
    private var jokerCardModel = RummyCardModel()
    private var isCardPicked = false
    private var isFirstChall = true
    private var isDropedCard = false
    private var progressStart = [false, false, false, false, false, false]
    let IS_SET = 6
    let PURE_SEQUENCE = 5
    let IMPURE_SEQUENCE = 4
    let INVALID = 0
    private var isDeclareBack = false
    private var isDeclared = false
    private var totalRowCount = 0
    private var totalCardPoints = 0
    private var addedToGroup = false
    
//    var dragAndDropManager : KDDragAndDropManager?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.winnerView.isHidden = true
        self.cardsView.isHidden = true
        if table_id == -1 {
            getTables()
        } else {
            isGameStatus = true
            checkGameStatus()
        }
        if isPlayer2 {
            for i in 2..<self.playerViews.count {
                self.playerViews[i].isHidden = true
            }
            self.playerXMidConstraint.constant = 0.0
            self.playerYMidConstraint.constant = -((UIScreen.main.bounds.height / 2.0) - 60.0)
        } else {
            self.playerXMidConstraint.constant = -((UIScreen.main.bounds.width / 2.0) - 100.0)
            self.playerYMidConstraint.constant = -25.0
        }
        self.playerViews[1].layoutIfNeeded()
//        self.dragAndDropManager = KDDragAndDropManager(canvas: self.view, collectionViews: [collectionViewV])
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        collectionViewV.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let targetIndexPath = collectionViewV.indexPathForItem(at: gesture.location(in: collectionViewV)) else {
                return
            }
            addedToGroup = true
            collectionViewV.beginInteractiveMovementForItem(at: targetIndexPath)
            if selectedCards.firstIndex(where: { $0.card_id == myGroupCardList[targetIndexPath.section][targetIndexPath.row].card_id }) == nil {
                var selectCard = myGroupCardList[targetIndexPath.section][targetIndexPath.row]
                selectCard.isSelected = false
                selectedCards.append(selectCard)
            }
            if targetIndexPath.row == 0, let cell = collectionViewV.cellForItem(at: targetIndexPath) as? CardCollectionViewCell {
                cell.statusView.isHidden = true
            }
            break
        case .changed:
            collectionViewV.updateInteractiveMovementTargetPosition(gesture.location(in: collectionViewV))
            break
        case .ended:
            let currentDropLocation = gesture.location(in: self.view)
            if currentDropLocation.x >= self.middleCardView.frame.origin.x  && currentDropLocation.x <= self.middleCardView.frame.origin.x + self.middleCardView.frame.size.width && currentDropLocation.y >= self.middleCardView.frame.origin.y && currentDropLocation.y <= self.middleCardView.frame.origin.y + self.middleCardView.frame.size.height {
                addedToGroup = false
                collectionViewV.endInteractiveMovement()
                if self.currentChaalId != self.myUserId {
                    Toast.makeToast("Wait for you chaal")
                    return
                }
                if !isCardPicked {
                    Toast.makeToast("Please pick card first")
                    return
                }
                if selectedCards.count > 0 {
                    self.dropCard()
                } else {
                    Toast.makeToast("Please select atleast one Card")
                }
            } else if currentDropLocation.x >= self.dropHereView.frame.origin.x && currentDropLocation.x <= self.dropHereView.frame.origin.x + self.dropHereView.frame.size.width && currentDropLocation.y >= self.dropHereView.frame.origin.y && currentDropLocation.y <= self.dropHereView.frame.origin.y + self.dropHereView.frame.size.height {
                addedToGroup = false
                collectionViewV.endInteractiveMovement()
                if self.selectedCards.count > 0 {
                    PromptVManager.present(self, titleString: "Finish", messageString: "Are you sure, you want to finish ? You will lose this game by 40 points.", viewTag: 3)
                } else {
                    Toast.makeToast("Please select atleast one Card")
                }
            } else {
                selectedCards.removeAll()
            }
            collectionViewV.endInteractiveMovement()
            self.totalCardPoints = 0
            delay(0.5) {
                self.collectionViewV.reloadData()
                self.pointsLabel.text = "\(self.totalCardPoints)"
                self.delay(0.5) {
                    self.setFirstSecondLife()
                }
            }
            break
        default:
            collectionViewV.cancelInteractiveMovement()
            break
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
        nextGameTimer.invalidate()
        declareGameTimer.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func startDeclareGameTimer() {
        if declareGameTimer.isValid {
            declareGameTimer.invalidate()
        }
        declareGameTimer = Timer(timeInterval: 1, target: self, selector: #selector(self.updateDeclareBackTime), userInfo: nil, repeats: true)
        RunLoop.main.add(self.declareGameTimer, forMode: .default)
        declareGameTimer.fire()
    }
    
    @objc private func updateDeclareBackTime() {
        declareGameTime -= 1
        if declareGameTime == 0 {
            isDeclared = false
        }
        if declareGameTime < 0 {
            if declareGameTimer.isValid {
                declareGameTimer.invalidate()
            }
            declareGameTime = 30
            return
        }
        self.declareButton.setTitle("DECLARE \(declareGameTime)", for: .normal)
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
//            self.isCardAnimationDone = false
//            self.plusBottomButton.isEnabled = true
            self.cardsView.isHidden = false
            self.startGame()
        }
        if gameStartTime < 0 {
            self.countDownView.isHidden = true
            if gameStartTimer.isValid {
                gameStartTimer.invalidate()
            }
            gameStartTime = 8
            if !isGameStatus {
                checkGameStatus()
            }
            return
        }
        self.countDownView.isHidden = false
        self.countDownLabel.text = "Round will start in \(gameStartTime) second"
    }
    
    @IBAction func tapOnBackButton(_ sender: UIButton) {
        PromptVManager.present(self, titleString: "CONFIRMATOIN", messageString: "Are you sure, you want to Leave ?", viewTag: 1)
//        let alertView = UIAlertController(title: "CONFIRMATOIN", message: "Are you sure, you want to Leave ?", preferredStyle: .alert)
//
//        alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
//            self.leaveGame()
//        }))
//
//        alertView.addAction(UIAlertAction(title: "No", style: .destructive))
//        self.present(alertView, animated: true)
    }
    
    @IBAction func tapOnInfoButton(_ sender: UIButton) {
        if let myObject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: DialogInfoViewController().className) as? DialogInfoViewController {
            myObject.isInformationView = true
            myObject.gameType = GameTypes.point_rummy
            self.navigationController?.present(myObject, animated: true)
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
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
extension RummyPointViewController {
    @IBAction func tapOnBottomButtons(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            // Drop card
            if self.isDropedCard {
                return
            }
            let loosPoint = isFirstChall ? 20 : 40
            PromptVManager.present(self, titleString: "Drop", messageString: "Are you sure, you want to drop ? You will lose this game by \(loosPoint) points.", viewTag: 2)
//            let alertView = UIAlertController(title: "Drop", message: "Are you sure, you want to drop ? You will lose this game by \(loosPoint) points.", preferredStyle: .alert)
//            alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
//                self.isDropedCard = true
//                self.packGame()
//            }))
//            alertView.addAction(UIAlertAction(title: "No", style: .destructive))
//            self.present(alertView, animated: true)
            break
        case 1:
            // Change card
            break
        case 2:
            // Finish
            if self.selectedCards.count > 0 {
                PromptVManager.present(self, titleString: "Finish", messageString: "Are you sure, you want to finish ? You will lose this game by 40 points.", viewTag: 3)
            } else {
                Toast.makeToast("Please select atleast one Card")
            }
//            let alertView = UIAlertController(title: "Finish", message: "Are you sure, you want to finish ? You will lose this game by 40 points.", preferredStyle: .alert)
//            alertView.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
//                self.isDropedCard = true
//                self.isFinishDesk = true
//                if self.selectedCards.count > 0 {
//                    self.dropCard()
//                } else {
//                    Toast.makeToast("Please select atleast one Card")
//                }
//            }))
//            alertView.addAction(UIAlertAction(title: "No", style: .destructive))
//            self.present(alertView, animated: true)
            break
        case 3:
            // Declare
            self.declareGame()
            break
        case 4:
            // Group
            if selectedCards.count < 3 {
                Toast.makeToast("Minimum 3 cards Needed For Grouping")
                return
            }
            addNewGroup()
            break
        case 5:
            // Discard
            if self.currentChaalId != self.myUserId {
                Toast.makeToast("Wait for you chaal")
                return
            }
            if !isCardPicked {
                Toast.makeToast("Please pick card first")
                return
            }
            if selectedCards.count > 0 {
                self.dropCard()
            } else {
                Toast.makeToast("Please select atleast one Card")
            }
            break
        case 6:
            // Split Card
            break
        default:
            break
        }
    }
    
    @IBAction func tapOnPickCard(_ sender: UIButton) {
        if self.currentChaalId != myUserId {
            Toast.makeToast("Wait for you chaal")
            return
        }
        if sender.tag == 0 {
            self.getDropCard()
        } else {
            self.getCard()
        }
    }
    
    @IBAction func tapOnWinnerClose(_ sender: UIButton) {
        self.winnerView.isHidden = true
    }
}

// MARK: API Call
extension RummyPointViewController {
    private func getTables() {
        DispatchQueue.global(qos: .background).async { [self] in
            APIClient.shared.post(parameters: RummyTableRequest(no_of_players: isPlayer2 ? "2" : "5", boot_value: boot_value), feed: .rummy_get_table, showLoading: false, responseKey: "table_data") { result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse, response.code == 200, let tableDataArr = response.data_array, tableDataArr.count > 0 {
                        var tableArr = [GameTablePlayer]()
                        tableDataArr.forEach { object in
                            tableArr.append(GameTablePlayer(object))
                        }
                        self.table_id = tableArr.first?.table_id ?? -1
//                        self.checkGameStatus()
                    } else if let code = apiResponse?.code, code == 406 {
//                        self.leaveGame()
                        if let message = apiResponse?.message {
                            Toast.makeToast(message)
                        }
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
    
    private func startGame() {
        DispatchQueue.global(qos: .background).async {
//            if self.gameStartTimer.isValid {
                DispatchQueue.main.async {
                    self.countDownView.isHidden = true
                }
                APIClient.shared.post(parameters: GameRequest(), feed: .rummy_start_game, showLoading: false, responseKey: "all") { [self] result in
                    isFirstChall = true
                    self.collectionViewV.isHidden = false
                    self.game_declare = false
                    self.opponent_game_declare = false
                    self.isDropedCard = false
                    stopAllProgress()
                    hasSetMyCards = false
                    switch result {
                    case .success(let apiResponse):
                        if let response = apiResponse, response.code == 200 {
                            if let gameId = response.data?["game_id"].string {
                                self.active_game_id = gameId
                            }
//                            print(response)
                        }
                        
                        self.gameStatus()
                        break
                    case .failure(_):
    //                    Toast.makeToast(error.localizedDescription)
                        break
                    }
                }
//            }
        }
    }
    
    private func leaveGame() {
        DispatchQueue.global(qos: .background).async { [self] in
            var jsonArray = [Dictionary<String, Any>]()
            for grp in 0..<myGroupCardList.count {
                var jsonDictonary = Dictionary<String, Any>()
                jsonDictonary["card_group"] = self.myGroupCardValList[grp]
                jsonDictonary["cards"] = myGroupCardList[grp].map({ $0.card_id })
                jsonArray.append(jsonDictonary)
            }
            stopAllProgress()
            APIClient.shared.post(parameters: RummyDeclareCardRequest(json: self.json(from: jsonArray) ?? ""), feed: .rummy_leave_table, showLoading: false, responseKey: "card") { result in
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    break
                }
                self.timerStatus.invalidate()
                self.gameStartTimer.invalidate()
                self.dismiss(animated: true)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func getDropCard() {
        DispatchQueue.global(qos: .background).async { [self] in
            var jsonArray = [Dictionary<String, Any>]()
           
            for grp in 0..<myGroupCardList.count {
                var jsonDictonary = Dictionary<String, Any>()
                jsonDictonary["card_group"] = self.myGroupCardValList[grp]
                jsonDictonary["cards"] = myGroupCardList[grp].map({ $0.card_id })
                jsonArray.append(jsonDictonary)
            }
            
            APIClient.shared.post(parameters: RummyDeclareCardRequest(json: self.json(from: jsonArray) ?? ""), feed: .rummy_get_drop_card, showLoading: false, responseKey: "card") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse {
                        if response.code == 200 {
                            isFirstChall = false
                            self.dropButton.isHidden = true
                            if let cards = response.data_array, cards.count > 0 {
                                selectedCardButtons.removeAll()
                                selectedCards.removeAll()
                                selectedCards.append(RummyCardModel(cards[0]))
                                isCardPicked = true
                                self.addNewGroup()
                                DispatchQueue.main.async {
                                    self.startAnimation(from: CGPoint(x: self.middleCardView.frame.origin.x, y: self.middleCardView.frame.origin.y), toPoint: CGPoint(x: ((UIScreen.main.bounds.size.width / 2.0)), y: self.cardsView.frame.origin.y), view: self.middleCardImage1)
                                }
                            }
                        }
                    }
                    break
                case .failure(_):
                    break
                }
                self.isDropedCard = false
                self.gameStatus()
            }
        }
    }
    
    private func packGame() {
        DispatchQueue.global(qos: .background).async { [self] in
            var jsonArray = [Dictionary<String, Any>]()
            for grp in 0..<myGroupCardList.count {
                var jsonDictonary = Dictionary<String, Any>()
                jsonDictonary["card_group"] = self.myGroupCardValList[grp]
                jsonDictonary["cards"] = myGroupCardList[grp].map({ $0.card_id })
                jsonArray.append(jsonDictonary)
            }
            stopAllProgress()
            APIClient.shared.post(parameters: RummyDeclareCardRequest(json: self.json(from: jsonArray) ?? ""), feed: .rummy_pack_game, showLoading: false, responseKey: "") { result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse {
                        if response.code == 200 {
                            if let message = response.message {
                                Toast.makeToast(message)
                            }
                            self.dropButton.isHidden = true
                        }
                    }
                    break
                case .failure(_):
                    break
                }
                self.gameStatus()
                self.game_declare = false
                self.opponent_game_declare = false
                self.isFinishDesk = false
            }
        }
    }
    
    private func declareGame() {
        DispatchQueue.global(qos: .background).async { [self] in
            var jsonArray = [Dictionary<String, Any>]()
            for grp in 0..<myGroupCardList.count {
                var jsonDictonary = Dictionary<String, Any>()
                jsonDictonary["card_group"] = self.myGroupCardValList[grp]
                jsonDictonary["cards"] = myGroupCardList[grp].map({ $0.card_id })
                jsonArray.append(jsonDictonary)
            }
            DispatchQueue.main.async {
                self.declareButton.isHidden = true
            }
            stopAllProgress()
            APIClient.shared.post(parameters: RummyDeclareCardRequest(json: self.json(from: jsonArray) ?? ""), feed: isDeclareBack ? .rummy_declare_back : .rummy_declare, showLoading: false, responseKey: "") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse {
                        if response.code == 200 {
                            game_declare = true
                            self.collectionViewV.isHidden = true
                            if let message = response.message {
                                Toast.makeToast(message)
                            }
                        }
                    }
                    break
                case .failure(_):
                    break
                }
                if self.declareGameTimer.isValid {
                    self.declareGameTimer.invalidate()
                    declareGameTime = 30
                }
                self.declareButton.isHidden = true
                isFinishDesk = false
                self.gameStatus()
                self.dropButton.isHidden = true
            }
        }
    }
    
    
    private func getCard() {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameRequest(), feed: .rummy_get_card, showLoading: false, responseKey: "card") { [self] result in
                switch result {
                case .success(let apiResponse):
                    if let response = apiResponse {
                        if response.code == 200 {
                            self.dropButton.isHidden = true
                            if let cards = response.data_array, cards.count > 0 {
                                selectedCardButtons.removeAll()
                                selectedCards.removeAll()
                                selectedCards.append(RummyCardModel(cards[0]))
                                isCardPicked = true
                                self.addNewGroup()
                                DispatchQueue.main.async {
                                    self.startAnimation(from: CGPoint(x: self.pickCardView.frame.origin.x + 35.0, y: self.pickCardView.frame.origin.y), toPoint: CGPoint(x: ((UIScreen.main.bounds.size.width / 2.0)), y: self.cardsView.frame.origin.y), view: self.pickCardImage1)
                                }
                            }
                        }
                    }
                    break
                case .failure(_):
                    break
                }
            }
        }
    }
    
    private func getMyCards() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async { [self] in
                self.mainStackView.removeAllArrangedSubviews()
                self.mainLabelStackView.removeAllArrangedSubviews()
                self.myCardList = [RummyCardModel]()
                self.myGroupCardList.removeAll()
                totalRowCount = 0
                self.myGroupCardValList.removeAll()
            }
            
            APIClient.shared.post(parameters: RummyMyCardRequest(game_id: self.active_game_id), feed: .rummy_my_card, showLoading: false, responseKey: "cards") { [self] result in
                switch result {
                case .success(let apiResponse):
                    self.dropButton.isHidden = false
//                    game_declare = false;
//                    opponent_game_declare = false;
                    //                            isFinishDesk = false;
                    //                            isFirstChall = true;
                    isGameStarted = false;
                    isGamePacked = false;
                    isCardPick = false;
                    //                            isResentCardDrop = false;]
                    if let response = apiResponse, response.code == 200, let myCards = response.data_array, myCards.count > 0 {
                        isGameStarted = true
                        myCardList = [RummyCardModel]()
                        myCards.forEach { object in
                            let cardModel = RummyCardModel(object)
                            myCardList.append(cardModel)
                        }
                        isCardPick = myCards.count > 13
                        hasSetMyCards = true
                        self.setMyCards(myCardList)
                    } else {
                        self.gameMessageView.isHidden = false
                        self.gameMessageLbl.text = "\"Please Wait\" game is going on."
                    }
                    break
                case .failure(_):
                    break
                }
            }
        }
    }
    
    private func dropCard() {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async { [self] in
                print(selectedCards)
                let selectedCardId = self.selectedCards[0].card_id
                var jsonArray = [Dictionary<String, Any>]()
                for grp in 0..<myGroupCardList.count {
                    var jsonDictonary = Dictionary<String, Any>()
                    jsonDictonary["card_group"] = self.myGroupCardValList[grp]
                    jsonDictonary["cards"] = myGroupCardList[grp].map({ $0.card_id })
                    jsonArray.append(jsonDictonary)
                }
                APIClient.shared.post(parameters: RummyDropCardRequest(card: selectedCardId, json: self.json(from: jsonArray) ?? ""), feed: .rummy_drop_card, showLoading: false, responseKey: "") { result in
                    switch result {
                    case .success(let apiResponse):
                        if let response = apiResponse {
                            if response.code == 200 {
                                self.dropButton.isHidden = false
                                self.changeCardButton.isHidden = true
                                self.finishButton.isHidden = true
                                self.middleCardImage.image = UIImage(named: self.selectedCards[0].card)
                                self.middleJockerIconCard.isHidden = true
                                if self.selectedCards[0].cardNumber == self.jokerCardModel.cardNumber {
                                    self.middleJockerIconCard.isHidden = false
                                }
                                self.addNewGroup(true)
                                self.discardButton.isHidden = true
                                self.stopAllProgress()
                            } else if let message = response.message {
                                Toast.makeToast(message)
                            }
                            self.isCardPicked = false
                        }
                        break
                    case .failure(_):
                        break
                    }
                    self.gameStatus()
                }
            }
        }
    }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    //isMyChaal
    @objc private func gameStatus() {
        DispatchQueue.global(qos: .background).async {
//            print("Game id: \(self.active_game_id)")
//            print("Table id: \(self.table_id)")

            APIClient.shared.post(parameters: GameStatusRequest(game_id: self.active_game_id, table_id: self.table_id == -1 ? "" : "\(self.table_id)"), feed: .rummy_status, showLoading: false, responseKey: "all") { [self] result in

                switch result {
                case .success(let apiResponse):
                    //print("GameStatus Response: \(apiResponse)")
                    self.playerGameData = [GameTablePlayer]()
                    self.gameMessageView.isHidden = true
                    self.dropButton.isHidden = false
                    if let responseCode = apiResponse?.code, responseCode == 403 {
                        if let response = apiResponse, let message = response.message, !message.isEmpty {
                            Toast.makeToast(message)
                        }
                        self.dismiss(animated: true)
                        self.navigationController?.popViewController(animated: true)
                    } else if let response = apiResponse {
                        if let tableUsersArray = response.data?["table_users"].array {
                            tableUsersArray.forEach { object in
                                let gamePlayer = GameTablePlayer(object)
                                if gamePlayer.user_id == self.myUserId {
                                    self.playerGameData.insert(gamePlayer, at: 0)
                                } else {
                                    self.playerGameData.append(gamePlayer)
                                }
                            }
                        }
                        if self.playerGameData.count > 0 && self.playerGameData[0].user_id != self.myUserId {
                            Toast.makeToast("Your are timeout from this table Join again.")
                            leaveGame()
                            return
                        }
                        
                        if let tableDetails = response.data?["table_detail"].dictionary {
                            tableDetail = TableDetailData(JSON(tableDetails))
                            min_entry = Int((tableDetail.boot_value / 80.0) * 100)
                        }
                        table_amount = 0.0
                        if let tableAmount = response.data?["table_amount"].doubleValue {
                            self.table_amount = tableAmount
                        }
                        self.active_game_id = ""
                        if let activeGameId = response.data?["active_game_id"].string, activeGameId != "0" {
                            self.active_game_id = activeGameId
                        }
                        self.gameIdLabel.text = "#\(active_game_id)  Rummy Point \(playerAmountLbl[0].text ?? "")"
                        if table_amount > 0 {
                            self.gameIdLabel.text = "\(self.gameIdLabel.text ?? "")   Prize \(table_amount)"
                        }
                        self.game_users = [GameCardModel]()
//                        self.playerCountTotal = 0
                        self.gameMessageView.isHidden = true
                        if let gameUsers = response.data?["game_users"].array {
                            //                            if gameUsers.contains(where: { $0["user_id"].intValue == myUserId }) {
                            for i in 0..<gameUsers.count {
                                let gameUsr = GameCardModel(gameUsers[i])
                                if gameUsr.user_id == myUserId {
                                    if gameUsr.packed == 1 {
                                        isGameStarted = false
                                        isGamePacked = true
                                        // Reset all players activity
                                        self.gameMessageView.isHidden = false
                                        self.gameMessageLbl.text = "Continuous \"Please Wait\" after initial round of Win."
                                    } else {
                                        isGamePacked = false
                                    }
                                }
                                self.game_users.append(gameUsr)
                            }
                            //                            }
                        }
                        self.currentChaalId = -1
                        self.middleCardImage.image = UIImage(named: "backside_card")
                        self.finishCardImage.isHidden = true
                        self.middleJockerIconCard.isHidden = true
                        self.finishJockerIconCard.isHidden = true
                        if response.code == 200 {
                            if let chaal = response.data?["chaal"].string {
                                self.currentChaalId = Int(chaal) ?? -1
                            }
//                            if let cutpoint = response.data?["cut_point"].int {
//                                print("cutpoint: \(cutpoint)")
//                            }
//                            if let lastcard = response.data?["last_card"].dictionary {
//                                print("lastcard: \(lastcard)")
//                            }
                            
//                            print("CurrentChaalId: \(currentChaalId) - MyUserId: \(myUserId)")
//                            if let cards = response.data?["cards"].array {
//                                cards.forEach { object in
//                                    myCards.append(RummyCardModel(object))
//                                }
//                            }
                            if let jokerCard = response.data?["joker"].string {
                                jokerCardModel = RummyCardModel(JSON(), jokerCardName: jokerCard)
                                self.jokerCard.image = UIImage(named: jokerCardModel.card)
                            }
                            
                            if let gameUserCards = response.data?["game_users_cards"].array, gameUserCards.count > 0 {
                               gameUsersCardList = [RummyGameUser]()
                                gameUserCards.forEach { object in
                                    gameUsersCardList.append(RummyGameUser(object))
                                }
                                if gameUsersCardList.count > 0 {
                                    self.declareButton.isHidden = true
                                    self.hideAllBottomButtons()
                                    self.jockerWinnerImage.image = UIImage(named: jokerCardModel.card)
                                    self.winnerView.isHidden = false
                                    self.tableViewWinner.reloadData()
                                    self.showGameUserPopup()
                                }
                            }
                           
                            game_status = -1
                            if let gameStatus = response.data?["game_status"].int {
                                game_status = gameStatus
//                                print("gameStatus Int: ", gameStatus)
                            } else if let gameStatus = response.data?["game_status"].string {
//                                print("gameStatus str: ", gameStatus)
                                game_status = Int(gameStatus) ?? 0
                            }
                            var declare_userid = -1
                            if let declareuserid = response.data?["declare_user_id"].int {
//                                print("declare_user_id: ", declareuserid)
                                declare_userid = declareuserid
                            }
                            var declared = false
                            if let declr = response.data?["declare"].bool {
//                                print("declare: ", declr)
                                declared = declr
                            }
                            
                            if declare_userid == myUserId && declared && !game_declare {
                                declareButton.isHidden = false
                            } else if declare_userid != myUserId && declared {
                                opponent_game_declare = true
                                Toast.makeToast("Your opponent declare the game")
                                dropButton.isHidden = true
                                if game_declare {
                                    declareButton.isHidden = true
                                } else {
                                    declareButton.isHidden = false
                                }
                                if !isDeclared {
                                    isDeclareBack = true
                                    self.startDeclareGameTimer()
                                }
                            } else {
                                declareButton.isHidden = true
                            }
                           
                            if let dropCards = response.data?["drop_card"].array, dropCards.count > 0 {
                                let dropCard = RummyCardModel(dropCards[0])
//                                print("dropCards: \(dropCards)")
                                
                                if dropCard.cardNumber == jokerCardModel.cardNumber {
                                    self.middleJockerIconCard.isHidden = false
                                }
                                self.middleCardImage.image = UIImage(named: dropCard.card)
                                if opponent_game_declare || game_declare {
                                    if dropCard.cardNumber == jokerCardModel.cardNumber {
                                        self.finishJockerIconCard.isHidden = false
                                    }
                                    self.finishCardImage.image = UIImage(named: dropCard.card)
                                    self.finishCardImage.isHidden = false
                                }
                            } else {
                                self.middleCardImage.image = UIImage(named: "backside_card")
                            }
                            self.winner_user_id = -1
                            if let winnerUserId = response.data?["winner_user_id"].string {
                                self.winner_user_id = Int(winnerUserId) ?? -1
                            }
                            if game_status == 2 || game_status == 0 {
                                isGameStarted = false
                                // Reset all players activity
                                
                                //Make winner to winner id
                                if !isFirstGame {
                                    
                                }
                            } else if game_status == 1 {
                                if !hasSetMyCards {
                                    self.getMyCards()
                                }
                            }
                        }
                        if isFinishDesk {
                            self.finishGameNow()
                        }
                        if myUserId == currentChaalId {
                            self.cardsView.isHidden = false
                        }
                        setGamePlayerData()
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

// MARK: Set game data
extension RummyPointViewController {
    private func setGamePlayerData() {
        for i in 0..<self.playerViews.count {
            playerProgresses[i].isHidden = false //true
            self.winnerLbl[i].isHidden = true
            self.winnerGIFImages[i].isHidden = true
            self.winnerStarGIFImages[i].isHidden = true
        }
        for i in 0..<playerGameData.count {
            playerImages[i].sd_setImage(with: URL(string: playerGameData[i].profile_pic), placeholderImage: Constants.profileDefaultImage, context: nil)
            playerNamesLbl[i].text = playerGameData[i].name
            playerAmountLbl[i].text = playerGameData[i].wallet.cleanValue2
            playerAmountView[i].isHidden = playerGameData[i].wallet <= 0.0
            
            if playerGameData[i].user_id == self.winner_user_id {
                self.stopAllProgress()
                if game_users.contains(where: { $0.user_id == myUserId }) {
//                    self.winnerLbl[i].isHidden = false
                    self.winnerGIFImages[i].isHidden = false
                    self.winnerStarGIFImages[i].isHidden = false
                    self.winnerGIFImages[i].image = UIImage.gif(name: "giphy")
                    self.winnerStarGIFImages[i].image = UIImage.gif(name: "star")
                }
            } else {
                if playerGameData[i].user_id != 0 && game_users.contains(where: { $0.user_id == myUserId }) && playerGameData[i].user_id == self.currentChaalId {
                    startProgress(i)
                }
            }
        }
    }
    
    private func finishGameNow() {
        var isDeclareVisible = true
        if !opponent_game_declare {
            for i in 0..<myGroupCardList.count {
                let isPureSequence = RummyCardModel.isPureSequence(myGroupCardList[i])
                var isImPureSequence = false
                var isSets = false
                if !isPureSequence {
                    isImPureSequence = RummyCardModel.isImPureSequence(myGroupCardList[i], jokerCard: self.jokerCardModel)
                    if !isImPureSequence {
                        isSets = RummyCardModel.isSets(myGroupCardList[i], jokerCard: myGroupCardList[i].contains(where: { $0.cardNumber == self.jokerCardModel.cardNumber }) ? self.jokerCardModel : nil)
                    }
                }
                if !isPureSequence && !isImPureSequence && !isSets {
                    isDeclareVisible = false
                    break
                }
            }
        }
        self.dropButton.isHidden = true
	
        if isFinishDesk && isDeclareVisible {
            self.declareGame()
        } else {
            self.packGame()
        }
    }
    
    private func restartGameActivity() {
        self.dropButton.isHidden = true
        self.game_declare = false
        opponent_game_declare = false
    }
    
    private func completerGameUIChange() {
        self.dropButton.isHidden = true
    }
       
    private func startProgress(_ indexPly: Int) {
        playerProgresses[indexPly].isHidden = false
        if !progressStart[indexPly] {
            playerProgresses[indexPly].trackColor = .lightGray
            playerProgresses[indexPly].progressColor = .goldenYellow
            playerProgresses[indexPly].timeToFill = 50
            playerProgresses[indexPly].progress = 1.0
            progressStart[indexPly] = true
        }
    }
    
    private func stopAllProgress() {
        DispatchQueue.main.async { [self] in
            for i in 0..<playerProgresses.count {
                playerProgresses[i].isHidden = false// true
                playerProgresses[i].resetProgress()
                progressStart[i] = false
            }
        }
    }
    
    private func showGameUserPopup() {
        if nextGameTimer.isValid {
            nextGameTimer.invalidate()
        }
        DispatchQueue.main.async {
            self.mainStackView.removeAllArrangedSubviews()
            self.mainLabelStackView.removeAllArrangedSubviews()
            self.cardsView.isHidden = true
        }
        
        myCardList = [RummyCardModel]()
        self.myGroupCardList.removeAll()
        totalRowCount = 0
        self.myGroupCardValList.removeAll()
        timerStatus.invalidate()
        isGameStatus = false
        self.timerStatus.invalidate()
        self.timerStatus.invalidate()
        nextGameTime = 30
        nextGameTimer = Timer(timeInterval: 1, target: self, selector: #selector(self.nextGameStartTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(self.nextGameTimer, forMode: .default)
        nextGameTimer.fire()
        
        self.getReadyTextLbl.text = "Get Ready - Next game start in \(nextGameTime) second(s)"
    }
    
    @objc private func nextGameStartTimer() {
        nextGameTime -= 1
        self.getReadyTextLbl.text = "Get Ready - Next game start in \(nextGameTime) second(s)"
        self.gameMessageView.isHidden = false
        self.gameMessageLbl.text = "Get Ready - Next game start in \(nextGameTime) second(s)"
        if nextGameTime == 0 {
            self.countDownView.isHidden = true
            if gameStartTimer.isValid {
                gameStartTimer.invalidate()
            }
            gameStartTime = 8
            self.startGame()
            delay(2.0) {
                self.checkGameStatus()
            }
        }
        if nextGameTime < 0 {
            self.winnerView.isHidden = true
            if nextGameTimer.isValid {
                nextGameTimer.invalidate()
            }
            self.gameMessageView.isHidden = true
            nextGameTime = 30
            return
        }
    }
        
    private func setMyCards(_ myCards: [RummyCardModel]) {
        self.cardsView.isHidden = false
        var count = 0

        let mainStckView = UIStackView()
        mainStckView.alignment = .bottom
        mainStckView.distribution = .fillEqually
        mainStckView.spacing = -18
        self.mainStackView.addArrangedSubview(mainStckView)
        
        _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true){ t in
            self.startAnimation(from: CGPoint(x: self.middleCardView.frame.origin.x, y: self.middleCardView.frame.origin.y), toPoint: CGPoint(x: ((UIScreen.main.bounds.size.width / 2.0)), y: self.cardsView.frame.origin.y), view: self.middleCardImage1)
            self.delay(0.1) {
                if myCards.count > count {
                    let button = UIButton(type: .custom)
                    button.setImage(UIImage(named: "backside_card"), for: .normal)
                    button.tag = count
                    button.layer.setValue(0, forKey: "stackViewIndex")
                    button.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40.0))
                    button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50.0))
                    
                    let stackView = UIStackView()
                    stackView.tag = count
                    stackView.alignment = .bottom
                    stackView.addArrangedSubview(button)
                    mainStckView.addArrangedSubview(stackView)
                }
                count += 1
                if count > myCards.count {
                    t.invalidate()
                    self.makeCardGroups()
                }
            }
        }
    }
    
    private func makeCardGroups() {
        let gropCardList = Dictionary(grouping: self.myCardList, by: { $0.card_group })
        self.myGroupCardList.removeAll()
        totalRowCount = 0
        self.myGroupCardValList.removeAll()
        for _ in 0..<14 {
            self.myGroupCardList.append([RummyCardModel]())
            self.myGroupCardValList.append(0)
        }
        self.mainStackView.removeAllArrangedSubviews()
        self.mainLabelStackView.removeAllArrangedSubviews()
        for grp in gropCardList {
            totalRowCount += grp.value.count + 1
            switch grp.key.lowercased() {
            case "rs":
                self.myGroupCardList[0] = grp.value
                break
            case "rp":
                self.myGroupCardList[1] = grp.value
                break
            case "bl":
                self.myGroupCardList[2] = grp.value
                break
            case "bp":
                self.myGroupCardList[3] = grp.value
                break
            case "jk":
                self.myGroupCardList[4] = grp.value
                break
            default:
                break
            }
        }
        self.cardsView.isHidden = true

        self.myGroupCardList.removeAll(where: { $0.count <= 0 })
        self.totalCardPoints = 0
        self.collectionViewV.reloadData()
        delay(0.5) {
            self.pointsLabel.text = "\(self.totalCardPoints)"
            self.setFirstSecondLife()
        }
        hideAllBottomButtons()
        self.dropButton.isHidden = false
    }
    
    private func setFirstSecondLife() {
        var isFirstLife = false
        var isSecondLife = false
 
        self.firstLifeImage.image = UIImage(named: "ic_uncheckbox")
        self.secondLifeImage.image = UIImage(named: "ic_uncheckbox")
        for i in myGroupCardValList {
            if i == PURE_SEQUENCE && !isFirstLife {
                // First life
                isFirstLife = true
                self.firstLifeImage.image = UIImage(named: "ic_checkbox")
            } else if isFirstLife && i == PURE_SEQUENCE && !isSecondLife {
                // Second Life
                isSecondLife = true
                self.secondLifeImage.image = UIImage(named: "ic_checkbox")
            } else if i == IMPURE_SEQUENCE && !isSecondLife {
                // Second Life
                self.secondLifeImage.image = UIImage(named: "ic_checkbox")
            }
        }
    }

    private func addNewGroup(_ isRemove: Bool = false) {
        var tempGroupCards = self.myGroupCardList
        if selectedCardButtons.count > 0 {
            selectedCardButtons = selectedCardButtons.sorted(by: { $0.row > $1.row })
            for grpBtn in selectedCardButtons {
                if tempGroupCards[grpBtn.section].count > grpBtn.row {
                    tempGroupCards[grpBtn.section].remove(at: grpBtn.row)
                }
            }
        }
        tempGroupCards.removeAll(where: { $0.count <= 0 })
        self.myGroupCardList = tempGroupCards
        if !isRemove {
            self.myGroupCardList.append(selectedCards)
        } else {
            var isRemovedd = false
            for i in 0..<tempGroupCards.count {
                for j in 0..<tempGroupCards[i].count {
                    for selCrd in selectedCards {
                        if tempGroupCards[i].count > j && tempGroupCards[i][j].card_id == selCrd.card_id {
                            tempGroupCards[i].remove(at: j)
                            isRemovedd = true
                            break
                        }
                    }
                    if isRemovedd {
                        break
                    }
                }
                if isRemovedd {
                    break
                }
            }
            if isRemovedd {
                self.myGroupCardList = tempGroupCards
            }
        }
        self.mainStackView.removeAllArrangedSubviews()
        self.mainLabelStackView.removeAllArrangedSubviews()
        self.myGroupCardValList.removeAll()
        
        for _ in 0..<14 {
            self.myGroupCardValList.append(0)
        }
        self.totalRowCount = 0
        for grp in myGroupCardList {
            self.totalRowCount += grp.count + 1
            for var cardgrp in grp {
                cardgrp.isSelected = false
            }
//            self.createGroup(myGroupCardList[i], index: i)
        }
        self.totalCardPoints = 0
        self.collectionViewV.reloadData()
        delay(0.5) {
            self.pointsLabel.text = "\(self.totalCardPoints)"
            self.setFirstSecondLife()
        }
//        if self.mainStackView != nil && self.mainLabelStackView != nil {
//            let widthConstraint = NSLayoutConstraint(item: self.mainStackView!, attribute: .width, relatedBy: .equal, toItem: self.mainLabelStackView!, attribute: .width, multiplier: 1.0, constant: 0.0)
//            widthConstraint.isActive = true
//        }
        selectedCards.removeAll()
        selectedCardButtons.removeAll()
        self.groupButton.isHidden = true
    }
    
    private func startAnimation(from fromPoint: CGPoint, toPoint: CGPoint, view: UIView) {
        let guide = view.safeAreaLayoutGuide
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = [fromPoint.x + (guide.layoutFrame.width / 2.0), fromPoint.y + (guide.layoutFrame.height / 2.0)]
        animation.toValue = [toPoint.x, toPoint.y + 30.0]
        
        animation.duration = 0.3
        view.layer.add(animation, forKey: "basic")
    }
    
    private func hideAllBottomButtons() {
//        self.dropButton.isHidden = true
        self.changeCardButton.isHidden = true
        self.finishButton.isHidden = true
//        self.declareButton.isHidden = true
        self.groupButton.isHidden = true
        self.discardButton.isHidden = true
        self.splitCardButton.isHidden = true
    }
}

// MARK: Winner game tableview DataSource
extension RummyPointViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gameUsersCardList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: RummyWinnerTableViewCell.identifier, for: indexPath) as? RummyWinnerTableViewCell {
            cell.configure(self.gameUsersCardList[indexPath.row].user, myUserId: self.myUserId, winnerUserId: self.winner_user_id, jokerCardName: self.jokerCardModel.card)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: Winner game tableview Delegate
extension RummyPointViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: Alert Prompt Delegate
extension RummyPointViewController: PromptViewDelegate {
    func didActionOnPromptButton(_ tag: Int) {
        switch tag {
        case 1: // Leave Table
            self.leaveGame()
            break
        case 2: // Drop Game
            self.isDropedCard = true
            self.packGame()
            break
        case 3: // Finish Game
            self.isDropedCard = true
            self.isFinishDesk = true
            self.dropCard()
            break
        default:
            break
        }
    }
}

extension RummyPointViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.myGroupCardList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.myGroupCardList[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.identifier, for: indexPath) as? CardCollectionViewCell {
            cell.topConstraint.constant = self.myGroupCardList[indexPath.section][indexPath.row].isSelected ? 0.0 : 20.0
            cell.cardImage.image = UIImage(named: self.myGroupCardList[indexPath.section][indexPath.row].card)
            cell.statusView.isHidden = indexPath.row != 0
            cell.jokerCardView.isHidden = jokerCardModel.cardNumber != self.myGroupCardList[indexPath.section][indexPath.row].cardNumber
          
            if indexPath.row == 0 {
                var totalPoints = 0
                var card_group_value = INVALID
                let isPureSequence = RummyCardModel.isPureSequence(myGroupCardList[indexPath.section])
                var isImPureSequence = false
                var isSets = false
                if !isPureSequence {
                    isImPureSequence = RummyCardModel.isImPureSequence(myGroupCardList[indexPath.section], jokerCard: self.jokerCardModel)
                    if !isImPureSequence {
                        isSets = RummyCardModel.isSets(myGroupCardList[indexPath.section], jokerCard: myGroupCardList[indexPath.section].contains(where: { $0.cardNumber == self.jokerCardModel.cardNumber }) ? self.jokerCardModel : nil)
                    }
                }
                
                if isSets {
                    card_group_value = IS_SET
                } else if isImPureSequence {
                    card_group_value = IMPURE_SEQUENCE
                } else if isPureSequence {
                    card_group_value = PURE_SEQUENCE
                }
                self.myGroupCardValList[indexPath.section] = card_group_value
                for crd in myGroupCardList[indexPath.section] {
                    if jokerCardModel.cardNumber != crd.cardNumber {
                        if crd.cardNumber >= 10 || crd.cardNumber == 1 {
                            totalPoints += 10
                        } else {
                            totalPoints += crd.cardNumber
                        }
                    }
                }
               
                cell.statusImage.backgroundColor = .systemGreen
                cell.statusImage.tintColor = .black
                cell.statusImage.image = UIImage(systemName: "checkmark.circle.fill")
                cell.statusLabel.text = "Invalid(99)"
                
                if isPureSequence {
                    cell.statusLabel.text = "Pure"
                } else if isImPureSequence {
                    cell.statusLabel.text = "Impure"
                } else if isSets {
                    cell.statusLabel.text = "Set"
                } else {
                    if totalPoints <= 0 {
                        totalPoints = 0
                    }
                    self.totalCardPoints += totalPoints
                    cell.statusLabel.text = "Invalid(\(totalPoints))"
                    cell.statusImage.backgroundColor = .white
                    cell.statusImage.image = UIImage(systemName: "multiply.circle.fill")
                }
                cell.statusViewLeading.constant = 0
                if self.myGroupCardList[indexPath.section].count == 1 {
                    cell.statusViewLeading.constant = -14
                } else if self.myGroupCardList[indexPath.section].count == 2 {
                    cell.statusViewLeading.constant = -8
                } else if self.myGroupCardList[indexPath.section].count > 3 {
                    cell.statusViewLeading.constant = 5
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let index = selectedCards.firstIndex(where: { $0.card_id == myGroupCardList[indexPath.section][indexPath.row].card_id }) {
            selectedCards.remove(at: index)
            if selectedCardButtons.count > index {
                selectedCardButtons.remove(at: index)
            }
        } else {
            selectedCardButtons.append(indexPath)
            var selectCard = myGroupCardList[indexPath.section][indexPath.row]
            selectCard.isSelected = false
            selectedCards.append(selectCard)
        }
        myGroupCardList[indexPath.section][indexPath.row].isSelected = !myGroupCardList[indexPath.section][indexPath.row].isSelected
        self.totalCardPoints = 0
        self.collectionViewV.reloadData()
        delay(0.5) {
            self.pointsLabel.text = "\(self.totalCardPoints)"
        }
        
        self.hideAllBottomButtons()
        if selectedCards.count == 1 {
            if self.currentChaalId == myUserId {
                self.discardButton.isHidden = false
            }
            self.finishButton.isHidden = false
        } else if selectedCards.count > 1 {
            self.groupButton.isHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 22.0, height: 70.0)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "customHeader", for: indexPath)
            headerView.backgroundColor = .clear
            return headerView
        default:
            fatalError("This should never happen!!")
        }
    }
    
    // Re - Order
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = myGroupCardList[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        if addedToGroup {
            myGroupCardList[destinationIndexPath.section].insert(item, at: destinationIndexPath.row)
        }
    }
    /*func collectionView(_ collectionView: UICollectionView, dataItemForIndexPath indexPath: IndexPath) -> AnyObject {
        return myGroupCardList[indexPath.section][indexPath.item] as AnyObject
    }
    
    func collectionView(_ collectionView: UICollectionView, insertDataItem dataItem : AnyObject, atIndexPath indexPath: IndexPath) -> Void {
//        print("Index: \(dataItem)")
        if let di = dataItem as? RummyCardModel {
            myGroupCardList[indexPath.section].insert(di, at: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath : IndexPath) -> Void {
        myGroupCardList[indexPath.section].remove(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, moveDataItemFromIndexPath from: IndexPath, toIndexPath to : IndexPath) -> Void {
        let fromDataItem = myGroupCardList[from.section][from.row]
        myGroupCardList[from.section].remove(at: from.row)
        myGroupCardList[from.section].insert(fromDataItem, at: to.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> IndexPath? {
        guard let candidate = dataItem as? RummyCardModel else { return nil }
        for sec in 0..<myGroupCardList.count {
            for (i,item) in myGroupCardList[sec].enumerated() {
                if candidate != item { continue }
//                print("Get current index\(IndexPath(item: i, section: sec))")
                return IndexPath(item: i, section: sec)
            }
        }
        return nil
        
    }*/
}

/*extension RummyPointViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: "\(indexPath)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = self.myGroupCardList[indexPath.section][indexPath.row]
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        let itemProvider = NSItemProvider(object: "\(indexPath)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = self.myGroupCardList[indexPath.section][indexPath.row]
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionWillBegin session: UIDragSession) {
        var itemsToInsert = [IndexPath]()
        (0 ..< self.myGroupCardList.count).forEach {
            itemsToInsert.append(IndexPath(item: self.myGroupCardList[$0].count, section: $0))
//            self.myGroupCardList[$0].append(.availableToDrop)
        }
        collectionView.insertItems(at: itemsToInsert)
    }
    
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
            var removeItems = [IndexPath]()
//            for section in 0..<self.myGroupCardList.count {
//                for item in  0..<self.myGroupCardList[section].count {
//                    switch self.myGroupCardList[section][item] {
//                        case .availableToDrop: removeItems.append(IndexPath(item: item, section: section))
//                        case .simple: break
//                    }
//                }
//            }
            removeItems.forEach { self.myGroupCardList[$0.section].remove(at: $0.item) }
            collectionView.deleteItems(at: removeItems)
        }
}*/

extension RummyPointViewController: UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        print(section)
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth: CGFloat = flowLayout.itemSize.width
        let cellSpacing: CGFloat = flowLayout.minimumInteritemSpacing
        var cellCount = CGFloat(totalRowCount - 1)//CGFloat(collectionView.numberOfItems(inSection: section))
        var collectionWidth = collectionView.frame.size.width
        var totalWidth: CGFloat
        if #available(iOS 11.0, *) {
            collectionWidth -= collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
        }
        repeat {
            totalWidth = cellWidth * cellCount + cellSpacing * (cellCount - 1)
            cellCount -= 1
        } while totalWidth >= collectionWidth

        if (totalWidth > 0 && section == 0) {
            let edgeInset = (collectionWidth - totalWidth) / 2
            return UIEdgeInsets.init(top: flowLayout.sectionInset.top, left: edgeInset, bottom: flowLayout.sectionInset.bottom, right: 0)
        } else {
            return flowLayout.sectionInset
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 22.0, height: 70.0)
    }
 }


/*private func createGroup(_ cards: [RummyCardModel], index: Int) {
    self.myCardsUIList[index].removeAll()
    let mainStckView = APRedorderableStackView()
    mainStckView.alignment = .bottom
    mainStckView.distribution = .fillEqually
    mainStckView.spacing = -12
    mainStckView.tag = index
//        var jokerNumber = self.jokerCardName
//        jokerNumber = String(jokerNumber.dropFirst(2))
    var totalPoints = 0
    
    var card_group_value = INVALID
    let isPureSequence = RummyCardModel.isPureSequence(cards)
    var isImPureSequence = false
    var isSets = false
    if !isPureSequence {
        isImPureSequence = RummyCardModel.isImPureSequence(cards, jokerCard: self.jokerCardModel)
        if !isImPureSequence {
            isSets = RummyCardModel.isSets(cards, jokerCard: cards.contains(where: { $0.cardNumber == self.jokerCardModel.cardNumber }) ? self.jokerCardModel : nil)
        }
    }
    
    if isSets {
        card_group_value = IS_SET
    } else if isImPureSequence {
        card_group_value = IMPURE_SEQUENCE
    } else if isPureSequence {
        card_group_value = PURE_SEQUENCE
    }
    self.myGroupCardValList[index] = card_group_value
    for i in 0..<cards.count {
        let button = UIButton(type: .custom)
        let bottomImage = UIImage(named: cards[i].card)
        
//            var cardNumber = cards[i].card
//            cardNumber = String(cardNumber.dropFirst(2))
//            cards[0].card_group =
        
        button.setImage(jokerCardModel.cardNumber == cards[i].cardNumber ? bottomImage?.mergeWith(topImage: UIImage(named: "ic_joker")!) : bottomImage, for: .normal)
        button.tag = i
        button.layer.setValue(index, forKey: "stackViewIndex")
        button.addTarget(self, action: #selector(self.tapOnCard(_:)), for: .touchUpInside)
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40.0))
        button.addConstraint(NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50.0))
        let buttonView = UIView()
        if jokerCardModel.cardNumber == cards[i].cardNumber {
            buttonView.addConstraint(NSLayoutConstraint(item: buttonView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40.0))
            buttonView.addConstraint(NSLayoutConstraint(item: buttonView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50.0))
//                buttonView.alpha = 0.5
            buttonView.backgroundColor = .white
            button.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 50.0)
            let xConstraint = NSLayoutConstraint(item: button, attribute: .centerX, relatedBy: .equal, toItem: buttonView, attribute: .centerX, multiplier: 1, constant: 0)
            let yConstraint = NSLayoutConstraint(item: button, attribute: .centerY, relatedBy: .equal, toItem: buttonView, attribute: .centerY, multiplier: 1, constant: 0)
            buttonView.addConstraint(xConstraint)
            buttonView.addConstraint(yConstraint)
//                button.alpha = 0.8
            buttonView.addSubview(button)
            //07927623264
            let btnView = UIView()
            btnView.backgroundColor = .white
            btnView.alpha = 0.6
            btnView.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 50.0)
            btnView.addConstraint(NSLayoutConstraint(item: btnView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40.0))
            btnView.addConstraint(NSLayoutConstraint(item: btnView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50.0))
            let xConstraint1 = NSLayoutConstraint(item: btnView, attribute: .centerX, relatedBy: .equal, toItem: buttonView, attribute: .centerX, multiplier: 1, constant: 0)
            let yConstraint1 = NSLayoutConstraint(item: btnView, attribute: .centerY, relatedBy: .equal, toItem: buttonView, attribute: .centerY, multiplier: 1, constant: 0)
            buttonView.addConstraint(xConstraint1)
            buttonView.addConstraint(yConstraint1)
            btnView.isUserInteractionEnabled = false
            buttonView.addSubview(btnView)
        } else {
            if cards[i].cardNumber >= 10 || cards[i].cardNumber == 1 {
                totalPoints += 10
            } else {
                totalPoints += cards[i].cardNumber
            }
        }
        
        let stackView = APRedorderableStackView()
        stackView.tag = i
        stackView.alignment = .bottom
        if jokerCardModel.cardNumber == cards[i].cardNumber {
            stackView.addArrangedSubview(buttonView)
        } else {
            stackView.addArrangedSubview(button)
        }
        stackView.addConstraint(NSLayoutConstraint(item: stackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 70.0))
        self.myCardsUIList[index].append(stackView)
        mainStckView.addArrangedSubview(stackView)
    }
            
    if cards.count > 0 {
        self.mainStackView.addArrangedSubview(mainStckView)

        let mainLBLStkView = UIStackView()
        mainLBLStkView.alignment = .center
        mainLBLStkView.spacing = 2
        //checkmark.circle.fill - Background color - .systemgreen
        //multiply.circle.fill - Background color - .white
        
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGreen
        imageView.tintColor = .black
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.image = UIImage(systemName: "checkmark.circle.fill")
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12.0))
        imageView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 12.0))
        mainLBLStkView.addArrangedSubview(imageView)
        
        let labelWidth = 28.0 * CGFloat(cards.count) + 20.0
//            if cards.count == 1 {
//                labelWidth = 28.0 * CGFloat(2) + 20.0
//            }
        if labelWidth > 0 {
            let labelS = UILabel()
            labelS.font = UIFont.systemFont(ofSize: 11.0)
            labelS.textColor = .white
            labelS.minimumScaleFactor = 0.75
          //  labelS.textAlignment = .center
            if isPureSequence {
                labelS.text = "Pure"
            } else if isImPureSequence {
                labelS.text = "Impure"
            } else if isSets {
                labelS.text = "Set"
            } else {
                if totalPoints <= 0 {
                    totalPoints = 0
                }
                labelS.text = "Invalid(\(totalPoints))"
                labelS.lineBreakMode = .byTruncatingMiddle
                imageView.backgroundColor = .white
                imageView.image = UIImage(systemName: "multiply.circle.fill")
            }
            mainLBLStkView.addArrangedSubview(labelS)
        }
        mainLBLStkView.addConstraint(NSLayoutConstraint(item: mainLBLStkView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: labelWidth))
        self.mainLabelStackView.addArrangedSubview(mainLBLStkView)
    }
}*/
