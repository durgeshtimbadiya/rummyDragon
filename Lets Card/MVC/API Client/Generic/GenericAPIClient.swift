//
//  GenericAPIClient.swift
//  TaleOMeter
//
//  Created by Durgesh on 08/03/22.
//  Copyright © 2022 Durgesh. All rights reserved.
//

import Foundation
import ProgressHUD
import SwiftyJSON

/// Generic client to avoid rewrite URL session code
protocol GenericAPIClient {
    var session: URLSession { get }
    func fetch<T: Decodable>(with request: URLRequest, responseKey: String, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void)
}

extension GenericAPIClient {
    
    typealias JSONTaskCompletionHandler = (Decodable?, APIError?) -> Void
    
    private func decodingTask<T: Decodable>(with request: URLRequest, responseKey: String, decodingType: T.Type, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
//        session.configuration.httpMaximumConnectionsPerHost = 10
            let task = session.dataTask(with: request) { data, response, error in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, .requestFailed(error?.localizedDescription ?? "No description"))
                    return
                }
                
                guard httpResponse.statusCode == 200 else {
                    if httpResponse.statusCode == 426 {
                        completion(nil, .applVersionNotvalid("\(httpResponse.statusCode)"))
                    } else {
                        completion(nil, .responseUnsuccessful("\(httpResponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))"))
                    }
                    return
                }
                
                guard let data = data else {
                    completion(nil, .invalidData)
                    return
                }
                
//                do {
//                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(jsonResponse) //Response result
//                } catch let parsingError {
//                    print("Error", parsingError)
//                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let responseDictionary = jsonResponse as? Dictionary<String, AnyObject> {
                        let jsonDictionary = JSON(responseDictionary)
                        if let code = jsonDictionary["code"].int {
                            var responseAPIModel = ResponseAPIModel(code: code, message: jsonDictionary["message"].stringValue, data_array: nil, data: nil)
                            if responseKey.lowercased() == "all" {
                                responseAPIModel = ResponseAPIModel(code: code, message: jsonDictionary["message"].stringValue, data_array: nil, data: jsonDictionary)
                            } else if let dictionaryData = jsonDictionary[responseKey].dictionary {
                                responseAPIModel = ResponseAPIModel(code: code, message: jsonDictionary["message"].stringValue, data_array: nil, data: JSON(dictionaryData))
                            } else if let arrayData = jsonDictionary[responseKey].array {
                                responseAPIModel = ResponseAPIModel(code: code, message: jsonDictionary["message"].stringValue, data_array: arrayData, data: nil)
                            }
                            if code == 411 {
                                AuthClient.logout("You are Logged in from another device.")
                            }
                            completion(responseAPIModel, nil)
                        }
                    }
                    //                let genericModel = try JSONDecoder().decode(decodingType, from: data)
                    //                completion(genericModel, nil)
                } catch let err {
                    //                if decodingType != ResponseModelJSON.self {
                    //                    do {
                    //                        let genericModel = try JSONDecoder().decode(ResponseModel1.self, from: data)
                    //                        let responseJson = ResponseModel(code: genericModel.code, message: genericModel.message, data_array: genericModel., data: JSON())
                    //                        completion(responseJson, nil)
                    //                    } catch let err {
                    //                        completion(nil, .jsonConversionFailure("\(err.localizedDescription)"))
                    //                    }
                    //                } else {
                    completion(nil, .jsonConversionFailure("\(err.localizedDescription)"))
                    //                }
                }
            }
            return task
    }
    
    /// success respone executed on main thread.
    func fetch<T: Decodable>(with request: URLRequest, responseKey: String, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>) -> Void) {
            let task = decodingTask(with: request, responseKey: responseKey, decodingType: T.self) { (json , error) in
                DispatchQueue.main.async {
                    guard let json = json else {
                        error != nil ? completion(.failure(.decodingTaskFailure("\(error!)"))) : completion(.failure(.invalidData))
                        ProgressHUD.dismiss()
                        return
                    }
                    guard let value = decode(json) else { completion(.failure(.jsonDecodingFailure)); return }
                    completion(.success(value))
                }
            }
            task.resume()
    }
}
