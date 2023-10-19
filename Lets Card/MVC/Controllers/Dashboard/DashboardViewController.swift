//
//  DashboardViewController.swift
//  Lets Card
//
//  Created by Durgesh on 16/12/22.
//

import UIKit
import SDWebImage
import SwiftyJSON
import AVFoundation

class DashboardViewController: UIViewController {
    
    //gameCell
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userIdLbl: UILabel!
    
    @IBOutlet weak var availableBalLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var inviteFrndBtn: UIButton!
    @IBOutlet weak var spinAndWinBtn: UIButton!
    
    @IBOutlet weak var bannerScrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    
    @IBOutlet var topButtons: [UIButton]!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImageEdit: UIImageView!
    @IBOutlet weak var profileMainView: UIView!

    private var allTotalGameList = [GameTypes]()
    private var totalGameList = [GameTypes]()
    private var cellSize = 140.0
    private var userProfileDt = ProfileData()
    private var settingProfileM = SettingModel()
    private var avatars = [String]()
    private var bannerList = [BannerModel]()
    private var userBankDetail = UserBankDetailModel()
    let redColour = UIColor(displayP3Red: 213.0 / 255.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    private var gifImages: [String: UIImage] = [:]
    var visibleIndexPath: IndexPath? = nil

    private var profileDataList = [ProfileCellData]()
    private var profilePicStr = ""
    private let imagePicker = UIImagePickerController()
    private var isProfileEdit = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        inviteFrndBtn.setImage(UIImage.gif(name: "home_lady"), for: .normal)
        spinAndWinBtn.setImage(UIImage.gif(name: "home_spin_win"), for: .normal)
        self.collectionView.isHidden = true
        setData()
        topButtons.forEach { button in
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.colors = [UIColor(hexString: "#efb304").cgColor, UIColor(hexString: "#e19303").cgColor]
            gradient.locations = [0.0 , 1.0]
            gradient.frame = CGRect(x: 0.0, y: 0.0, width: view.bounds.width - 20.0, height: button.bounds.height)
            button.layer.insertSublayer(gradient, at: 0)//(gradient)
            button.borderWidth = 2.0
            button.borderColor = .white
            button.cornerRadius = button.frame.size.height / 2.0
        }
        self.hideKeyboard()
        self.imagePicker.delegate = self
        self.profileMainView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUserProfile()
        
       /* var cards = [RummyCardModel]()

        var dic = Dictionary<String, Any>()
        dic["card"] = "BPA"
        cards.append(RummyCardModel(JSON(dic)))

        dic = Dictionary<String, Any>()
        dic["card"] = "BP2"
        cards.append(RummyCardModel(JSON(dic)))

        dic = Dictionary<String, Any>()
        dic["card"] = "BP3"
        cards.append(RummyCardModel(JSON(dic)))

        dic = Dictionary<String, Any>()
        dic["card"] = "JKS"
        let jokerCard = RummyCardModel(JSON(dic))

        var isPure = RummyCardModel.isPureSequence(cards)
        print("Pure: \(isPure)")
        isPure = RummyCardModel.isPureSequence(cards)
        print("Pure: \(isPure)")
        
        cards = [RummyCardModel]()
        dic = Dictionary<String, Any>()
        dic["card"] = "BPA"
        cards.append(RummyCardModel(JSON(dic)))

        dic = Dictionary<String, Any>()
        dic["card"] = "BPK"
        cards.append(RummyCardModel(JSON(dic)))

        dic = Dictionary<String, Any>()
        dic["card"] = "BPQ"
        cards.append(RummyCardModel(JSON(dic)))

        isPure = RummyCardModel.isPureSequence(cards)
        print("Pure: \(isPure)")
        isPure = RummyCardModel.isPureSequence(cards)
        print("Pure: \(isPure)")
        
        cards = [RummyCardModel]()
        dic = Dictionary<String, Any>()
        dic["card"] = "BPA"
        cards.append(RummyCardModel(JSON(dic)))

//        dic = Dictionary<String, Any>()
//        dic["card"] = "BPK"
//        cards.append(RummyCardModel(JSON(dic)))

        dic = Dictionary<String, Any>()
        dic["card"] = "BPQ"
        cards.append(RummyCardModel(JSON(dic)))
        
        cards.append(jokerCard)

        var isImPure = RummyCardModel.isImPureSequence(cards, jokerCard: jokerCard)
        print("isImPure: \(isImPure)")
        isImPure = RummyCardModel.isImPureSequence(cards, jokerCard: jokerCard)
        print("isImPure: \(isImPure)")
        
        cards = [RummyCardModel]()
        dic = Dictionary<String, Any>()
        dic["card"] = "BPA"
        cards.append(RummyCardModel(JSON(dic)))

//        dic = Dictionary<String, Any>()
//        dic["card"] = "BPK"
//        cards.append(RummyCardModel(JSON(dic)))

        dic = Dictionary<String, Any>()
        dic["card"] = "BP3"
        cards.append(RummyCardModel(JSON(dic)))
        
        cards.append(jokerCard)
        isImPure = RummyCardModel.isImPureSequence(cards, jokerCard: jokerCard)
        print("isImPure: \(isImPure)")
        isImPure = RummyCardModel.isImPureSequence(cards, jokerCard: jokerCard)
        print("isImPure: \(isImPure)")*/
    }
    
    // MARK: Keyboard will show
    @objc private func keyboardWillShowNotification (notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue  {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.tblBottomConstraint.constant = keyboardHeight
        }
    }
    
    // MARK: Keyboard will Hide
    @objc private func keyboardWillHideNotification (notification: Notification) {
        self.tblBottomConstraint.constant = 10.0
    }
    
    @IBAction func tapOnEditProfile(_ sender: UIButton) {
        isProfileEdit = !isProfileEdit
        self.setProfileData()
    }
    
    private func setProfileData() {
        self.profileDataList.removeAll()
        self.profileImage.sd_setImage(with: URL(string: userProfileDt.profile_pic), placeholderImage: Constants.appLogoImage, options: .refreshCached, context: nil)
        self.profileImageEdit.sd_setImage(with: URL(string: userProfileDt.profile_pic), placeholderImage: Constants.appLogoImage, options: .refreshCached, context: nil)
        self.profileDataList.append(ProfileCellData(title: "Name:", placeHolder: "Enter Name", value: userProfileDt.name))
        if !isProfileEdit {
            self.profileDataList.append(ProfileCellData(title: "Mobile no:", placeHolder: "Enter Mobile no", value: userProfileDt.mobile))
        }
        self.profileDataList.append(ProfileCellData(title: "UPI ID:", placeHolder: "Enter UPI ID:", value: userProfileDt.upi))
        self.profileDataList.append(ProfileCellData(title: "Bank details", placeHolder: "Enter Bank details", value: userProfileDt.bank_detail))
        self.profileDataList.append(ProfileCellData(title: "Aadhar card no.", placeHolder: "Enter Aadhar card no.", value: userProfileDt.adhar_card))
        if isProfileEdit {
            self.profileDataList.append(ProfileCellData())
        }
        self.tableView.reloadData()
    }
    
    
//    func getCardData() -> [JSON]? {
//       if let data = UserDefaults.standard.data(forKey: Constants.UserDefault.rummyWinner1) {
//           do {
//               // Create JSON Decoder
//               let decoder = JSONDecoder()
//
//               // Decode Note
//               let dataGame = try decoder.decode([JSON].self, from: data)
//               return dataGame
//           } catch {
//               print("Unable to Decode (\(error))")
//               return nil
//           }
//       }
//       return nil
//   }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cellSize = (self.collectionView.frame.size.height - 15.0) / 2.0
        self.collectionView.reloadData()
        self.collectionView.isHidden = false
    }
    
    private func setData() {
        if let userName = UserDefaults.standard.value(forKey: Constants.UserDefault.userName) as? String {
            self.userNameLbl.text = userName
        }
//        if let userId = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId) {
//            self.userIdLbl.text = "ID:\(userId)"
//        }
        allTotalGameList = [GameTypes]()
        if let gameOnOffData = GameOnOffModel.getData() {
            if gameOnOffData.teen_patti == 1 {
                allTotalGameList.append(.teen_patti)
            }
            if gameOnOffData.private_table == 1 {
                allTotalGameList.append(.private_table)
            }
            if gameOnOffData.custom_boot == 1 {
                allTotalGameList.append(.custom_boot)
            }
            if gameOnOffData.jackpot_teen_patti == 1 {
                allTotalGameList.append(.jackpot_teen_patti)
            }
            if gameOnOffData.point_rummy == 1 {
                allTotalGameList.append(.point_rummy)
            }
//            if gameOnOffData.private_rummy == 1 {
//                allTotalGameList.append(.private_rummy)
//            }
//            if gameOnOffData.pool_rummy == 1 {
//                allTotalGameList.append(.pool_rummy)
//            }
//            if gameOnOffData.deal_rummy == 1 {
//                allTotalGameList.append(.deal_rummy)
//            }
            if gameOnOffData.dragon_tiger == 1 {
                allTotalGameList.append(.dragon_tiger)
            }
            if gameOnOffData.andar_bahar == 1 {
                allTotalGameList.append(.andar_bahar)
            }
            if gameOnOffData.seven_up_down == 1 {
                allTotalGameList.append(.seven_up_down)
            }
            if gameOnOffData.car_roulette == 1 {
                allTotalGameList.append(.car_roulette)
            }
            if gameOnOffData.animal_roulette == 1 {
                allTotalGameList.append(.animal_roulette)
            }
            if gameOnOffData.color_prediction == 1 {
                allTotalGameList.append(.color_prediction)
            }
            if gameOnOffData.poker == 1 {
                allTotalGameList.append(.poker)
            }
            if gameOnOffData.head_tails == 1 {
                allTotalGameList.append(.head_tails)
            }
            if gameOnOffData.red_vs_black == 1 {
                allTotalGameList.append(.red_vs_black)
            }
            if gameOnOffData.ludo_local == 1 {
                allTotalGameList.append(.ludo_local)
            }
            if gameOnOffData.ludo_online == 1 {
                allTotalGameList.append(.ludo_online)
            }
            if gameOnOffData.ludo_computer == 1 {
                allTotalGameList.append(.ludo_computer)
            }
            if gameOnOffData.bacarate == 1 {
                allTotalGameList.append(.bacarate)
            }
            if gameOnOffData.jhandi_munda == 1 {
                allTotalGameList.append(.jhandi_munda)
            }
            if gameOnOffData.roulette == 1 {
                allTotalGameList.append(.roulette)
            }
            if gameOnOffData.tournament_rummy == 1 {
                allTotalGameList.append(.tournament_rummy)
            }
        }
        self.totalGameList = self.allTotalGameList
    }
}

// MARK: Actions
extension DashboardViewController {
    
    @IBAction func changeBannerPage(_ sender: UIPageControl) {
        let x = CGFloat(sender.currentPage) * self.bannerScrollView.frame.size.width
        self.bannerScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    @IBAction func tapOnGameTypes(_ sender: UIButton) {
        self.topButtons.forEach { button in
            button.setTitleColor(.black, for: .normal)
        }
        sender.setTitleColor(redColour, for: .normal)
        switch sender.tag {
        case 0:
            // ALL
            self.totalGameList = self.allTotalGameList
            break
        case 1:
            // MULTI
            self.totalGameList = allTotalGameList.filter({ $0.itemType == sender.titleLabel!.text!.lowercased() })
            break
        case 2:
            // SKILL
            self.totalGameList = allTotalGameList.filter({ $0.itemType == sender.titleLabel!.text!.lowercased() })
            break
        case 3:
            // SLOTS
            self.totalGameList = allTotalGameList.filter({ $0.itemType == sender.titleLabel!.text!.lowercased() })
            break
        default:
            break
        }
        self.collectionView.reloadData()
    }
    
    
    /// Top Middle Buttons
    @IBAction func tapOnTopButtons(_ sender: UIButton) {
        if sender.tag == 0 {
            self.profileMainView.isHidden = false
//            if let myobject = UIStoryboard(name: Constants.Storyboard.auth, bundle: nil).instantiateViewController(withIdentifier: ProfileViewController().className) as? ProfileViewController {
//                myobject.userProfileData = self.userProfileDt
//                myobject.avatars = self.avatars
//                myobject.userBankData = self.userBankDetail
//                myobject.delegate = self
//                self.present(myobject, animated: true, completion: nil)
//            }
        }
        // 0 - Profile
        // 1 - Add Cash
        // 2 - VIP
        // 3 - Gulak
    }
    
    /// Top Right Buttons
    @IBAction func tapOnRightButtons(_ sender: UIButton) {
        // 0 - Statement
        // 1 - Message
        // 2 - Contact US
        // 3 - Setting
        if sender.tag == 3 {
            PromptVManager.present(self, titleString: "CONFIRMATOIN", messageString: "Are you sure, you want to logout ?", viewTag: 1)
        }
    }
    
    /// Bottom buttons
    @IBAction func tapOnBottomButtons(_ sender: UIButton) {
        // 0 - First Recharge
        // 1 - Withdraw
        // 2 - Share
        // 3 - Shop
        // 4 - History
        // 5 - Lucky Slot
        // 6 - Add Cash
    }
    
    /// Middle GIF left Buttons
    @IBAction func tapOnMiddleButtons(_ sender: UIButton) {
        // 0 - Invite Friends
        // 1 - Spin and Win
        if sender.tag == 1 {
            Core.push(self, storyboard: Constants.Storyboard.other, storyboardId: SpinViewController().className)
        }
    }
}

extension DashboardViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        self.pageController.currentPage = Int(pageNumber)
    }
    
    @objc func timerAction() {
        if self.pageController.currentPage == self.bannerList.count - 1 {
            self.pageController.currentPage = 0
        } else {
            self.pageController.currentPage = self.pageController.currentPage + 1
        }
        DispatchQueue.main.async {
//            UIView.animate(withDuration: 1.0) {
                let x = CGFloat(self.pageController.currentPage) * self.bannerScrollView.frame.size.width
                self.bannerScrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
//            }x
        }
    }
}

// MARK: API Calls
extension DashboardViewController {
    private func getUserProfile() {
        APIClient.shared.post(parameters: ProfileRequest(), feed: .profile, responseKey: "all") { result in
            switch result {
            case .success(let aPIResponse):
                if let response = aPIResponse, response.code == 200, let responseData = response.data {
                    if let userData = responseData["user_data"].array, userData.count > 0 {
                        self.userProfileDt = ProfileData(userData[0])
                        ProfileData.storeData(self.userProfileDt)
                        self.profileImage.sd_setImage(with: URL(string: self.userProfileDt.profile_pic), placeholderImage: Constants.appLogoImage, context: nil)
                        self.userNameLbl.text = self.userProfileDt.name.uppercased()
                        self.userIdLbl.text = "ID:\(self.userProfileDt.id)"
                        self.availableBalLbl.text = "\(self.userProfileDt.wallet.cleanValuee)"
                        UserDefaults.standard.set(self.userProfileDt.referral_code, forKey: Constants.UserDefault.referralCode)
                        UserDefaults.standard.set(self.userProfileDt.name, forKey: Constants.UserDefault.userName)
                        UserDefaults.standard.set(self.userProfileDt.wallet, forKey: Constants.UserDefault.walletAmount)
                        UserDefaults.standard.set(self.userProfileDt.profile_pic, forKey: Constants.UserDefault.profilePic)
                    }
                    self.avatars = [String]()
                    if let avatarList = responseData["avatar"].array {
                        avatarList.forEach { object in
                            self.avatars.append(object.stringValue)
                        }
                    }
                    if let settings = responseData["setting"].dictionary {
                        self.settingProfileM = SettingModel(JSON(settings))
                        SettingModel.storeData(self.settingProfileM)
                        UserDefaults.standard.set(self.settingProfileM.referral_link, forKey: Constants.UserDefault.referralLink)
                    }
                    if let userbnkD = responseData["user_bank_details"].array, userbnkD.count > 0 {
                        self.userBankDetail = UserBankDetailModel(userbnkD[0])
                    }
                    self.bannerList = [BannerModel]()
                    if let bannerArr = responseData["app_banner"].array, bannerArr.count > 0 {
                        var originX = 0.0
                        bannerArr.forEach { object in
                            let bannerML = BannerModel(object)
                            let imgView = UIImageView(frame: CGRect(x: originX, y: 0.0, width: self.bannerScrollView.frame.size.width, height: self.bannerScrollView.frame.size.height))
                            imgView.contentMode = .scaleToFill
                            imgView.backgroundColor = .clear
                            imgView.sd_setImage(with: URL(string: "\(Constants.baseURL)\(APIClient.bannerPath)\(bannerML.banner)"), placeholderImage: UIImage(named: "app_icon 1")!, options: .refreshCached)
                            self.bannerScrollView.addSubview(imgView)
                            originX += self.bannerScrollView.frame.size.width
                            self.bannerList.append(bannerML)
                        }
                        self.bannerScrollView.contentSize = CGSize(width: self.bannerScrollView.frame.size.width * CGFloat(bannerArr.count), height: self.bannerScrollView.frame.size.height)
                        self.pageController.numberOfPages = bannerArr.count
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            let timer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
                            RunLoop.main.add(timer, forMode: .default)
                            timer.fire()
                        }
                    }
                }
                self.setProfileData()
                break
            case .failure(let error):
                Toast.makeToast(error.customDescription)
                break
            }
        }
    }
}


// MARK: Collection view data sources
extension DashboardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalGameList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "gameCell", for: indexPath) as? GameGridCollectionViewCell {
            let uniqueId = Int.random(in: Int.min...Int.max) //<-practically unique
            cell.tag = uniqueId //<-
            cell.imageV.image = nil
            if let image = gifImages[self.totalGameList[indexPath.row].imageName] {
                cell.imageV.image = image
            } else {
                DispatchQueue.global(qos: .default).async {
                    let gifImage = UIImage.gif(name: self.totalGameList[indexPath.row].imageName)
                    DispatchQueue.main.async {
                        if cell.tag == uniqueId { //<- check `cell.tag` is not changed
                            cell.imageV.image = gifImage
                            self.gifImages[self.totalGameList[indexPath.row].imageName] = gifImage
                        }
                    }
                }
            }
//            DispatchQueue.global(qos: .background).async {
//                DispatchQueue.main.async {
//                    cell.imageV.image = UIImage.gif(name: self.totalGameList[indexPath.row].imageName)
//                }
//            }
            cell.imageWidthConst.constant = cellSize + 30.0
            cell.imageHeightConst.constant = cellSize
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: Collection view flow layout
extension DashboardViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellSize + 30.0, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.alpha = 0.3
        cell.layer.transform = CATransform3DMakeScale(0.0, 0.0, 0.0)
        
        // Simple Animation
        UIView.animate(withDuration: 0.5) {
            cell.contentView.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch totalGameList[indexPath.row] {
        case .teen_patti:
            if let myobject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: ActiveTablesViewController().className) as? ActiveTablesViewController {
                myobject.gameType = .teen_patti
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .point_rummy:
            if let myobject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: DialogInfoViewController().className) as? DialogInfoViewController {
                myobject.isRummyView = true
                myobject.parentViewContr = self
                self.navigationController?.pushViewController(myobject, animated: true)
//                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .private_table:
            if userProfileDt.game_played > self.settingProfileM.game_for_private {
                if let myobject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: PopupViewController().className) as? PopupViewController {
                    myobject.gameType = .private_table
                    myobject.profileData = self.userProfileDt
                    self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
                }
            } else {
                Toast.makeToast("To Unblock Private Table you have to Play at least \(self.settingProfileM.game_for_private) Games.")
            }
            break
        case .custom_boot:
            if let myobject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: PopupViewController().className) as? PopupViewController {
                myobject.gameType = .custom_boot
                myobject.profileData = self.userProfileDt
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .jackpot_teen_patti:
            if let myobject = UIStoryboard(name: Constants.Storyboard.smallGame, bundle: nil).instantiateViewController(withIdentifier: Jackpot3PattiViewController().className) as? Jackpot3PattiViewController {
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .private_rummy:
            break
        case .pool_rummy:
            break
        case .deal_rummy:
            break
        case .dragon_tiger:
            if let myobject = UIStoryboard(name: Constants.Storyboard.smallGame, bundle: nil).instantiateViewController(withIdentifier: DragonVsTigerTableViewController().className) as? DragonVsTigerTableViewController {
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .andar_bahar:
            if let myobject = UIStoryboard(name: Constants.Storyboard.smallGame, bundle: nil).instantiateViewController(withIdentifier: AndarBaharViewController().className) as? AndarBaharViewController {
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .seven_up_down:
            if let myobject = UIStoryboard(name: Constants.Storyboard.smallGame, bundle: nil).instantiateViewController(withIdentifier: SevenUpDownViewController().className) as? SevenUpDownViewController {
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .car_roulette:
            if let myobject = UIStoryboard(name: Constants.Storyboard.smallGame, bundle: nil).instantiateViewController(withIdentifier: CarRouletteViewController().className) as? CarRouletteViewController {
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .animal_roulette:
            if let myobject = UIStoryboard(name: Constants.Storyboard.smallGame, bundle: nil).instantiateViewController(withIdentifier: AnimalRouletteViewController().className) as? AnimalRouletteViewController {
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .color_prediction:
            if let myobject = UIStoryboard(name: Constants.Storyboard.smallGame, bundle: nil).instantiateViewController(withIdentifier: ColourPredictionViewController().className) as? ColourPredictionViewController {
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .poker:
            break
        case .head_tails:
            if let myobject = UIStoryboard(name: Constants.Storyboard.smallGame, bundle: nil).instantiateViewController(withIdentifier: HeadNTailsViewController().className) as? HeadNTailsViewController {
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .red_vs_black:
            if let myobject = UIStoryboard(name: Constants.Storyboard.smallGame, bundle: nil).instantiateViewController(withIdentifier: RedVsBlackViewController().className) as? RedVsBlackViewController {
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .ludo_local:
            break
        case .ludo_online:
            break
        case .ludo_computer:
            break
        case .bacarate:
            if let myobject = UIStoryboard(name: Constants.Storyboard.smallGame, bundle: nil).instantiateViewController(withIdentifier: BaccaratViewController().className) as? BaccaratViewController {
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .jhandi_munda:
            if let myobject = UIStoryboard(name: Constants.Storyboard.smallGame, bundle: nil).instantiateViewController(withIdentifier: JhandiMundaViewController().className) as? JhandiMundaViewController {
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .roulette:
            if let myobject = UIStoryboard(name: Constants.Storyboard.smallGame, bundle: nil).instantiateViewController(withIdentifier: RouletteViewController().className) as? RouletteViewController {
                self.navigationController?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
            break
        case .tournament_rummy:
            break
        case .none:
            break
        }
    }
}

// MARK: Profile data change Delegate
extension DashboardViewController: AvatarViewDelegate {
    func changeAvatar(_ selectedIndex: Int) {
//        self.getUserProfile()
        self.profileImage.sd_setImage(with: URL(string: "\(Constants.baseURL)\(APIClient.imagePath)\(avatars[selectedIndex])"), placeholderImage: Constants.appLogoImage, context: nil)
        self.profileImageEdit.sd_setImage(with: URL(string: "\(Constants.baseURL)\(APIClient.imagePath)\(avatars[selectedIndex])"), placeholderImage: Constants.appLogoImage, context: nil)
        self.updateProfile(true)
    }
}

// MARK: Alert Prompt Delegate
extension DashboardViewController: PromptViewDelegate {
    func didActionOnPromptButton(_ tag: Int) {
        switch tag {
        case 1: // Logout
            let deviceToken = UserDefaults.standard.string(forKey: Constants.UserDefault.fcmToken)

            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            
            UserDefaults.standard.set(deviceToken, forKey: Constants.UserDefault.fcmToken)
            UserDefaults.standard.synchronize()
            Core.push(self, storyboard: Constants.Storyboard.auth, storyboardId: LoginViewController().className)
            break
        default:
            break
        }
    }
}

// MARK: Actions
extension DashboardViewController {
    @IBAction func tapOnProfileImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Photo!", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photot", style: .default, handler: { result in
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                Toast.makeToast("Camera not supported")
                return
            }
            
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                DispatchQueue.main.async {
                    self.imagePicker.sourceType = .camera
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        DispatchQueue.main.async {
                            self.imagePicker.sourceType = .camera
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: { result in
            if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                Toast.makeToast("Photo library not supported")
                return
            }
            
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                DispatchQueue.main.async {
                    self.imagePicker.sourceType = .photoLibrary
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        DispatchQueue.main.async {
                            self.imagePicker.sourceType = .photoLibrary
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Avatar", style: .default, handler: { result in
            if let myobject = UIStoryboard(name: Constants.Storyboard.auth, bundle: nil).instantiateViewController(withIdentifier: AvatarViewController().className) as? AvatarViewController {
                myobject.delegate = self
                myobject.arrayList = self.avatars
                myobject.profileData = self.userProfileDt
                self.present(myobject, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        profileMainView.isHidden = true
    }
    
    @objc func tapOnSubmit(_ sender: UIButton) {
        if profileDataList[0].value.isEmpty || profileDataList[1].value.isEmpty {
            Toast.makeToast("Input field in empty!")
            return
        }
        self.updateProfile()
    }
}

// MARK: API Calls
extension DashboardViewController {
    private func updateProfile(_ isFromProfile: Bool = false) {
        let params = ProfileUpdateRequest(name: profileDataList.count > 0 ? profileDataList[0].value : "", bank_detail: profileDataList.count > 2 ? profileDataList[2].value : "", upi: profileDataList.count > 1 ? profileDataList[1].value : "", adhar_card: profileDataList.count > 3 ? profileDataList[3].value : "", profile_pic: profilePicStr)
        APIClient.shared.post(parameters: params, feed: .update_profile, responseKey: "") { result in
            switch result {
            case .success(let aPIResponse):
                if let response = aPIResponse, response.code == 200 {
                    if !isFromProfile {
                        self.profileMainView.isHidden = true
                    }
                    self.getUserProfile()
                }
                break
            case .failure(let error):
                Toast.makeToast(error.customDescription)
                break
            }
        }
    }
}

// MARK: UITableViewDataSource
extension DashboardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = isProfileEdit ? (indexPath.row == profileDataList.count - 1 ? ProfileEditTableViewCell.submitCell : ProfileEditTableViewCell.textCell) : ProfileEditTableViewCell.labelCell
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ProfileEditTableViewCell {
            if isProfileEdit {
                cell.configure(profileDataList[indexPath.row], row: indexPath.row, target: self, selector: #selector(tapOnSubmit(_ :)), isLastRow: indexPath.row == profileDataList.count - 1, isLastSecondRow: indexPath.row == profileDataList.count - 2)
                if cell.textFieldT != nil {
                    cell.textFieldT.delegate = self
                }
            } else {
                cell.configureDashProfile(profileDataList[indexPath.row], row: indexPath.row)
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: UITableViewDelegate
extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: UITextFieldDelegate
extension DashboardViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [self] in
            let indexPath = IndexPath(row: textField.tag, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if  textField.returnKeyType == .next {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [self] in
                let indexPath = IndexPath(row: textField.tag + 1, section: 0)
                if let cell = self.tableView.cellForRow(at: indexPath) as? ProfileEditTableViewCell, cell.textFieldT != nil {
                    cell.textFieldT.becomeFirstResponder()
                }
//            }
        } else {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.profileDataList[textField.tag].value = textField.text ?? ""
        self.tableView.reloadRows(at: [IndexPath(item: textField.tag, section: 0)], with: .none)
    }
}

// MARK: - UIImagePickerControllerDelegate -
extension DashboardViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePicker.dismiss(animated: true) {
            if let imageOrig = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                guard let imageData = imageOrig.jpegData(compressionQuality: 0.75) else { return }
                self.profilePicStr = imageData.base64EncodedString(options: .lineLength64Characters)
                self.profileImage.image = imageOrig
                self.updateProfile(true)
            }
        }
    }
}
