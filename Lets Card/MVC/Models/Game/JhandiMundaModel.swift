//
//  JhandiMundaModel.swift
//  Lets Card
//
//  Created by Durgesh on 30/05/23.
//

import SwiftyJSON

struct GameJhandiMundaRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var room_id = "1"
    var total_bet_flag = ""
    var total_bet_face = ""
    var total_bet_club = ""
    var total_bet_diamond = ""
    var total_bet_spade = ""
    var total_bet_heart = ""
}
