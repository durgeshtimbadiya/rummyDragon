//
//  RegisterViewController.swift
//  Lets Card
//
//  Created by Durgesh on 20/02/23.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var mobileNoText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var refferalCodeText: UITextField!
    @IBOutlet weak var oTPText: UITextField!
    @IBOutlet weak var editMobileNoText: UITextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!

    @IBOutlet weak var oTPMainView: UIView!
    @IBOutlet weak var oTPTextView: UIView!
    @IBOutlet weak var registerTextView: UIView!
    private var otp_id_str = ""
    private var genderSelect = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func tapOnMaleFemale(_ sender: UIButton) {
        if sender.tag == 0 { // Male
            self.femaleButton.isSelected = false
            self.maleButton.isSelected = true
            self.genderSelect = "male"
        } else { //Female
            self.femaleButton.isSelected = true
            self.maleButton.isSelected = false
            self.genderSelect = "female"
        }
    }
    
    @objc private func keyboardWillShowNotification (notification: Notification) {
        if self.view.frame.origin.y == 0.0 {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.view.frame.origin.y -= 75.0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc private func keyboardWillHideNotification (notification: Notification) {
        if self.view.frame.origin.y != 0.0 {
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
                self.view.frame.origin.y = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @IBAction func tapOnSignUp(_ sender: UIButton) {
        if self.nameText.text!.isEmpty {
            Toast.makeToast("Please enter your name")
            return
        }
        if self.mobileNoText.text!.isEmpty {
            Toast.makeToast("Please enter your Mobile Number")
            return
        }
        if self.passwordText.text!.isEmpty {
            Toast.makeToast("Please enter your Password")
            return
        }
        if self.genderSelect.isEmpty {
            Toast.makeToast("Please select Gender first ?")
            return
        }
        APIClient.shared.post(parameters: LoginRequest(mobile: self.mobileNoText.text!, password: self.passwordText.text!, type: "register"), feed: .send_otp, responseKey: "all") { [self] reult in
            switch reult {
            case .success(let aPIResponse):
                if aPIResponse?.code == 200 {
                    if let otpId = aPIResponse?.data?["otp_id"].int {
                        self.otp_id_str = "\(otpId)"
                    } else if let otpIds = aPIResponse?.data?["otp_id"].string {
                        self.otp_id_str = otpIds
                    }
                    if !self.otp_id_str.isEmpty {
                        self.oTPMainView.isHidden = false
                        self.editMobileNoText.isHidden = true
                    } else if let message = aPIResponse?.message, !message.isEmpty {
                        Toast.makeToast(message)
                    }
                } else if let message = aPIResponse?.message, !message.isEmpty {
                    Toast.makeToast(message)
                }
            case .failure(let error):
                Toast.makeToast(error.customDescription)
            }
        }
    }
    
    @IBAction func tapOnLogin(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapOnOTPClose(_ sender: UIButton) {
        self.oTPMainView.isHidden = true
    }
    
    @IBAction func tapOnEditPhoneNo(_ sender: UIButton) {
        if self.editMobileNoText.isHidden {
            self.editMobileNoText.isHidden = false
        }
    }
    
    @IBAction func tapOnOTPSubmit(_ sender: UIButton) {
        if self.oTPText.text!.isEmpty {
            Toast.makeToast("Please enter your OTP")
            return
        }
        if !self.editMobileNoText.isHidden && self.mobileNoText.text!.isEmpty {
            Toast.makeToast("Please enter your Mobile Number")
            return
        }
        
        APIClient.shared.post(parameters: RegisterRequest(otp: self.oTPText.text!, otp_id: self.otp_id_str, mobile: self.editMobileNoText.isHidden ? self.mobileNoText.text! : self.editMobileNoText.text!, name: self.nameText.text!, password: self.passwordText.text!, gender: self.genderSelect, referral_code: self.refferalCodeText.text ?? ""), feed: .register, responseKey: "all") { reult in
            switch reult {
            case .success(let aPIResponse):
                var token = ""
                if let tkn = aPIResponse?.data?["token"].string, !tkn.isEmpty {
                    token = tkn
                }
                if aPIResponse?.code == 201 {
                    
                    if let users = aPIResponse?.data?["user"].array, users.count > 0 {
                        let loginData = LoginData(users[0])
                        UserDefaults.standard.set(loginData.id, forKey: Constants.UserDefault.userId)
                        UserDefaults.standard.set(loginData.name, forKey: Constants.UserDefault.userName)
                        UserDefaults.standard.set(loginData.mobile, forKey: Constants.UserDefault.mobileNumber)
                        UserDefaults.standard.set(token.isEmpty ? loginData.token : token, forKey: Constants.UserDefault.loginToken)
                        UserDefaults.standard.set(true, forKey: Constants.UserDefault.isLogin)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            self.getGamesOnOff()
                        }
                    } else if (aPIResponse?.message) != nil {
                        Toast.makeToast("Wrong mobile number or password")
                    }
                } else if aPIResponse?.code == 200 {
                    if let userId = aPIResponse?.data?["user_id"].int {
                        UserDefaults.standard.set("\(userId)", forKey: Constants.UserDefault.userId)
                    } else if let userIdd =  aPIResponse?.data?["user_id"].string {
                        UserDefaults.standard.set(userIdd, forKey: Constants.UserDefault.userId)
                    }
                    UserDefaults.standard.set(self.nameText.text!, forKey: Constants.UserDefault.userName)
                    UserDefaults.standard.set(self.editMobileNoText.isHidden ? self.mobileNoText.text! : self.editMobileNoText.text!, forKey: Constants.UserDefault.mobileNumber)
                    UserDefaults.standard.set(token, forKey: Constants.UserDefault.loginToken)
                    UserDefaults.standard.set(true, forKey: Constants.UserDefault.isLogin)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.getGamesOnOff()
                    }
                } else if let message = aPIResponse?.message, !message.isEmpty {
                    Toast.makeToast(message)
                }
            case .failure(let error):
                Toast.makeToast(error.customDescription)
            }
        }
    }
    
    func getGamesOnOff() {
        APIClient.shared.post(parameters: EmptyRequest(), feed: .game_on_off, responseKey: "game_setting") { result in
            switch result {
            case .success(let aPIResponse):
                if let response = aPIResponse, let gamesData = response.data {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RegisterViewController: UITextFieldDelegate {
    // Use this if you have a UITextField
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 16 characters
        return textField == self.mobileNoText || textField == self.editMobileNoText ? updatedText.count <= 10 : true
    }
}
