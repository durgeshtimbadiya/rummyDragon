//
//  RedVsBlackModel.swift
//  Lets Card
//
//  Created by Durgesh on 16/05/23.
//

import SwiftyJSON

struct JackpotRuleModel {
    var Rule_type = String()
    var Rule_value = Int()
    var Added_amount = Int()
    var Select_amount = Int()
    var Into = String()
    var View_type = Int()
}

struct GameRedVsBlkRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var room_id = "1"
    var total_bet_red = ""
    var total_bet_black = ""
    var total_bet_pair = ""
    var total_bet_color = ""
    var total_bet_sequence = ""
    var total_bet_pure_sequence = ""
    var total_bet_set = ""
}
