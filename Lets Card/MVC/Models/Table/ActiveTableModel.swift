//
//  ActiveTableModel.swift
//  Lets Card
//
//  Created by Durgesh on 29/12/22.
//

import SwiftyJSON

struct ActiveTableModel {
    var pot_limit = Double()
    var chaal_limit = Double()
    var min_amount = Double()
    var added_date = String()
    var updated_date = String()
    var isDeleted = Int()
    var online_members = Int()
    var maximum_blind = Double()
    var id = Int()
    var boot_value = Double()
    var point_value = Double()
    
    init(_ json: JSON) {
        pot_limit = json["pot_limit"].doubleValue
        chaal_limit = json["chaal_limit"].doubleValue
        min_amount = json["min_amount"].doubleValue
        added_date = json["added_date"].stringValue
        updated_date = json["updated_date"].stringValue
        isDeleted = json["isDeleted"].intValue
        online_members = json["online_members"].intValue
        maximum_blind = json["maximum_blind"].doubleValue
        id = json["id"].intValue
        boot_value = json["boot_value"].doubleValue
        point_value = json["point_value"].doubleValue
    }
}
