//
//  GameDataModel.swift
//  Lets Card
//
//  Created by Durgesh on 02/01/23.
//

import SwiftyJSON

struct GameTablePlayer {
    var name = String()
    var profile_pic = String()
    var table_id = Int()
    var user_id = Int()
    var wallet = Double()
    var added_date = String()
    var isDeleted = Int()
    var mobile = String()
    var seat_position = Int()
    var id = Int()
    var user_type = Int()
    var updated_date = String()
    
    init(_ json: JSON) {
        name = ""
        if let nameis = json["name"].string, nameis != "0" {
            name = nameis
        }
        profile_pic = "\(Constants.baseURL)\(APIClient.imagePath)\(json["profile_pic"].stringValue)"
        table_id = json["table_id"].intValue
        user_id = json["user_id"].intValue
        wallet = json["wallet"].doubleValue
        added_date = json["added_date"].stringValue
        isDeleted = json["isDeleted"].intValue
        mobile = json["mobile"].stringValue
        seat_position = json["seat_position"].intValue
        id = json["id"].intValue
        user_type = json["user_type"].intValue
        updated_date = json["updated_date"].stringValue
    }
}

struct TableDetailData {
    var updated_date = String()
    var added_date = String()
    var boot_value = 0.0
    var pot_limit = 0.0
    var chaal_limit = 0.0
    var maximum_blind = 0.0
    var id = String()
    var privateTable = String()
    var isDeleted = String()
    
    init() { }
    init(_ json: JSON) {
        updated_date = json["updated_date"].stringValue
        added_date = json["added_date"].stringValue
        if let valueis = json["boot_value"].string {
            boot_value = Double(valueis) ?? 0.0
        } else if let valuew = json["boot_value"].double {
            boot_value = valuew
        }
        if let valueis = json["pot_limit"].string {
            pot_limit = Double(valueis) ?? 0.0
        } else if let valuew = json["pot_limit"].double {
            pot_limit = valuew
        }
        if let valueis = json["chaal_limit"].string {
            chaal_limit = Double(valueis) ?? 0.0
        } else if let valuew = json["chaal_limit"].double {
            chaal_limit = valuew
        }
        if let valueis = json["maximum_blind"].string {
            maximum_blind = Double(valueis) ?? 0.0
        } else if let valuew = json["maximum_blind"].double {
            maximum_blind = valuew
        }
        id = json["id"].stringValue
        privateTable = json["private"].stringValue
        isDeleted = json["isDeleted"].stringValue
    }
}

struct GameLogData {
    var id = Int()
    var amount = Double()
    var user_id = Int()
    var action = Int()
    var points = Int()
    var seen = Int()
    var timeout = Int()
    var game_id = Int()
    var added_date = String()
    
    init() { }
    init(_ json: JSON) {
        id = json["id"].intValue
        amount = json["amount"].doubleValue
        user_id = json["user_id"].intValue
        action = json["action"].intValue
        points = json["points"].intValue
        seen = json["seen"].intValue
        timeout = json["timeout"].intValue
        game_id = json["game_id"].intValue
        added_date = json["added_date"].stringValue
    }
}

struct GameCardModel {
    var user_id = Int()
    var packed = Int()
    var seen = Int()
    var card1 = String()
    var card2 = String()
    var card3 = String()
   
    init() { }
    init(_ json: JSON) {
        user_id = json["user_id"].intValue
        packed = json["packed"].intValue
        seen = json["seen"].intValue
        card1 = json["card1"].stringValue.lowercased()
        card2 = json["card2"].stringValue.lowercased()
        card3 = json["card3"].stringValue.lowercased()
    }
}
//
//struct GameCardModel {
//    var card1 = String()
//    var card2 = String()
//    var card3 = String()
//    var user_id = Int()
//    
//    init() { }
//    init(_ json: JSON) {
//        card1 = json["card1"].stringValue.lowercased()
//        card2 = json["card2"].stringValue.lowercased()
//        card3 = json["card3"].stringValue.lowercased()
//        user_id = json["user_id"].intValue
//    }
//}

struct GameSideShowModel {
    var prev_id = Int()
    var id = Int()
    var status = Int()
    var user_id = Int()
    var name = String()
    
    init() {  }
    init(_ json: JSON) {
        prev_id = json["prev_id"].intValue
        id = json["id"].intValue
        status = json["status"].intValue
        user_id = json["user_id"].intValue
        name = json["name"].stringValue
    }
}

struct GameStatusRequest: Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var game_id = ""
    var table_id = ""
}

struct GameRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
}

struct GameJoinRequest: Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var boot_value = ""
    var table_id = ""
}

struct GameTipsRequest: Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var tip = ""
    var gift_id = "0"
    var to_user_id = "0"
}

struct GamePackRequest: Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var timeout = ""
}

struct GameSideShowRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var prev_user_id = Int()
}

struct GameSideShowActionRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var slide_id = Int()
    var type = String()
}

struct GameChaalRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var plus = Int()
}

struct ChatModel {
    var chat = String()
    var to_user_id = Int()
    var game_id = Int()
    var id = Int()
    var user_id = Int()
    var added_date = String()
    
    init() {   }
    init(_ json: JSON) {
        chat = json["chat"].stringValue
        if let valueis = json["to_user_id"].string {
            to_user_id = Int(valueis) ?? 0
        } else if let valuew = json["to_user_id"].int {
            to_user_id = valuew
        }
        if let valueis = json["game_id"].string {
            game_id = Int(valueis) ?? 0
        } else if let valuew = json["game_id"].int {
            game_id = valuew
        }
        if let valueis = json["id"].string {
            id = Int(valueis) ?? 0
        } else if let valuew = json["id"].int {
            id = valuew
        }
        if let valueis = json["user_id"].string {
            user_id = Int(valueis) ?? 0
        } else if let valuew = json["user_id"].int {
            user_id = valuew
        }
        added_date = json["added_date"].stringValue
    }
}

struct GameChatRequest : Codable {
    var user_id = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    var token = UserDefaults.standard.string(forKey: Constants.UserDefault.loginToken) ?? ""
    var game_id = String()
    var chat = String()
}

struct GiftDataModel {
    var id = Int()
    var name = String()
    var image = String()
    var coin = String()
    
    init() {    }
    init(_ json: JSON) {
        if let valueis = json["id"].string {
            id = Int(valueis) ?? 0
        } else if let valuew = json["id"].int {
            id = valuew
        }
        name = json["name"].stringValue
        image = "\(Constants.baseURL)\(APIClient.imagePath)\(json["image"].stringValue)"
        coin = json["coin"].stringValue
    }
}
