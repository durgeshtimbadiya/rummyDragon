//
//  APIClient.swift
//  TaleOMeter
//
//  Created by Durgesh on 08/03/22.
//  Copyright © 2022 Durgesh. All rights reserved.
//

import Foundation
import SwiftyJSON
import ProgressHUD
import UIKit

class APIClient: GenericAPIClient {
    static let shared = APIClient()

    var session: URLSession
    
    static let imagePath = "data/post/"
    static let reedemImagePath = "data/Redeem/"
    static let aPIPath = "api/"
    static let userPath = "User/"
    static let rummyPath = "Rummy/"
    static let rummyPoolPath = "RummyPool/"
    static let rummyDealPath = "RummyDeal/"
    static let anderBaharPath = "AnderBahar/"
    static let rummyTournamentPath = "RummyTournament/"
    static let colorPredictionPath = "ColorPrediction/"
    static let dragonTigerPath = "DragonTiger/"
    static let headTailPath = "HeadTail/"
    static let jackpotPath = "jackpot/"
    static let redBlackPath = "RedBlack/"
    static let roulettePath = "Roulette/"
    static let baccaratPath = "Baccarat/"
    static let jhandiMundaPath = "JhandiMunda/"
    static let carRoulettePath = "CarRoulette/"
    static let animalRoulettePath = "AnimalRoulette/"
    static let sevenUpPath = "SevenUp/"
    static let gamePath = "GameIOS/"
    static let callbackPath = "callback/"
    static let planPath = "Plan/"
    static let redeemPath = "Redeem/"
    static let payumoneyPath = "Payumoney/"
    static let dataPath = "data/"
    static let pokerPath = "poker/"
    static let bannerPath = "uploads/banner/"

    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }

    convenience init() {
        self.init(configuration: .default)
    }

    func showProgress() {
        ProgressHUD.animationType = .circleStrokeSpin
        ProgressHUD.colorBackground = .white
        ProgressHUD.colorAnimation = .blue
        ProgressHUD.show("Loading...")
    }
    
    //in the signature of the function in the success case we define the Class type thats is the generic one in the API
    func get(_ query: String, feed: Feed, responseKey: String = "", completion: @escaping (Result<ResponseAPIModel?, APIError>) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            Toast.makeToast()
            return
        }
        showProgress()
        guard let request = feed.getRequest(query) else { return }
        fetch(with: request, responseKey: responseKey, decode: { json -> ResponseAPIModel? in
            ProgressHUD.dismiss()
            guard let apiResponse = json as? ResponseAPIModel else { return  nil }
            return apiResponse
        }, completion: completion)
    }

    func post<T: Encodable>(_ query: String = "", parameters: T, feed: Feed, showLoading: Bool = true, responseKey: String = "", completion: @escaping (Result<ResponseAPIModel?, APIError>) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            Toast.makeToast()
            return
        }
        if showLoading {
            showProgress()
        }
        guard let request = feed.postRequest(query, parameters: parameters) else { return }
        fetch(with: request, responseKey: responseKey, decode: { (json) -> ResponseAPIModel? in
            if showLoading {
                ProgressHUD.dismiss()
            }
            guard let apiResponse = json as? ResponseAPIModel else { return  nil }
            return apiResponse
        }, completion: completion)
    }

    func delete<T: Encodable>(_ parameters: T, query: String, feed: Feed, responseKey: String = "", completion: @escaping (Result<ResponseAPIModel?, APIError>) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            Toast.makeToast()
            return
        }
        showProgress()
        guard let request = feed.deleteRequest(query, parameters: parameters) else { return }
        fetch(with: request, responseKey: responseKey, decode: { json -> ResponseAPIModel? in
            ProgressHUD.dismiss()
            guard let apiResponse = json as? ResponseAPIModel else { return  nil }
            return apiResponse
        }, completion: completion)
    }

    //Bearer
    func getAuthenticationWithoutBearer() -> String {
        return "c7d3965d49d4a59b0da80e90646aee77548458b3377ba3c0fb43d5ff91d54ea28833080e3de6ebd4fde36e2fb7175cddaf5d8d018ac1467c3d15db21c11b6909"
    }

    func GetDeviceInfo() -> String {
        let fcmtoken = UserDefaults.standard.value(forKey: "SenderID")
        let currentDevice = UIDevice.current

        let headerDict = NSMutableDictionary()
        headerDict.setValue(fcmtoken, forKey: "NotificationId")
        headerDict.setValue("", forKey: "AppSignature")
        headerDict.setValue(currentDevice.model, forKey: "Model")
        headerDict.setValue(currentDevice.systemVersion, forKey: "OSVersion")
        headerDict.setValue(currentDevice.systemName, forKey: "OS")
        headerDict.setValue(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String, forKey: "AppVersion")
        headerDict.setValue(self.GenerateAndSaveDeviceId(), forKey: "UUID")
        headerDict.setValue("", forKey: "SerialNo")
        headerDict.setValue("Apple", forKey: "Manufacturer")
        headerDict.setValue("Mobile", forKey: "Platform")
        headerDict.setValue("2", forKey: "AppVersionCode")
        do {
            let data1 = try JSONSerialization.data(withJSONObject: headerDict, options: .prettyPrinted)
            let strdata = String(data: data1, encoding: .utf8)
            return (strdata?.data(using: .utf8)?.base64EncodedString(options: []))!
        } catch {
            return ""
        }
    }

    func GenerateAndSaveDeviceId() -> String {
        let userDefault = UserDefaults.standard
        if (userDefault.value(forKey: "UUID") == nil) {
            userDefault.setValue((UIDevice.current.identifierForVendor?.uuidString)!, forKey: "UUID")
            userDefault.synchronize()
        }
        return userDefault.value(forKey: "UUID") as! String
    }
}

/// ENDPOINT CONFORMANCE
enum Feed {
    
    // User
    case login
    case register
    case email_login
    case send_otp
    case only_send_otp
    case profile
    case game_on_off
    case wallet_history
    case redeem
    case app
    case bot
    case winning_history
    case update_profile
    case update_kyc
    case update_bank_details
    case change_password
    case withdrawal_log
    case wallet_history_all
    case welcome_bonus
    case collect_welcome_bonus
    case setting
    case leaderboard
    case check_adhar
    case user_category
    case forgot_password
    case create_transaction
    case transaction_status
    case addPaymentProof
    case wallet_history_rummy_deal
    case wallet_history_rummy_pool
    case wallet_history_color_prediction
    case wallet_history_car_roulette
    case wallet_history_animal_roulette
    case wallet_history_jackpot
    case wallet_history_seven_up
    case wallet_history_dragon
    case teenpatti_gamelog_history
    case rummy_gamelog_history
    
    // Rummy Game
    case rummy_get_table
    case rummy_join_table
    case rummy_get_private_table
    case rummy_start_game
    case rummy_pack_game
    case rummy_leave_table
    case rummy_my_card
    case rummy_status
    case rummy_card_value
    case rummy_drop_card
    case rummy_get_card
    case rummy_get_drop_card
    case rummy_declare
    case rummy_declare_back
    case rummy_share_wallet
    case rummy_do_share_wallet
    case rummy_do_start_game
    case rummy_ask_start_game
    case rummy_rejoin_game
    case rummy_rejoin_game_amount
    case rummy_get_table_master

    // Rummy pool game
    case RPool_get_table
    case RPool_start_game
    case RPool_pack_game
    case RPool_leave_table
    case RPool_my_card
    case RPool_status
    case RPool_card_value
    case RPool_drop_card
    case RPool_get_card
    case RPool_get_drop_card
    case RPool_declare
    case RPool_declare_back
    case RPool_share_wallet
    case RPool_do_share_wallet
    case RPool_join_table
    case RPool_do_start_game
    case RPool_ask_start_game
    case RPool_rejoin_game
    case RPool_rejoin_game_amount
    case RPool_get_table_master
    
    // Rummy Deal Game
    case RDeal_get_table
    case RDeal_start_game
    case RDeal_pack_game
    case RDeal_leave_table
    case RDeal_my_card
    case RDeal_status
    case RDeal_card_value
    case RDeal_drop_card
    case RDeal_get_card
    case RDeal_get_drop_card
    case RDeal_declare
    case RDeal_declare_back
    case RDeal_share_wallet
    case RDeal_do_share_wallet
    case RDeal_join_table
    case RDeal_do_start_game
    case RDeal_ask_start_game
    case RDeal_rejoin_game
    case RDeal_rejoin_game_amount
    case RDeal_get_table_master
    
    // Andhar Bahar Game
    case ABG_get_active_game
    case ABG_place_bet
    case ABG_cancel_bet
    case ABG_repeat_bet
    case ABG_room
    
    // Tourname List
    case RTour_get_table_master
    case RTour_join_tournament
    
    // Color Predict
    case CPre_get_active_game
    case CPre_place_bet
    case CPre_cancel_bet
    case CPre_repeat_bet
    
    // Dragon and Tiger
    case DT_get_active_game
    case DT_place_bet
    case DT_cancel_bet
    case DT_repeat_bet
    
    // HeadTail
    case HeadT_get_active_game
    case HeadT_place_bet
    case HeadT_cancel_bet
    
    // Jackpot Games
    case JackP_get_active_game
    case JackP_place_bet
    case JackP_cancel_bet
    case JackP_repeat_bet
    case JackP_jackpot_winners
    case JackP_last_winners
    
    // RedBlack Games
    case RedBl_get_active_game
    case RedBl_place_bet
    case RedBl_cancel_bet
    case RedBl_repeat_bet
    
    // Roullete Games
    case Roullet_get_active_game
    case Roullet_place_bet
    case Roullet_cancel_bet
    
    // Baccarat Games
    case Baccart_get_active_game
    case Baccart_place_bet
    case Baccart_cancel_bet
    case Baccart_repeat_bet
    
    // Jhandhi Munda Games
    case JhMunda_get_active_game
    case JhMunda_place_bet
    case JhMunda_cancel_bet
    case JhMunda_repeat_bet
    
    // CarRoulette Games
    case CarRlt_get_active_game
    case CarRlt_place_bet
    case CarRlt_cancel_bet
    case CarRlt_repeat_bet
    
    // AnimalRoulette Games
    case AnimalRlt_get_active_game
    case AnimalRlt_place_bet
    case AnimalRlt_cancel_bet
    case AnimalRlt_repeat_bet
    
    // SevenUpGames
    case SevenUp_get_active_game
    case SevenUp_place_bet
    case SevenUp_cancel_bet
    
    // Game
    case Game_get_table
    case Game_get_customise_table
    case Game_join_table
    case Game_get_private_table
    case Game_leave_table
    case Game_status
    case Game_pack_game
    case Game_chaal
    case Game_show_game
    case Game_do_slide_show
    case Game_slide_show
    case Game_switch_table
    case Game_start_game
    case Game_see_card
    case Game_tip
    case Game_chat
    case Game_get_table_master
    
    // Plan
    case GetChipPlan
    case Plan_place_order
    case Plan_pay_now
    case Plan_gift
    case Plan_paytm_pay_now_api
    case Plan_paytm_token_api
    case Plan_Place_Order_upi
    case Plan_cashfree_token_api
    case Plan_cashfree_pay_now_api
    case Plan_payumoney_token_api
    case Plan_payumoney_pay_now_api
    case Plan_payumoney_salt
    
    // Callback
    case Callback_spin
    case Callback_verify

    // Poker-Const
}

protocol CodeEnd {
    var code: Int { get }
}

extension Feed: Endpoint {

    var base: String {
        return Constants.baseURL
    }

    var path: String {
        switch self {
        // User
        case .login: return APIClient.aPIPath + APIClient.userPath + "login"
        case .register: return APIClient.aPIPath + APIClient.userPath + "register"
        case .email_login: return APIClient.aPIPath + APIClient.userPath + "email_login"
        case .send_otp: return APIClient.aPIPath + APIClient.userPath + "send_otp"
        case .only_send_otp: return APIClient.aPIPath + APIClient.userPath + "only_send_otp"
        case .profile: return APIClient.aPIPath + APIClient.userPath + "profile"
        case .game_on_off: return APIClient.aPIPath + APIClient.userPath + "game_on_off"
        case .wallet_history: return APIClient.aPIPath + APIClient.userPath + "wallet_history"
        case .redeem: return APIClient.aPIPath + APIClient.userPath + "redeem"
        case .app: return APIClient.aPIPath + APIClient.userPath + "app"
        case .bot: return APIClient.aPIPath + APIClient.userPath + "bot"
        case .winning_history: return APIClient.aPIPath + APIClient.userPath + "winning_history"
        case .update_profile: return APIClient.aPIPath + APIClient.userPath.lowercased() + "update_profile"
        case .update_kyc: return APIClient.aPIPath + APIClient.userPath + "update_kyc"
        case .update_bank_details: return APIClient.aPIPath + APIClient.userPath + "update_bank_details"
        case .change_password: return APIClient.aPIPath + APIClient.userPath + "change_password"
        case .withdrawal_log: return APIClient.aPIPath + APIClient.userPath + "withdrawal_log"
        case .wallet_history_all: return APIClient.aPIPath + APIClient.userPath + "wallet_history_all"
        case .welcome_bonus: return APIClient.aPIPath + APIClient.userPath + "welcome_bonus"
        case .collect_welcome_bonus: return APIClient.aPIPath + APIClient.userPath + "collect_welcome_bonus"
        case .setting: return APIClient.aPIPath + APIClient.userPath + "setting"
        case .leaderboard: return APIClient.aPIPath + APIClient.userPath + "leaderboard"
        case .check_adhar: return APIClient.aPIPath + APIClient.userPath + "check_adhar"
        case .user_category: return APIClient.aPIPath + APIClient.userPath + "user_category"
        case .forgot_password: return APIClient.aPIPath + APIClient.userPath + "forgot_password"
        case .create_transaction: return APIClient.aPIPath + APIClient.userPath + "create_transaction"
        case .transaction_status: return APIClient.aPIPath + APIClient.userPath + "transaction_status"
        case .addPaymentProof: return APIClient.aPIPath + APIClient.userPath + "addPaymentProof"
        case .wallet_history_rummy_deal: return APIClient.aPIPath + APIClient.userPath + "wallet_history_rummy_deal"
        case .wallet_history_rummy_pool: return APIClient.aPIPath + APIClient.userPath + "wallet_history_rummy_pool"
        case .wallet_history_color_prediction: return APIClient.aPIPath + APIClient.userPath + "wallet_history_color_prediction"
        case .wallet_history_car_roulette: return APIClient.aPIPath + APIClient.userPath +
            "wallet_history_car_roulette"
        case .wallet_history_animal_roulette: return APIClient.aPIPath + APIClient.userPath + "wallet_history_animal_roulette"
        case .wallet_history_jackpot: return APIClient.aPIPath + APIClient.userPath + "wallet_history_jackpot"
        case .wallet_history_seven_up: return APIClient.aPIPath + APIClient.userPath + "wallet_history_seven_up"
        case .wallet_history_dragon: return APIClient.aPIPath + APIClient.userPath + "wallet_history_dragon"
        case .teenpatti_gamelog_history: return APIClient.aPIPath + APIClient.userPath + "teenpatti_gamelog_history"
        case .rummy_gamelog_history: return APIClient.aPIPath + APIClient.userPath + "rummy_gamelog_history"
            
        // Rummy Game
        case .rummy_get_table: return APIClient.aPIPath + APIClient.rummyPath + "get_table"
        case .rummy_join_table: return APIClient.aPIPath + APIClient.rummyPath + "join_table"
        case .rummy_get_private_table: return APIClient.aPIPath + APIClient.rummyPath + "get_private_table"
        case .rummy_start_game: return APIClient.aPIPath + APIClient.rummyPath + "start_game"
        case .rummy_pack_game: return APIClient.aPIPath + APIClient.rummyPath + "pack_game"
        case .rummy_leave_table: return APIClient.aPIPath + APIClient.rummyPath + "leave_table"
        case .rummy_my_card: return APIClient.aPIPath + APIClient.rummyPath + "my_card"
        case .rummy_status: return APIClient.aPIPath + APIClient.rummyPath + "status"
        case .rummy_card_value: return APIClient.aPIPath + APIClient.rummyPath + "card_value"
        case .rummy_drop_card: return APIClient.aPIPath + APIClient.rummyPath + "drop_card"
        case .rummy_get_card: return APIClient.aPIPath + APIClient.rummyPath + "get_card"
        case .rummy_get_drop_card: return APIClient.aPIPath + APIClient.rummyPath + "get_drop_card"
        case .rummy_declare: return APIClient.aPIPath + APIClient.rummyPath + "declare"
        case .rummy_declare_back: return APIClient.aPIPath + APIClient.rummyPath + "declare_back"
        case .rummy_share_wallet: return APIClient.aPIPath + APIClient.rummyPath + "share_wallet"
        case .rummy_do_share_wallet: return APIClient.aPIPath + APIClient.rummyPath + "do_share_wallet"
        case .rummy_do_start_game: return APIClient.aPIPath + APIClient.rummyPath + "do_start_game"
        case .rummy_ask_start_game: return APIClient.aPIPath + APIClient.rummyPath + "ask_start_game"
        case .rummy_rejoin_game: return APIClient.aPIPath + APIClient.rummyPath + "rejoin_game"
        case .rummy_rejoin_game_amount: return APIClient.aPIPath + APIClient.rummyPath + "rejoin_game_amount"
        case .rummy_get_table_master: return APIClient.aPIPath + APIClient.rummyPath + "get_table_master"
            
        // Rummy pool game
        case .RPool_get_table: return APIClient.aPIPath + APIClient.rummyPoolPath + "get_table"
        case .RPool_start_game: return APIClient.aPIPath + APIClient.rummyPoolPath + "start_game"
        case .RPool_pack_game: return APIClient.aPIPath + APIClient.rummyPoolPath + "pack_game"
        case .RPool_leave_table: return APIClient.aPIPath + APIClient.rummyPoolPath + "leave_table"
        case .RPool_my_card: return APIClient.aPIPath + APIClient.rummyPoolPath + "my_card"
        case .RPool_status: return APIClient.aPIPath + APIClient.rummyPoolPath + "status"
        case .RPool_card_value: return APIClient.aPIPath + APIClient.rummyPoolPath + "card_value"
        case .RPool_drop_card: return APIClient.aPIPath + APIClient.rummyPoolPath + "drop_card"
        case .RPool_get_card: return APIClient.aPIPath + APIClient.rummyPoolPath + "get_card"
        case .RPool_get_drop_card: return APIClient.aPIPath + APIClient.rummyPoolPath + "get_drop_card"
        case .RPool_declare: return APIClient.aPIPath + APIClient.rummyPoolPath + "declare"
        case .RPool_declare_back: return APIClient.aPIPath + APIClient.rummyPoolPath + "declare_back"
        case .RPool_share_wallet: return APIClient.aPIPath + APIClient.rummyPoolPath + "share_wallet"
        case .RPool_do_share_wallet: return APIClient.aPIPath + APIClient.rummyPoolPath + "do_share_wallet"
        case .RPool_join_table:    return APIClient.aPIPath + APIClient.rummyPoolPath + "join_table"
        case .RPool_do_start_game:    return APIClient.aPIPath + APIClient.rummyPoolPath + "do_start_game"
        case .RPool_ask_start_game:    return APIClient.aPIPath + APIClient.rummyPoolPath + "ask_start_game"
        case .RPool_rejoin_game:    return APIClient.aPIPath + APIClient.rummyPoolPath + "rejoin_game"
        case .RPool_rejoin_game_amount:    return APIClient.aPIPath + APIClient.rummyPoolPath + "rejoin_game_amount"
        case .RPool_get_table_master:    return APIClient.aPIPath + APIClient.rummyPoolPath + "get_table_master"
        
        // Rummy Deal Game
        case .RDeal_get_table:      return APIClient.aPIPath + APIClient.rummyDealPath + "get_table"
        case .RDeal_start_game:         return APIClient.aPIPath + APIClient.rummyDealPath + "start_game"
        case .RDeal_pack_game:      return APIClient.aPIPath + APIClient.rummyDealPath + "pack_game"
        case .RDeal_leave_table:        return APIClient.aPIPath + APIClient.rummyDealPath + "leave_table"
        case .RDeal_my_card:        return APIClient.aPIPath + APIClient.rummyDealPath + "my_card"
        case .RDeal_status:         return APIClient.aPIPath + APIClient.rummyDealPath + "status"
        case .RDeal_card_value:         return APIClient.aPIPath + APIClient.rummyDealPath + "card_value"
        case .RDeal_drop_card:      return APIClient.aPIPath + APIClient.rummyDealPath + "drop_card"
        case .RDeal_get_card:       return APIClient.aPIPath + APIClient.rummyDealPath + "get_card"
        case .RDeal_get_drop_card:      return APIClient.aPIPath + APIClient.rummyDealPath + "get_drop_card"
        case .RDeal_declare:        return APIClient.aPIPath + APIClient.rummyDealPath + "declare"
        case .RDeal_declare_back:       return APIClient.aPIPath + APIClient.rummyDealPath + "declare_back"
        case .RDeal_share_wallet:       return APIClient.aPIPath + APIClient.rummyDealPath + "share_wallet"
        case .RDeal_do_share_wallet:        return APIClient.aPIPath + APIClient.rummyDealPath + "do_share_wallet"
        case .RDeal_join_table:         return APIClient.aPIPath + APIClient.rummyDealPath + "join_table"
        case .RDeal_do_start_game:      return APIClient.aPIPath + APIClient.rummyDealPath + "do_start_game"
        case .RDeal_ask_start_game:         return APIClient.aPIPath + APIClient.rummyDealPath + "ask_start_game"
        case .RDeal_rejoin_game:        return APIClient.aPIPath + APIClient.rummyDealPath + "rejoin_game"
        case .RDeal_rejoin_game_amount:         return APIClient.aPIPath + APIClient.rummyDealPath + "rejoin_game_amount"
        case .RDeal_get_table_master:       return APIClient.aPIPath + APIClient.rummyDealPath + "get_table_master"
            
        // Andhar Bahar Game
        case .ABG_get_active_game: return APIClient.aPIPath + APIClient.anderBaharPath + "get_active_game"
        case .ABG_place_bet: return APIClient.aPIPath + APIClient.anderBaharPath + "place_bet"
        case .ABG_cancel_bet: return APIClient.aPIPath + APIClient.anderBaharPath + "cancel_bet"
        case .ABG_repeat_bet: return APIClient.aPIPath + APIClient.anderBaharPath + "repeat_bet"
        case .ABG_room: return APIClient.aPIPath + APIClient.anderBaharPath + "room"
            
        // Tournament List
        case .RTour_get_table_master: return APIClient.aPIPath + APIClient.rummyTournamentPath + "get_table_master"
        case .RTour_join_tournament: return APIClient.aPIPath + APIClient.rummyTournamentPath + "join_tournament"
            
        // Color Predict
        case .CPre_get_active_game: return APIClient.aPIPath + APIClient.colorPredictionPath + "get_active_game"
        case .CPre_place_bet: return APIClient.aPIPath + APIClient.colorPredictionPath + "place_bet"
        case .CPre_cancel_bet: return APIClient.aPIPath + APIClient.colorPredictionPath + "cancel_bet"
        case .CPre_repeat_bet: return APIClient.aPIPath + APIClient.colorPredictionPath + "repeat_bet"
        
        // Dragon and Tiger
        case .DT_get_active_game: return APIClient.aPIPath + APIClient.dragonTigerPath + "get_active_game"
        case .DT_place_bet: return APIClient.aPIPath + APIClient.dragonTigerPath + "place_bet"
        case .DT_cancel_bet: return APIClient.aPIPath + APIClient.dragonTigerPath + "cancel_bet"
        case .DT_repeat_bet: return APIClient.aPIPath + APIClient.dragonTigerPath + "repeat_bet"
        
        // HeadTail
        case .HeadT_get_active_game: return APIClient.aPIPath + APIClient.headTailPath + "get_active_game"
        case .HeadT_place_bet: return APIClient.aPIPath + APIClient.headTailPath + "place_bet"
        case .HeadT_cancel_bet: return APIClient.aPIPath + APIClient.headTailPath + "cancel_bet"
        
        // Jackpot Games
        case .JackP_get_active_game: return APIClient.aPIPath + APIClient.jackpotPath + "get_active_game"
        case .JackP_place_bet: return APIClient.aPIPath + APIClient.jackpotPath + "place_bet"
        case .JackP_cancel_bet: return APIClient.aPIPath + APIClient.jackpotPath + "cancel_bet"
        case .JackP_repeat_bet: return APIClient.aPIPath + APIClient.jackpotPath + "repeat_bet"
        case .JackP_jackpot_winners: return APIClient.aPIPath + APIClient.jackpotPath + "jackpot_winners"
        case .JackP_last_winners: return APIClient.aPIPath + APIClient.jackpotPath + "last_winners"
        
        // RedBlack Games
        case .RedBl_get_active_game: return APIClient.aPIPath + APIClient.redBlackPath + "get_active_game"
        case .RedBl_place_bet: return APIClient.aPIPath + APIClient.redBlackPath + "place_bet"
        case .RedBl_cancel_bet: return APIClient.aPIPath + APIClient.redBlackPath + "cancel_bet"
        case .RedBl_repeat_bet: return APIClient.aPIPath + APIClient.redBlackPath + "repeat_bet"
        
        // Roullete Games
        case .Roullet_get_active_game: return APIClient.aPIPath + APIClient.roulettePath + "get_active_game"
        case .Roullet_place_bet: return APIClient.aPIPath + APIClient.roulettePath + "place_bet"
        case .Roullet_cancel_bet: return APIClient.aPIPath + APIClient.roulettePath + "cancel_bet"
            
        // Baccarat Games
        case .Baccart_get_active_game: return APIClient.aPIPath + APIClient.baccaratPath + "get_active_game"
        case .Baccart_place_bet: return APIClient.aPIPath + APIClient.baccaratPath + "place_bet"
        case .Baccart_cancel_bet: return APIClient.aPIPath + APIClient.baccaratPath + "cancel_bet"
        case .Baccart_repeat_bet: return APIClient.aPIPath + APIClient.baccaratPath + "repeat_bet"
        
        // Jhandhi Munda Games
        case .JhMunda_get_active_game: return APIClient.aPIPath + APIClient.jhandiMundaPath + "get_active_game"
        case .JhMunda_place_bet: return APIClient.aPIPath + APIClient.jhandiMundaPath + "place_bet"
        case .JhMunda_cancel_bet: return APIClient.aPIPath + APIClient.jhandiMundaPath + "cancel_bet"
        case .JhMunda_repeat_bet: return APIClient.aPIPath + APIClient.jhandiMundaPath + "repeat_bet"
        
        // CarRoulette Games
        case .CarRlt_get_active_game: return APIClient.aPIPath + APIClient.carRoulettePath + "get_active_game"
        case .CarRlt_place_bet: return APIClient.aPIPath + APIClient.carRoulettePath + "place_bet"
        case .CarRlt_cancel_bet: return APIClient.aPIPath + APIClient.carRoulettePath + "cancel_bet"
        case .CarRlt_repeat_bet: return APIClient.aPIPath + APIClient.carRoulettePath + "repeat_bet"
        
        // AnimalRoulette Games
        case .AnimalRlt_get_active_game: return APIClient.aPIPath + APIClient.animalRoulettePath + "get_active_game"
        case .AnimalRlt_place_bet: return APIClient.aPIPath + APIClient.animalRoulettePath + "place_bet"
        case .AnimalRlt_cancel_bet: return APIClient.aPIPath + APIClient.animalRoulettePath + "cancel_bet"
        case .AnimalRlt_repeat_bet: return APIClient.aPIPath + APIClient.animalRoulettePath + "repeat_bet"
            
        // SevenUpGames
        case .SevenUp_get_active_game: return APIClient.aPIPath + APIClient.sevenUpPath + "get_active_game"
        case .SevenUp_place_bet: return APIClient.aPIPath + APIClient.sevenUpPath + "place_bet"
        case .SevenUp_cancel_bet: return APIClient.aPIPath + APIClient.sevenUpPath + "cancel_bet"
        
        // Game
        case .Game_get_table: return APIClient.aPIPath + APIClient.gamePath + "get_table"
        case .Game_get_customise_table: return APIClient.aPIPath + APIClient.gamePath + "get_customise_table"
        case .Game_join_table: return APIClient.aPIPath + APIClient.gamePath + "join_table"
        case .Game_get_private_table: return APIClient.aPIPath + APIClient.gamePath + "get_private_table"
        case .Game_leave_table: return APIClient.aPIPath + APIClient.gamePath + "leave_table"
        case .Game_status: return APIClient.aPIPath + APIClient.gamePath + "status"
        case .Game_pack_game: return APIClient.aPIPath + APIClient.gamePath + "pack_game"
        case .Game_chaal: return APIClient.aPIPath + APIClient.gamePath + "chaal"
        case .Game_show_game: return APIClient.aPIPath + APIClient.gamePath + "show_game"
        case .Game_do_slide_show: return APIClient.aPIPath + APIClient.gamePath + "do_slide_show"
        case .Game_slide_show: return APIClient.aPIPath + APIClient.gamePath + "slide_show"
        case .Game_switch_table: return APIClient.aPIPath + APIClient.gamePath + "switch_table"
        case .Game_start_game: return APIClient.aPIPath + APIClient.gamePath + "start_game"
        case .Game_see_card: return APIClient.aPIPath + APIClient.gamePath + "see_card"
        case .Game_tip: return APIClient.aPIPath + APIClient.gamePath + "tip"
        case .Game_chat: return APIClient.aPIPath + APIClient.gamePath + "chat"
        case .Game_get_table_master: return APIClient.aPIPath + APIClient.gamePath + "get_table_master"
        
        // Plan
        case .GetChipPlan: return APIClient.aPIPath + "Plan"
        case .Plan_place_order: return APIClient.aPIPath + APIClient.planPath + "place_order"
        case .Plan_pay_now: return APIClient.aPIPath + APIClient.planPath + "pay_now"
        case .Plan_gift: return APIClient.aPIPath + APIClient.planPath + "gift"
        case .Plan_paytm_pay_now_api: return APIClient.aPIPath + APIClient.planPath + "paytm_pay_now_api"
        case .Plan_paytm_token_api: return APIClient.aPIPath + APIClient.planPath + "paytm_token_api"
        case .Plan_Place_Order_upi: return APIClient.aPIPath + APIClient.planPath + "Place_Order_upi"
        case .Plan_cashfree_token_api: return APIClient.aPIPath + APIClient.planPath + "cashfree_token_api"
        case .Plan_cashfree_pay_now_api: return APIClient.aPIPath + APIClient.planPath + "cashfree_pay_now_api"
        case .Plan_payumoney_token_api: return APIClient.aPIPath + APIClient.planPath + "payumoney_token_api"
        case .Plan_payumoney_pay_now_api: return APIClient.aPIPath + APIClient.planPath + "payumoney_pay_now_api"
        case .Plan_payumoney_salt: return APIClient.aPIPath + APIClient.planPath + "payumoney_salt"
            
        // Callback
        case .Callback_spin: return APIClient.aPIPath + APIClient.callbackPath + "spin"
        case .Callback_verify: return APIClient.aPIPath + APIClient.callbackPath + "verify"
        
            
            
        
        // Poker-Const
            
        
        }
    }
}
