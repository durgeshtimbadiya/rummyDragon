//
//  ResponseModel.swift
//  Lets Card
//
//  Created by Durgesh on 14/12/22.
//

import Foundation
import SwiftyJSON
import UIKit

struct ResponseAPIModel: Decodable {
    let code: Int?
    let message: String?
    let data_array: [JSON]?
    let data: JSON?

//    private enum CodingKeys : String, CodingKey { case code, message, data_array, data }
//    init(from decoder : Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        do {
//            self.code = try container.decode(Int.self, forKey: .code)
//        } catch {
//            self.code = Int()
//        }
//        do {
//            let type = try container.decode(String.self, forKey: .message)
//            self.message = type
//        } catch {
//            self.message = String()
//        }
//        do {
//            self.data_array = try container.decode([JSON].self, forKey: .data_array)
//        } catch {
//            self.data_array = [JSON]()
//        }
//        do {
//            self.data = try container.decode(JSON.self, forKey: .data)
//        } catch {
//            self.data = JSON()
//        }
//    }
}

struct ResponseModel: Decodable {
    let code: Int?
    let message: String?
    let user_data: [JSON]?
    let avatar: [String]?
    let setting: JSON?
    let user_bank_details: [JSON]?
    let table_data: [JSON]?
    let game_setting: JSON?
    let table_users: [JSON]?

    private enum CodingKeys : String, CodingKey { case code, message, user_data, avatar, setting, user_bank_details, table_data, game_setting, table_users }
    init(from decoder : Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.code = try container.decode(Int.self, forKey: .code)
        } catch {
            self.code = Int()
        }
        do {
            let type = try container.decode(String.self, forKey: .message)
            self.message = type
        } catch {
            self.message = String()
        }
        do {
            self.user_data = try container.decode([JSON].self, forKey: .user_data)
        } catch {
            self.user_data = [JSON]()
        }
        do {
            self.avatar = try container.decode([String].self, forKey: .avatar)
        } catch {
            self.avatar = [String]()
        }
        do {
            self.setting = try container.decode(JSON.self, forKey: .setting)
        } catch {
            self.setting = JSON()
        }
        do {
            self.user_bank_details = try container.decode([JSON].self, forKey: .user_bank_details)
        } catch {
            self.user_bank_details = [JSON]()
        }
        do {
            self.table_data = try container.decode([JSON].self, forKey: .table_data)
        } catch {
            self.table_data = [JSON]()
        }
        do {
            self.game_setting = try container.decode(JSON.self, forKey: .game_setting)
        } catch {
            self.game_setting = JSON()
        }
        do {
            self.table_users = try container.decode([JSON].self, forKey: .table_users)
        } catch {
            self.table_users = [JSON]()
        }
        
    }
}

struct EmptyRequest: Encodable {
    
}

struct ResponseAPI {
    
    static let errorMessage = "Something was so wrong in your request or your handling that the API simply couldn't parse the passed data"
    
    // MARK: check response and parse as per requirement
   /* static func getResponseArray(_ result: Result<ResponseModel?, APIError>, showAlert: Bool = true, showSuccMessage: Bool = false, completion: @escaping ([JSON]?) -> ()) {
        switch result {
        case .success(let aPIResponse):
            if let response = aPIResponse, let status = response.status, status, let responseData = response.data {
                if showSuccMessage, let msg = response.message as? String {
                    Toast.show(msg)
                }
                completion(responseData)
            } else if let response = aPIResponse, let msg = response.message, (msg is String || msg is JSON) {
                let messageis = getMessageString(msg)
                if messageis.lowercased().contains("unauthorized") {
//                    AuthClxient.logout("Logged out successfully")
                    completion(nil)
                } else {
                    if showAlert {
                        Toast.show(messageis)
                    }
                    completion(nil)
                }
            } else {
                if showAlert {
                    Toast.show(errorMessage)
                }
                completion(nil)
            }
        case .failure(let error):
            if showAlert {
                Toast.show(error.customDescription)
            }
            completion(nil)
        }
    }
    
    // MARK: check response and parse as per requirement
    static func getResponseArray1(_ result: Result<ResponseModel1?, APIError>, showAlert: Bool = true, showSuccMessage: Bool = false, completion: @escaping ([JSON]?, Int?, Int?) -> ()) {
        switch result {
        case .success(let aPIResponse):
            if let response = aPIResponse, let status = response.status, status, let responseData = response.data, let chat_count = response.chat_count, let noti_count = response.notification_count {
                if showSuccMessage, let msg = response.message as? String {
                    Toast.makeToast(msg)
                }
                completion(responseData, chat_count, noti_count)
            } else if let response = aPIResponse, let msg = response.message, (msg is String || msg is JSON) {
                let messageis = getMessageString(msg)
                if messageis.lowercased().contains("unauthorized") {
//                    AuthClient.logout("Logged out successfully")
                    completion(nil, nil, nil)
                } else {
                    if showAlert {
                        Toast.makeToast(messageis)
                    }
                    completion(nil, nil, nil)
                }
            } else {
                if showAlert {
                    Toast.makeToast(errorMessage)
                }
                completion(nil, nil, nil)
            }
        case .failure(let error):
            if showAlert {
                Toast.makeToast(error.customDescription)
            }
            completion(nil, nil, nil)
        }
    }
    
   static func getResponseJson(_ result: Result<ResponseModelJSON?, APIError>, showAlert: Bool = true, showSuccMessage: Bool = false, completion: @escaping (JSON?) -> ()) {
        switch result {
        case .success(let aPIResponse):
            if let response = aPIResponse, let status = response.status, status, let responseData = response.data {
                if showSuccMessage, let msg = response.message as? String {
                    Toast.show(msg)
                }
                completion(responseData)
            } else if let response = aPIResponse, let msg = response.message, (msg is String || msg is JSON) {
                let messageis = getMessageString(msg)
                if messageis.lowercased().contains("unauthorized") {
//                    AuthClient.logout("Logged out successfully")
                    completion(nil)
                } else {
                    if showAlert {
                        Toast.show(messageis)
                    }
                    completion(nil)
                }
            } else {
                if showAlert {
                    Toast.show(errorMessage)
                }
                completion(nil)
            }
        case .failure(let error):
            if showAlert {
                Toast.show(error.customDescription)
            }
            completion(nil)
        }
    }
    
    static func getResponseJsonBool(_ result: Result<ResponseModelJSON?, APIError>, showAlert: Bool = true, showSuccMessage: Bool = false, completion: @escaping (Bool) -> ()) {
        switch result {
        case .success(let aPIResponse):
            if let response = aPIResponse, let status = response.status, status {
                if showSuccMessage, let msg = response.message as? String {
                    Toast.show(msg)
                }
                completion(status)
            } else if let response = aPIResponse, let msg = response.message, (msg is String || msg is JSON) {
                let messageis = getMessageString(msg)
                if messageis.lowercased().contains("unauthorized") {
//                    AuthClient.logout("Logged out successfully")
                    completion(false)
                } else {
                    if showAlert {
                        Toast.show(messageis)
                    }
                    completion(false)
                }
            } else {
                if showAlert {
                    Toast.show(errorMessage)
                }
                completion(false)
            }
        case .failure(let error):
            if showAlert {
                Toast.show(error.customDescription)
            }
            completion(false)
        }
    }
    
    static func getResponseJsonToken(_ result: Result<ResponseModelJSON?, APIError>, showAlert: Bool = true, showSuccMessage: Bool = false, completion: @escaping (JSON?, Bool, String, Bool) -> ()) {
        switch result {
        case .success(let aPIResponse):
            if let response = aPIResponse, let status = response.status, status {
                if let responseData = response.data {
                    if showSuccMessage, let msg = response.message as? String {
                        Toast.show(msg)
                    }
                    completion(responseData, status, response.token ?? "", response.new_registeration == 1)
                } else {
                    completion(nil, status, "", false)
                }
            } else if let response = aPIResponse, let msg = response.message, (msg is String || msg is JSON) {
                let messageis = getMessageString(msg)
                if messageis.lowercased().contains("unauthorized") {
//                    AuthClient.logout("Logged out successfully")
                    completion(nil, false, "", false)
                } else {
                    if showAlert {
                        Toast.show(messageis)
                    }
                    completion(nil, false, "", false)
                }
            } else {
                if showAlert {
                    Toast.show(errorMessage)
                }
                completion(nil, false, "", false)
            }
        case .failure(let error):
            if showAlert {
                Toast.show(error.customDescription)
            }
            completion(nil, false, "", false)
        }
    }*/
    
    static func getMessageString(_ messageData: AnyObject) -> String {
        var messageStr = errorMessage
        if let message = messageData as? String {
            return message
        } else if let message = messageData as? JSON {
            for (_, value) in message {
                if let msg = value.string {
                    messageStr = msg
                    break
                } else if let msgArray = value.array, msgArray.count > 0, let msgg =  msgArray[0].string {
                    messageStr = msgg
                    break
                }
            }
        }
        return messageStr
    }
}
