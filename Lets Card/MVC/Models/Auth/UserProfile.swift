//
//  UserProfile.swift
//  Lets Card
//
//  Created by Durgesh on 20/12/22.
//

import SwiftyJSON

struct ProfileData: Codable {
    var bank_detail = String()
    var adhar_card = String()
    var token = String()
    var profile_pic = String()
    var spin_remaining = String()
    var email = String()
    var baccarat_id = Int()
    var name = String()
    var gender = String()
    var premium = String()
    var color_prediction_room_id = Int()
    var wallet = Double()
    var rummy_tournament_table_id = Int()
    var poker_table_id = Int()
    var password = String()
    var updated_date = String()
    var jhandi_munda_id = Int()
    var user_category = String()
    var fcm = String()
    var app_version = String()
    var car_roulette_room_id = Int()
    var mobile = String()
    var table_id = Int()
    var upi = String()
    var ludo_table_id = Int()
    var winning_wallet = Double()
    var red_black_id = Int()
    var rummy_deal_table_id = Int()
    var source = Int()
    var dragon_tiger_room_id = Int()
    var added_date = String()
    var referred_by = String()
    var rummy_table_id = Int()
    var user_type = String()
    var user_category_id = Int()
    var isDeleted = Int()
    var id = Int()
    var ander_bahar_room_id = Int()
    var roulette_id = Int()
    var jackpot_room_id = Int()
    var game_played = Int()
    var referral_code = String()
    var rummy_pool_table_id = Int()
    var head_tail_room_id = Int()
    var status = Int()
    var seven_up_room_id = Int()
    var animal_roulette_room_id = Int()
    
    init() {    }
    init(_ json: JSON) {
        if let bankD = json["bank_detail"].string {
            bank_detail = bankD
        }
        adhar_card = json["adhar_card"].stringValue
        token = json["token"].stringValue
        if let profilePath = json["profile_pic"].string {
            profile_pic = "\(Constants.baseURL)\(APIClient.imagePath)\(profilePath)"
        }
        spin_remaining = json["spin_remaining"].stringValue
        email = json["email"].stringValue
        baccarat_id = json["baccarat_id"].intValue
        name = json["name"].stringValue
        gender = json["gender"].stringValue
        premium = json["premium"].stringValue
        color_prediction_room_id = json["color_prediction_room_id"].intValue
        wallet = json["wallet"].doubleValue
        rummy_tournament_table_id = json["rummy_tournament_table_id"].intValue
        poker_table_id = json["poker_table_id"].intValue
        password = json["password"].stringValue
        updated_date = json["updated_date"].stringValue
        jhandi_munda_id = json["jhandi_munda_id"].intValue
        user_category = json["user_category"].stringValue
        fcm = json["fcm"].stringValue
        app_version = json["app_version"].stringValue
        car_roulette_room_id = json["car_roulette_room_id"].intValue
        mobile = json["mobile"].stringValue
        table_id = json["table_id"].intValue
        upi = json["upi"].stringValue
        ludo_table_id = json["ludo_table_id"].intValue
        winning_wallet = json["winning_wallet"].doubleValue
        red_black_id = json["red_black_id"].intValue
        rummy_deal_table_id = json["rummy_deal_table_id"].intValue
        source = json["source"].intValue
        dragon_tiger_room_id = json["dragon_tiger_room_id"].intValue
        added_date = json["added_date"].stringValue
        referred_by = json["referred_by"].stringValue
        rummy_table_id = json["rummy_table_id"].intValue
        user_type = json["user_type"].stringValue
        user_category_id = json["user_category_id"].intValue
        isDeleted = json["isDeleted"].intValue
        id = json["id"].intValue
        ander_bahar_room_id = json["ander_bahar_room_id"].intValue
        roulette_id = json["roulette_id"].intValue
        jackpot_room_id = json["jackpot_room_id"].intValue
        game_played = json["game_played"].intValue
        referral_code = json["referral_code"].stringValue
        rummy_pool_table_id = json["rummy_pool_table_id"].intValue
        head_tail_room_id = json["head_tail_room_id"].intValue
        status = json["status"].intValue
        seven_up_room_id = json["seven_up_room_id"].intValue
        animal_roulette_room_id = json["animal_roulette_room_id"].intValue
    }
    
    public static func storeData(_ profileData: ProfileData) {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            // Encode Note
            let data = try encoder.encode(profileData)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: Constants.UserDefault.profileData)
            UserDefaults.standard.synchronize()
            
        } catch {
            UserDefaults.standard.synchronize()
            print("Unable to Encode (\(error))")
        }
    }
    
    public static func getData() -> ProfileData? {
        if let data = UserDefaults.standard.data(forKey: Constants.UserDefault.profileData) {
            do {
                
//                    do {
//                        let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//                        print(jsonResponse) //Response result
//                    } catch let parsingError {
//                        print("Error", parsingError)
//                    }
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let dataGame = try decoder.decode(ProfileData.self, from: data)
                return dataGame
            } catch {
                print("Unable to Decode (\(error))")
                return nil
            }
        }
        return nil
    }
}

struct SettingModel: Codable {
    var min_redeem = Int()
    var referral_link = String()
    var contact_us = String()
    var symbol = Int()
    var game_for_private = Int()
    var app_version = String()
    var bank_detail_field = String()
    var referral_id = String()
    var cashfree_stage = String()
    var paytm_mercent_id = String()
    var payumoney_key = String()
    var whats_no = String()
    var payment_gateway = Int()
    var admin_commission = Int()
    var help_support = String()
    var upi_merchant_id = String()
    var bonus = Int()
    var app_message = String()
    var terms = String()
    var share_text = String()
    var adhar_card_field = String()
    var joining_amount = Double()
    var upi_field = String()
    var privacy_policy = String()
    var razor_api_key = String()
    var upi_secret_key = String()
    var referral_amount = Double()
    var upi_id = String()
    var cashfree_client_id = String()
    var extra_spinner = Int()
    
    init() { }
    init(_ json: JSON) {
        min_redeem = json["min_redeem"].intValue
        referral_link = json["referral_link"].stringValue
        contact_us = json["contact_us"].stringValue
        symbol = json["symbol"].intValue
        game_for_private = json["game_for_private"].intValue
        app_version = json["app_version"].stringValue
        bank_detail_field = json["bank_detail_field"].stringValue
        referral_id = json["referral_id"].stringValue
        cashfree_stage = json["cashfree_stage"].stringValue
        paytm_mercent_id = json["paytm_mercent_id"].stringValue
        payumoney_key = json["payumoney_key"].stringValue
        whats_no = json["whats_no"].stringValue
        payment_gateway = json["payment_gateway"].intValue
        admin_commission = json["admin_commission"].intValue
        help_support = json["help_support"].stringValue
        upi_merchant_id = json["upi_merchant_id"].stringValue
        bonus = json["bonus"].intValue
        app_message = json["app_message"].stringValue
        terms = json["terms"].stringValue
        share_text = json["share_text"].stringValue
        adhar_card_field = json["adhar_card_field"].stringValue
        joining_amount = json["joining_amount"].doubleValue
        upi_field = json["upi_field"].stringValue
        privacy_policy = json["privacy_policy"].stringValue
        razor_api_key = json["razor_api_key"].stringValue
        upi_secret_key = json["upi_secret_key"].stringValue
        referral_amount = json["referral_amount"].doubleValue
        upi_id = json["upi_id"].stringValue
        cashfree_client_id = json["cashfree_client_id"].stringValue
        extra_spinner = json["extra_spinner"].intValue
    }
    
    public static func storeData(_ gameData: SettingModel) {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            // Encode Note
            let data = try encoder.encode(gameData)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: Constants.UserDefault.settings)
            UserDefaults.standard.synchronize()
            
        } catch {
            UserDefaults.standard.synchronize()
            print("Unable to Encode (\(error))")
        }
    }
    
    public static func getData() -> SettingModel? {
        if let data = UserDefaults.standard.data(forKey: Constants.UserDefault.settings) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let dataGame = try decoder.decode(SettingModel.self, from: data)
                return dataGame
            } catch {
                print("Unable to Decode (\(error))")
                return nil
            }
        }
        return nil
    }
}

struct UserBankDetailModel {
    var added_date = String()
    var passbook_img = String()
    var acc_holder_name = String()
    var id = Int()
    var acc_no = String()
    var ifsc_code = String()
    var updated_date = String()
    var user_id = Int()
    var isDeleted = Int()
    var bank_name = String()
    
    init() { }
    init(_ json: JSON) {
        added_date = json["added_date"].stringValue
        passbook_img = json["passbook_img"].stringValue
        acc_holder_name = json["acc_holder_name"].stringValue
        id = json["id"].intValue
        acc_no = json["acc_no"].stringValue
        ifsc_code = json["ifsc_code"].stringValue
        updated_date = json["updated_date"].stringValue
        user_id = json["user_id"].intValue
        isDeleted = json["isDeleted"].intValue
        bank_name = json["bank_name"].stringValue
    }
}

struct BannerModel {
    var id = Int()
    var banner = String()
    
    init() { }
    init(_ json: JSON) {
        id = json["id"].intValue
        banner = json["banner"].stringValue
    }
}

struct ProfileRequest : Codable {
    var id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var fcm = UserDefaults.standard.string(forKey: Constants.UserDefault.fcmToken)
    var app_version = Core.GetAppVersion()
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
}

struct ProfileUpdateRequest: Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var name = ""
    var bank_detail = ""
    var upi = ""
    var adhar_card = ""
    var profile_pic = ""
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
}

struct UpdateAvatarRequest: Codable {
    var name = ""
    var bank_detail = ""
    var upi = ""
    var adhar_card = ""
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var avatar = ""
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
}

struct UpdateBankRequest: Codable {
    var bank_name = ""
    var ifsc_code = ""
    var acc_holder_name = ""
    var acc_no = ""
    var passbook_img = ""
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
}


