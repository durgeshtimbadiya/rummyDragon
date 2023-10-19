//
//  DrangonTigerModel.swift
//  Lets Card
//
//  Created by Durgesh on 02/03/23.
//

import SwiftyJSON

struct LastWinningsModel {
    var comission_amount = String()
    var winning = String()
    var winning_amount = String()
    var end_datetime = String()
    var added_date = String()
    var user_amount = String()
    var updated_date = String()
    var status = String()
    var total_amount = String()
    var admin_profit = String()
    var id = String()
    var room_id = String()
    var main_card = String()
    
    init() {}
    init(_ json: JSON) {
        comission_amount = json["comission_amount"].stringValue
        winning = json["winning"].stringValue
        winning_amount = json["winning_amount"].stringValue
        end_datetime = json["end_datetime"].stringValue
        added_date = json["added_date"].stringValue
        user_amount = json["user_amount"].stringValue
        updated_date = json["updated_date"].stringValue
        status = json["status"].stringValue
        total_amount = json["total_amount"].stringValue
        admin_profit = json["admin_profit"].stringValue
        id = json["id"].stringValue
        room_id = json["room_id"].stringValue
        main_card = json["main_card"].stringValue
    }
}

struct DNTCardModel {
    var id = Int()
    var added_date = String()
    var card = String()
    var dragon_tiger_id = Int()
    
    init() { }
    init(_ json: JSON) {
        id = json["id"].intValue
        added_date = json["added_date"].stringValue
        card = json["card"].stringValue.lowercased()
        dragon_tiger_id = json["dragon_tiger_id"].intValue
    }
}
/*
 {
   "id" : "4425",
   "added_date" : "2023-03-02 15:12:23",
   "card" : "BP6",
   "dragon_tiger_id" : "2213"
 }
 */
struct GameDNTRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var room_id = "1"
    var total_bet_dragon = ""
    var total_bet_tiger = ""
    var total_bet_tie = ""
}

struct DNTPlaceBetRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var game_id = ""
    var bet = ""
    var amount = ""
}
