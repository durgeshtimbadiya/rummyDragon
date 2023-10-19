//
//  ColourPredictionModel.swift
//  Lets Card
//
//  Created by Durgesh on 21/04/23.
//

import Foundation

struct GameColourPredRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var room_id = "1"
}

struct ColourPredBetRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var game_id = ""
    var bet = " "
    var amount = ""
}
