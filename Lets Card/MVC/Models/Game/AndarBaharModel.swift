//
//  AndarBaharModel.swift
//  Lets Card
//
//  Created by Durgesh on 17/03/23.
//

import SwiftyJSON

struct ABGGameData {
    var id = String()
    var main_card = String()
    var status = -1
    var winning = -1
    var end_datetime = String()
    var added_date = String()
    var time_remaining = Int()
    
    init() { }
    init(_ json: JSON) {
        id = json["id"].stringValue
        main_card = json["main_card"].stringValue.lowercased()
        if let statusd = json["status"].int {
            status = statusd
        } else if let statusd = json["status"].string {
            status = Int(statusd) ?? -1
        }
        
        if let winningd = json["winning"].int {
            winning = winningd
        } else if let winningd = json["winning"].string {
            winning = Int(winningd) ?? -1
        }
        end_datetime = json["end_datetime"].stringValue
        added_date = json["added_date"].stringValue
        if let timeRemain = json["time_remaining"].int {
            time_remaining = timeRemain
        } else if let timeRemain = json["time_remaining"].string {
            time_remaining = Int(timeRemain) ?? 0
        }
    }
    
}

struct GameABGRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var room_id = "1"
    var total_bet_ander = ""
    var total_bet_bahar = ""
}

struct ABGPlaceBetRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var game_id = ""
    var bet = ""
    var amount = ""
}
