//
//  AnimalRouletteModel.swift
//  Lets Card
//
//  Created by Durgesh on 18/04/23.
//

import Foundation

struct GameAnimalRouletteRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var room_id = "1"
}

struct AnimalRouletteBetRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var game_id = ""
    var bet = " "
    var amount = ""
}
