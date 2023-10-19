//
//  HeadTailModel.swift
//  Lets Card
//
//  Created by Durgesh on 08/05/23.
//

import SwiftyJSON

struct HeadTailBotModel {
    var id = Int()
    var name = String()
    var coin = String()
    var avatar = String()
    
    init() {   }
    init(_ json: JSON) {
        id = json["id"].intValue
        name = json["name"].stringValue
        coin = "₹ \(json["coin"].stringValue) "
//        avatar = json["avatar"].stringValue
        if let profilePath = json["avatar"].string {
            avatar = "\(Constants.baseURL)\(APIClient.imagePath)\(profilePath)"
        }
    }
}
