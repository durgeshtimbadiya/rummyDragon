//
//  RouletteModel.swift
//  Lets Card
//
//  Created by Durgesh on 09/06/23.
//

import SwiftyJSON

struct GameRouletteRequest : Codable {
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
