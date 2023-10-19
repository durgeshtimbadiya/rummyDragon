//
//  JackpotRuleModel.swift
//  Lets Card
//
//  Created by Durgesh on 03/07/23.
//

import Foundation

struct JackpotRulesModel {
    var isWine = false
    var animatedAddedAmount = false
    var last_added_id = Int()
    var last_added_amount = Int()
    var last_added_rule_value = Int()
    var rule_type = String()
    var rule_value = Int()
    var added_amount = Int()
    var select_amount = Int()
    var into = String()
}

struct Game3PJackpotRequest: Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var room_id = "1"
    var total_bet_high_card = ""
    var total_bet_pair = ""
    var total_bet_color = ""
    var total_bet_sequence = ""
    var total_bet_pure_sequence = ""
}

struct Game3JackHistRequest: Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var room_id = "1"
}
