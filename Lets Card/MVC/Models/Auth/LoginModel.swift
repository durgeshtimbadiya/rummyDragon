//
//  LoginModel.swift
//  Lets Card
//
//  Created by Durgesh on 16/12/22.
//

import SwiftyJSON

class LoginData {
    var rummy_pool_table_id = Int()
    var user_category_id = Int()
    var rummy_table_id = Int()
    var poker_table_id = Int()
    var rummy_deal_table_id = Int()
    var referral_code = String()
    var premium = Int()
    var car_roulette_room_id = Int()
    var token = String()
    var rummy_tournament_table_id = Int()
    var ludo_table_id = Int()
    var winning_wallet = Double()
    var password = String()
    var id = Int()
    var color_prediction_room_id = Int()
    var seven_up_room_id = Int()
    var app_version = String()
    var updated_date = String()
    var adhar_card = String()
    var user_type = Int()
    var status = Bool()
    var jackpot_room_id = Int()
    var wallet = Double()
    var isDeleted = Bool()
    var email = String()
    var mobile = String()
    var profile_pic = String()
    var baccarat_id = Int()
    var head_tail_room_id = Int()
    var name = String()
    var jhandi_munda_id = Int()
    var animal_roulette_room_id = Int()
    var source = String()
    var red_black_id = Int()
    var bank_detail = String()
    var upi = String()
    var game_played = String()
    var added_date = String()
    var table_id = Int()
    var ander_bahar_room_id = Int()
    var spin_remaining = String()
    var referred_by = String()
    var gender = String()
    var fcm = String()
    var dragon_tiger_room_id = Int()
    var roulette_id = Int()
    
    init() { }
    init(_ json: JSON) {
        rummy_pool_table_id = json["rummy_pool_table_id"].intValue
        user_category_id = json["user_category_id"].intValue
        rummy_table_id = json["rummy_table_id"].intValue
        poker_table_id = json["poker_table_id"].intValue
        rummy_deal_table_id = json["rummy_deal_table_id"].intValue
        referral_code = json["referral_code"].stringValue
        premium = json["premium"].intValue
        car_roulette_room_id = json["car_roulette_room_id"].intValue
        token = json["token"].stringValue
        rummy_tournament_table_id = json["rummy_tournament_table_id"].intValue
        ludo_table_id = json["ludo_table_id"].intValue
        winning_wallet = json["winning_wallet"].doubleValue
        password = json["password"].stringValue
        id = json["id"].intValue
        color_prediction_room_id = json["color_prediction_room_id"].intValue
        seven_up_room_id = json["seven_up_room_id"].intValue
        app_version = json["app_version"].stringValue
        updated_date = json["updated_date"].stringValue
        adhar_card = json["adhar_card"].stringValue
        user_type = json["user_type"].intValue
        status = false
        if let sts = json["status"].int, sts == 1 {
            status = true
        }
        
        jackpot_room_id = json["jackpot_room_id"].intValue
        wallet = json["wallet"].doubleValue
        isDeleted = false
        if let dlt = json["isDeleted"].int, dlt == 1 {
            isDeleted = true
        }
        email = json["email"].stringValue
        mobile = json["mobile"].stringValue
        profile_pic = json["profile_pic"].stringValue
        baccarat_id = json["baccarat_id"].intValue
        head_tail_room_id = json["head_tail_room_id"].intValue
        name = json["name"].stringValue
        jhandi_munda_id = json["jhandi_munda_id"].intValue
        animal_roulette_room_id = json["animal_roulette_room_id"].intValue
        source = json["source"].stringValue
        red_black_id = json["red_black_id"].intValue
        bank_detail = json["bank_detail"].stringValue
        upi = json["upi"].stringValue
        game_played = json["game_played"].stringValue
        added_date = json["added_date"].stringValue
        table_id = json["table_id"].intValue
        ander_bahar_room_id = json["ander_bahar_room_id"].intValue
        spin_remaining = json["spin_remaining"].stringValue
        referred_by = json["referred_by"].stringValue
        gender = json["gender"].stringValue
        fcm = json["fcm"].stringValue
        dragon_tiger_room_id = json["dragon_tiger_room_id"].intValue
        roulette_id = json["roulette_id"].intValue
    }
}

struct LoginRequest: Codable {
    var mobile = ""
    var password = ""
    var type = "login"
}

struct RegisterRequest: Codable {
    var otp = ""
    var otp_id = ""
    var mobile = ""
    var name = ""
    var pan_card_no = ""
    var dob = ""
    var state = ""
    var password = ""
    var gender = ""
    var referral_code = ""
    var type = "register"
//    var pan_card = "" // Pan card image bitmap
}

struct GameOnOffModel: Codable {
    var poker = Int()
    var seven_up_down = Int()
    var roulette = Int()
    var deal_rummy = Int()
    var updated_date = String()
    var animal_roulette = Int()
    var dragon_tiger = Int()
    var car_roulette = Int()
    var ludo_local = Int()
    var tournament_rummy = Int()
    var jhandi_munda = Int()
    var ludo_computer = Int()
    var isDeleted = Int()
    var private_rummy = Int()
    var color_prediction = Int()
    var pool_rummy = Int()
    var id = Int()
    var point_rummy = Int()
    var jackpot_teen_patti = Int()
    var red_vs_black = Int()
    var andar_bahar = Int()
    var added_date = String()
    var head_tails = Int()
    var ludo_online = Int()
    var private_table = Int()
    var custom_boot = Int()
    var teen_patti = Int()
    var bacarate = Int()
    
    init(_ json: JSON) {
        poker = json["poker"].intValue
        seven_up_down = json["seven_up_down"].intValue
        roulette = json["roulette"].intValue
        deal_rummy = json["deal_rummy"].intValue
        updated_date = json["updated_date"].stringValue
        animal_roulette = json["animal_roulette"].intValue
        dragon_tiger = json["dragon_tiger"].intValue
        car_roulette = json["car_roulette"].intValue
        ludo_local = json["ludo_local"].intValue
        tournament_rummy = json["tournament_rummy"].intValue
        jhandi_munda = json["jhandi_munda"].intValue
        ludo_computer = json["ludo_computer"].intValue
        isDeleted = json["isDeleted"].intValue
        private_rummy = json["private_rummy"].intValue
        color_prediction = json["color_prediction"].intValue
        pool_rummy = json["pool_rummy"].intValue
        id = json["id"].intValue
        point_rummy = json["point_rummy"].intValue
        jackpot_teen_patti = json["jackpot_teen_patti"].intValue
        red_vs_black = json["red_vs_black"].intValue
        andar_bahar = json["andar_bahar"].intValue
        added_date = json["added_date"].stringValue
        head_tails = json["head_tails"].intValue
        ludo_online = json["ludo_online"].intValue
        private_table = json["private_table"].intValue
        custom_boot = json["custom_boot"].intValue
        teen_patti = json["teen_patti"].intValue
        bacarate = json["bacarate"].intValue
    }
    
    public static func storeData(_ gameData: GameOnOffModel) {
        do {            
            // Create JSON Encoder
            let encoder = JSONEncoder()
            // Encode Note
            let data = try encoder.encode(gameData)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: Constants.UserDefault.gameOnOffData)
            UserDefaults.standard.synchronize()
            
        } catch {
            UserDefaults.standard.synchronize()
            print("Unable to Encode (\(error))")
        }
    }
    
    public static func getData() -> GameOnOffModel? {
        if let data = UserDefaults.standard.data(forKey: Constants.UserDefault.gameOnOffData) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                let dataGame = try decoder.decode(GameOnOffModel.self, from: data)
                return dataGame
            } catch {
                print("Unable to Decode (\(error))")
                return nil
            }
        }
        return nil
    }

}

/*
 {
   "poker" : "1",
   "seven_up_down" : "1",
   "roulette" : "1",
   "deal_rummy" : "1",
   "updated_date" : "2022-12-20 11:37:39",
   "animal_roulette" : "1",
   "dragon_tiger" : "1",
   "car_roulette" : "1",
   "ludo_local" : "1",
   "tournament_rummy" : "1",
   "jhandi_munda" : "1",
   "ludo_computer" : "1",
   "isDeleted" : "0",
   "private_rummy" : "1",
   "color_prediction" : "1",
   "pool_rummy" : "1",
   "id" : "1",
   "point_rummy" : "1",
   "jackpot_teen_patti" : "1",
   "red_vs_black" : "1",
   "andar_bahar" : "1",
   "added_date" : "2022-11-29 00:00:00",
   "head_tails" : "1",
   "ludo_online" : "1",
   "private_table" : "1",
   "custom_boot" : "1",
   "teen_patti" : "1",
   "bacarate" : "1"
 }
 */

struct ForgotPasswordRequest : Codable {
    var mobile = String()
}
