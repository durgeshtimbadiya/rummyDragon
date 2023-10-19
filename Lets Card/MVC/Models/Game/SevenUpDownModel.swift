//
//  SevenUpDownModel.swift
//  Lets Card
//
//  Created by Durgesh on 28/03/23.
//

import Foundation

struct GameSevenUDRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var room_id = "1"
    var total_bet_up = ""
    var total_bet_down = ""
    var total_bet_tie = ""
}
