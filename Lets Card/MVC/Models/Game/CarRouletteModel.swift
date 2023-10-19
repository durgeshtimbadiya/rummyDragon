//
//  CarRouletteModel.swift
//  Lets Card
//
//  Created by Durgesh on 06/04/23.
//

import Foundation

struct GameCarRouletteRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var room_id = "1"
}

struct CarRouletteBetRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var game_id = ""
    var bet = " "
    var amount = ""
}
