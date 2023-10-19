//
//  AuthClient.swift
//  Lets Card
//
//  Created by Durgesh on 26/12/22.
//

import Foundation
import UIKit

class AuthClient {
    static func logout(_ message: String = "") {
        DispatchQueue.main.async {
            if let superview = UIApplication.shared.connectedScenes.map({ $0 as? UIWindowScene }).compactMap({ $0 }).first?.windows.first?.rootViewController as? UINavigationController, !(superview.viewControllers.last is LoginViewController) {
                let myobject = UIStoryboard(name: Constants.Storyboard.auth, bundle: nil).instantiateViewController(withIdentifier: LoginViewController().className)
                superview.pushViewController(myobject, animated: true)
            }
            
            if !message.isEmpty {
                Toast.makeToast(message)
            }
            let deviceToken = UserDefaults.standard.string(forKey: Constants.UserDefault.fcmToken)
            
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            
            UserDefaults.standard.set(deviceToken, forKey: Constants.UserDefault.fcmToken)
            UserDefaults.standard.synchronize()
        }
    }
}
