//
//  BaccaratGameModel.swift
//  Lets Card
//
//  Created by Durgesh on 22/05/23.
//

import SwiftyJSON

struct GameBaccaratRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var room_id = "1"
    var total_bet_banker = ""
    var total_bet_player = ""
    var total_bet_banker_pair = ""
    var total_bet_player_pair = ""
    var total_bet_tie = ""
}
