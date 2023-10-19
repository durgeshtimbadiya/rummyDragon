//
//  LoginViewController.swift
//  Lets Card
//
//  Created by Durgesh on 14/12/22.
//

import UIKit

class LoginViewController: UIViewController {
        
    @IBOutlet weak var mobileNoText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var forgotMobileText: UITextField!
    @IBOutlet weak var forgotView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the vi`ew.
        self.hideKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func tapOnLogin(_ sender: UIButton) {
        if self.mobileNoText.text!.isEmpty {
            Toast.makeToast("Enter Mobile Number")
            return
        }
        if self.passwordText.text!.isEmpty {
            Toast.makeToast("Enter Password")
            return
        }
        APIClient.shared.post(parameters: LoginRequest(mobile: self.mobileNoText.text!, password: self.passwordText.text!), feed: .login, responseKey: "user_data") { reult in
            switch reult {
            case .success(let aPIResponse):
                if let response = aPIResponse?.data_array, response.count > 0, aPIResponse?.code == 200 {
                    let loginData = LoginData(response[0])
                    UserDefaults.standard.set(loginData.id, forKey: Constants.UserDefault.userId)
                    UserDefaults.standard.set(loginData.name, forKey: Constants.UserDefault.userName)
                    UserDefaults.standard.set(loginData.mobile, forKey: Constants.UserDefault.mobileNumber)
                    UserDefaults.standard.set(loginData.token, forKey: Constants.UserDefault.loginToken)
                    UserDefaults.standard.set(true, forKey: Constants.UserDefault.isLogin)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.getGamesOnOff()
                    }
                } else {
                    Toast.makeToast("Wrong mobile number or password")
                }
            case .failure(let error):
                Toast.makeToast(error.customDescription)
            }
        }
    }

    @IBAction func tapOnForgotPassword(_ sender: UIButton) {
        self.forgotMobileText.text = ""
        self.forgotView.isHidden = false
    }
    
    @IBAction func tapOnRegister(_ sender: UIButton) {
        Core.push(self, storyboard: Constants.Storyboard.auth, storyboardId: RegisterViewController().className)
    }
    
    func getGamesOnOff() {
        APIClient.shared.post(parameters: EmptyRequest(), feed: .game_on_off, responseKey: "game_setting") { result in
            switch result {
            case .success(let aPIResponse):
                if let response = aPIResponse, let gamesData = response.data {
//                    print(response)
                    let gameOnOff = GameOnOffModel(gamesData)
                    GameOnOffModel.storeData(gameOnOff)
                    Core.push(self, storyboard: Constants.Storyboard.main, storyboardId: DashboardViewController().className)
                    Toast.makeToast("Login Successfull")
                }
                break
            case .failure(let error):
                Toast.makeToast(error.customDescription)
            }
        }
    }
    
    func forgotPassword() {
        APIClient.shared.post(parameters: ForgotPasswordRequest(mobile: self.forgotMobileText.text!), feed: .forgot_password, responseKey: "") { result in
            switch result {
            case .success(let aPIResponse):
                if let response = aPIResponse, let message = response.message {
                    Toast.makeToast(message)
                }
                break
            case .failure(let error):
                Toast.makeToast(error.customDescription)
            }
            self.forgotView.isHidden = true
        }
    }
    
    @IBAction func tapOnForgotPassButton(_ sender: UIButton) {
        switch sender.tag {
        case 0: // Send
            if self.forgotMobileText.text!.isEmpty {
                Toast.makeToast("Please Enter Mobile Number")
                return
            }
            if self.forgotMobileText.text!.count < 10 {
                Toast.makeToast("Please Enter Valid Mobile Number")
                return
            }
            forgotPassword()
            break
        case 1: // Close
            self.forgotView.isHidden = true
            break
        default:
            break
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 16 characters
        return textField == self.mobileNoText || textField == self.forgotMobileText ? updatedText.count <= 10 : true
    }
}
