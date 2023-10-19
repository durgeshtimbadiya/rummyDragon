//
//  Constants.swift
//  Lets Card
//
//  Created by Durgesh on 14/12/22.
//

import UIKit

struct Constants {
    static let baseURL = "http://165.232.176.30/letscard/"//"https://games.androappstech.in/"
    static let profileDefaultImage = UIImage(named: "user_photo")
    static let avatarImage = UIImage(named: "avatar")
    static let appLogoImage = UIImage(named: "app_icon")
    
    static let currencySymbol = "₹"

    struct Storyboard {
        static let main = "Main"
        static let launch = "LaunchScreen"
        static let auth = "Auth"
        static let popup = "Popup"
        static let game = "Game"
        static let smallGame = "GameSmall"
        static let other = "Other"
    }
    
    struct UserDefault {
        static let isLogin = "IsLoginDefault"
        static let gameOnOffData = "GameOnOffData"
        static let profileData = "ProfileData"
        static let settings = "SettingsData"
        static let userName = "UserName"
        static let walletAmount = "walletAmount"
        static let profilePic = "profilePic"
        static let userId = "UserId"
        static let loginToken = "LoginToken"
        static let fcmToken = "NotificationToken"
        static let mobileNumber = "MobileNumber"
        static let isSoundEnable = "IsSoundEnable"
        static let referralCode = "Referral_Code"
        static let referralLink = "Referral_Link"
    }
}

enum GameTypes {
    case teen_patti, private_table, custom_boot, jackpot_teen_patti, point_rummy, private_rummy, pool_rummy, deal_rummy, dragon_tiger, andar_bahar, seven_up_down, car_roulette, animal_roulette, color_prediction, poker, head_tails, red_vs_black, ludo_local, ludo_online, ludo_computer, bacarate, jhandi_munda, roulette, tournament_rummy, none
    
    var imageName: String {
        switch self {
        case .teen_patti:
            return "TeenPatti"
        case .private_table:
            return "PrivateTable"
        case .custom_boot:
            return "CustomBoot"
        case .jackpot_teen_patti:
            return "JackpotTeenPatti"
        case .point_rummy:
            return "PointRummy"
        case .private_rummy:
            return "PrivateRummy"
        case .pool_rummy:
            return "PoolRummy"
        case .deal_rummy:
            return "DealRummy"
        case .dragon_tiger:
            return "DragonNTiger"
        case .andar_bahar:
            return "AndarBahar"
        case .seven_up_down:
            return "SevenUpDown"
        case .car_roulette:
            return "CarRoulette"
        case .animal_roulette:
            return "AnimalRoulette"
        case .color_prediction:
            return "ColourPrediction"
        case .poker:
            return "Poker"
        case .head_tails:
            return "HeadNTail"
        case .red_vs_black:
            return "RedVSBlack"
        case .ludo_local:
            return "PlayLocalLudo"
        case .ludo_online:
            return "LudoPlayOnline"
        case .ludo_computer:
            return "LudoUserVSComputer"
        case .bacarate:
            return "Baccarat"
        case .jhandi_munda:
            return "JhandiMundra"
        case .roulette:
//            return "img_roulette_home"
            return "home_rol"
        case .tournament_rummy:
//            return "tournament"
            return "home_tournament"
        case .none:
            return ""
        }
    }
    
    var infoCellId: String {
        switch self {
        case .teen_patti:
            return InfoCardTableViewCell.identifier
        case .private_table:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .custom_boot:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .jackpot_teen_patti:
            return InfoCardTableViewCell.cellJackpotIdentifier
        case .point_rummy:
            return InfoCardTableViewCell.rummyIdentifier
        case .private_rummy:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .pool_rummy:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .deal_rummy:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .dragon_tiger:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .andar_bahar:
            return InfoCardTableViewCell.rummyIdentifier
        case .seven_up_down:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .car_roulette:
            return InfoCardTableViewCell.rummyIdentifier
        case .animal_roulette:
            return InfoCardTableViewCell.rummyIdentifier
        case .color_prediction:
            return InfoCardTableViewCell.cellCPIdentifier
        case .poker:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .head_tails:
            return InfoCardTableViewCell.cellHeadTail
        case .red_vs_black:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .ludo_local:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .ludo_online:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .ludo_computer:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .bacarate:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .jhandi_munda:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .roulette:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .tournament_rummy:
            return InfoCardTableViewCell.cellDNTIdentifier
        case .none:
            return ""
        }
    }
    
    var itemType: String {
        switch self {
        case .teen_patti, .private_table, .custom_boot, .ludo_online:
            return "multi"
        case .jackpot_teen_patti:
            return "all"
        case .point_rummy, .private_rummy, .pool_rummy, .deal_rummy, .ludo_computer:
            return "skill"
        case .dragon_tiger, .andar_bahar, .seven_up_down, .car_roulette, .animal_roulette, .color_prediction, .poker, .head_tails, .red_vs_black, .ludo_local, .bacarate, .jhandi_munda, .roulette, .tournament_rummy:
            return "slots"
        case .none:
            return ""
        }
    }
}
