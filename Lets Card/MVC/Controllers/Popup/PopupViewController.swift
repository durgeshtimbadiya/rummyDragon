//
//  PopupViewController.swift
//  Lets Card
//
//  Created by Durgesh on 28/12/22.
//

import UIKit

class PopupViewController: UIViewController {
    
    @IBOutlet weak var rummyPointView: UIView!
    @IBOutlet weak var twoPlayerView: UIStackView!
    @IBOutlet weak var fivePlayerView: UIStackView! // 60,2,189
    @IBOutlet weak var twoPlayerLabel: UILabel!
    @IBOutlet weak var fivePlayerLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var privateTableView: UIView!
    @IBOutlet weak var totalChipsLbl: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bootAmountLbl: UILabel!
    @IBOutlet weak var potLimitLbl: UILabel!
    @IBOutlet weak var totalBlindLbl: UILabel!
    @IBOutlet weak var maxBetValueLbl: UILabel!
    @IBOutlet weak var minAmountLbl: UILabel!
    @IBOutlet weak var maxAmountLbl: UILabel!
    @IBOutlet weak var sliderView: UISlider!
    
    private var selectedPlayers = 5
    private var gameChatList = [ChatModel]()
    var isChatPopup = false
    var gameType = GameTypes.none
    var game_id = String()
    var myProfilePicURL = String()
    var profileData = ProfileData()
    private var progressValue = 50
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var chatPopupView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private let myUserId = UserDefaults.standard.integer(forKey: Constants.UserDefault.userId)
    private let textPlaceholder = "Write a message......."
    private var chatTimer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        rummyPointView.isHidden = isChatPopup || gameType == GameTypes.private_table || gameType == GameTypes.custom_boot
        chatPopupView.isHidden = !isChatPopup
        privateTableView.isHidden = !(gameType == GameTypes.private_table || gameType == GameTypes.custom_boot)
        
        if isChatPopup {
            self.messageTextView.text = textPlaceholder
            self.messageTextView.textColor = .darkGray
            self.messageTextView.backgroundColor = .white
//            self.messageTextView.addInputAccessoryView("Done", target: self, selector: #selector(tapOnDoneTool(_:)))
            
            self.hideKeyboard()
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
            
            if chatTimer.isValid {
                chatTimer.invalidate()
            }
            chatTimer = Timer(timeInterval: 10, target: self, selector: #selector(self.updateChatStartTimer), userInfo: nil, repeats: true)
            RunLoop.main.add(self.chatTimer, forMode: .default)
            chatTimer.fire()
        } else if gameType == GameTypes.private_table || gameType == GameTypes.custom_boot {
            self.totalChipsLbl.text = self.profileData.wallet.cleanValue2
            self.sliderView.value = 1
            setAmountValues()
            if gameType == .private_table {
                titleLabel.text = "Private Table"
            } else {
                titleLabel.text = "Custom Boot"
            }
        }
    
        self.fivePlayerView.backgroundColor = UIColor(displayP3Red: 60.0 / 255.0, green: 2.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0)
        self.twoPlayerView.backgroundColor = .white
        self.fivePlayerLabel.textColor = .white
        self.twoPlayerLabel.textColor = .black
    }
    
    private func setAmountValues() {
        self.bootAmountLbl.text = "Boot amount : \(progressValue.formatPoints())"
        self.potLimitLbl.text = "Pot limit : \((progressValue * 1024).formatPoints())"
        self.maxBetValueLbl.text = "Maximumbet balue : \((progressValue * 128).formatPoints())"
        self.totalBlindLbl.text = "Number of Blinds : 4"
    }
    
    @objc private func updateChatStartTimer() {
        chatListAndSendMessage("")
    }
    
    @objc private func keyboardWillShowNotification (notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue  {
            let keyboardRectangle = keyboardFrame.cgRectValue
            if let window = UIApplication.shared.keyWindow {
                bottomConstraint.constant = keyboardRectangle.height - window.safeAreaInsets.bottom
            } else {
                bottomConstraint.constant = keyboardRectangle.height
            }
        }
    }
    
    @objc private func keyboardWillHideNotification (notification: Notification) {
        bottomConstraint.constant = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.chatTimer.invalidate()
        self.chatTimer.invalidate()
    }
    
    @objc private func tapOnDoneTool(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
    }
    
    @IBAction func tapOnSendMessage(_ sender: UIButton) {
        var message = self.messageTextView.text ?? ""
        if message == textPlaceholder {
            message = ""
        }
        chatListAndSendMessage(message)
        DispatchQueue.main.async {
            self.messageTextView.text = self.textPlaceholder
            self.messageTextView.textColor = .darkGray
        }
    }
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func tapOnCreatePrivate(_ sender: UIButton) {
        
        weak var pvc = self.presentingViewController
        self.dismiss(animated: true) {
            if let myobject = UIStoryboard(name: Constants.Storyboard.game, bundle: nil).instantiateViewController(withIdentifier: TeenPattiViewController().className) as? TeenPattiViewController {
                myobject.boot_value = "\(self.progressValue)"
                myobject.isPrivateTable = self.gameType == GameTypes.private_table
                myobject.isCustomBoot = self.gameType == GameTypes.custom_boot
//                myobject.rummyPlayers = self.selectedPlayers
                pvc?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
        }
    }
    
    @IBAction func changeAmountSlider(_ sender: UISlider) {
        switch Int(sender.value) {
        case 2:
            progressValue = 100
            break
        case 3:
            progressValue = 500
            break
        case 4:
            progressValue = 1000
            break
        case 5:
            progressValue = 5000
            break
        case 6:
            progressValue = 10000
            break
        case 7:
            progressValue = 25000
            break
        case 8:
            progressValue = 50000
            break
        case 9:
            progressValue = 100000
            break
        case 10:
            progressValue = 250000
        default:
            self.sliderView.value = 1
            progressValue = 50
            break
        }
        self.setAmountValues()
    }
    
    @IBAction func tapOnPlayer(_ sender: UIButton) {
        selectedPlayers = sender.tag
        self.fivePlayerView.backgroundColor = sender.tag == 5 ? UIColor(displayP3Red: 60.0 / 255.0, green: 2.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0) : .white
        self.twoPlayerView.backgroundColor = sender.tag == 2 ? UIColor(displayP3Red: 60.0 / 255.0, green: 2.0 / 255.0, blue: 189.0 / 255.0, alpha: 1.0) : .white
        self.fivePlayerLabel.textColor = sender.tag == 5 ? .white : .black
        self.twoPlayerLabel.textColor = sender.tag == 2 ? .white : .black
    }
    
    @IBAction func tapOnPlayNow(_ sender: UIButton) {
        weak var pvc = self.presentingViewController
        self.dismiss(animated: true) {
            if let myobject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: ActiveTablesViewController().className) as? ActiveTablesViewController {
                myobject.gameType = .point_rummy
                myobject.rummyPlayers = self.selectedPlayers
                pvc?.present(UINavigationController(rootViewController: myobject), animated: true)
            }
        }
    }
    
    func chatListAndSendMessage(_ message: String) {
        DispatchQueue.global(qos: .background).async {
            APIClient.shared.post(parameters: GameChatRequest(game_id: self.game_id, chat: message), feed: .Game_chat, responseKey: "list") { result in
                switch result {
                case .success(let aPIResponse):
                    DispatchQueue.global(qos: .background).async {
                        if let response = aPIResponse, response.code == 200, let tabledata = response.data_array, tabledata.count > 0 {
                            tabledata.reversed().forEach { object in
                                self.gameChatList.append(ChatModel(object))
                            }
                            self.reloadChatTableView()
                        } else if let message = aPIResponse?.message, !message.isEmpty {
                            Toast.makeToast(message)
                        }
                    }
                    break
                case .failure(let error):
                    Toast.makeToast(error.customDescription)
                    break
                }
            }
        }
    }

    func reloadChatTableView(){
        DispatchQueue.main.async {
            self.chatTableView.reloadData()
            let indexPath = IndexPath(row: self.gameChatList.count-1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
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

extension PopupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameChatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: gameChatList[indexPath.row].user_id != myUserId ? ChatDataTableViewCell.rightIdentifier : ChatDataTableViewCell.leftIdentifier, for: indexPath) as? ChatDataTableViewCell {
            cell.configure(gameChatList[indexPath.row], myProfileImg: myProfilePicURL)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITextViewDelegate -
extension PopupViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .darkGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)

        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {

            textView.text = textPlaceholder
            textView.textColor = .darkGray

            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }

        // Else if the text view's placeholder is showing and the
        // length of the replacement string is greater than 0, set
        // the text color to white then set its text to the
        // replacement string
         else if textView.textColor == .darkGray && !text.isEmpty {
            textView.textColor = .black
            textView.text = text
        }

        // For every other case, the text should change with the usual
        // behavior...
        else {
            return true
        }

        // ...otherwise return false since the updates have already
        // been made
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == .darkGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = textPlaceholder
            textView.textColor = .darkGray
        }
    }
}
