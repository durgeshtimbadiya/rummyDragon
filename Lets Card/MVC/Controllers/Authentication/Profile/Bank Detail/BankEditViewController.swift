//
//  BankEditViewController.swift
//  Lets Card
//
//  Created by Durgesh on 26/12/22.
//

import UIKit
import AVFoundation

class BankEditViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tblBottomConstraint: NSLayoutConstraint!
    
    private var profileDataList = [ProfileCellData]()
    private var passbookImageBase64 = ""
    private var imagePicker = UIImagePickerController()
    private var passportImage = Constants.appLogoImage
    
    weak var delegate: AvatarViewDelegate? = nil
    var userBankData = UserBankDetailModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboard()
        self.imagePicker.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        setBankDetailData()
    }
    
    // MARK: Keyboard will show
    @objc private func keyboardWillShowNotification (notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue  {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.tblBottomConstraint.constant = keyboardHeight
        }
    }
    
    // MARK: Keyboard will Hide
    @objc private func keyboardWillHideNotification (notification: Notification) {
        self.tblBottomConstraint.constant = 10.0
    }
    
    private func setBankDetailData() {
        self.profileDataList.append(ProfileCellData(title: "Bank Name:", placeHolder: "Enter Bank Name", value: self.userBankData.bank_name, title2: "IFSC CODE:", placeHolder2: "Enter IFSC CODE", value2: self.userBankData.ifsc_code))
        self.profileDataList.append(ProfileCellData(title: "Account Holder Name:", placeHolder: "Enter Account Holder Name", value: self.userBankData.acc_holder_name, title2: "Account Number:", placeHolder2: "Enter Account Number:", value2: self.userBankData.acc_no))
        
        DispatchQueue.global().async {
            if !self.userBankData.passbook_img.isEmpty, let imgURL = URL(string: "\(Constants.baseURL)\(APIClient.imagePath)\(self.userBankData.passbook_img)") {
                do {
                    let imageData = try Data(contentsOf: imgURL as URL)
                    self.passportImage = UIImage(data: imageData)
                    self.passbookImageBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                } catch { }
            }
            self.profileDataList.append(ProfileCellData(title: "Passbook Image:", image: self.passportImage))
            self.profileDataList.append(ProfileCellData())
            DispatchQueue.main.async {
                self.tableView.reloadData()
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

// MARK: API Calls
extension BankEditViewController {
    private func updateBankDetails() {
        let params = UpdateBankRequest(bank_name: self.profileDataList.count > 0 ? self.profileDataList[0].value : "", ifsc_code: self.profileDataList.count > 0 ? self.profileDataList[0].value2 : "", acc_holder_name: self.profileDataList.count > 1 ? self.profileDataList[1].value : "", acc_no: self.profileDataList.count > 1 ? self.profileDataList[1].value2 : "", passbook_img: passbookImageBase64)
        
        APIClient.shared.post(parameters: params, feed: .update_bank_details, responseKey: "") { result in
            switch result {
            case .success(let aPIResponse):
                if let response = aPIResponse, response.code == 200 {
                    let alertView = UIAlertController(title: "Bank Details", message: "Updated!", preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        self.dismiss(animated: true) {
                            if let del = self.delegate {
                                del.changeBankDetail?()
                            }
                            self.dismiss(animated: true)
                        }
                    }))
                    self.present(alertView, animated: true)
                }
                break
            case .failure(let error):
                Toast.makeToast(error.customDescription)
                break
            }
        }
    }
}

// MARK: Actions
extension BankEditViewController {
    @objc func tapOnSubmit(_ sender: UIButton) {
        if profileDataList[0].value.isEmpty {
            Toast.makeToast("Please enter your \(profileDataList[0].title.replacingOccurrences(of: ":", with: ""))")
            return
        }
        if profileDataList[0].value2.isEmpty {
            Toast.makeToast("Please enter valid \(profileDataList[0].title2.replacingOccurrences(of: ":", with: ""))")
            return
        }
        if profileDataList[1].value.isEmpty {
            Toast.makeToast("Please enter your \(profileDataList[0].title.replacingOccurrences(of: ":", with: ""))")
            return
        }
        if profileDataList[1].value2.isEmpty {
            Toast.makeToast("Please enter your \(profileDataList[0].title2.replacingOccurrences(of: ":", with: ""))")
            return
        }
        self.updateBankDetails()
    }
    
    @objc func tapOnChooseImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Photo!", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photot", style: .default, handler: { result in
            if !UIImagePickerController.isSourceTypeAvailable(.camera) {
                Toast.makeToast("Camera not supported")
                return
            }
            
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                DispatchQueue.main.async {
                    self.imagePicker.sourceType = .camera
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        DispatchQueue.main.async {
                            self.imagePicker.sourceType = .camera
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: { result in
            if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                Toast.makeToast("Photo library not supported")
                return
            }
            
            if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
                DispatchQueue.main.async {
                    self.imagePicker.sourceType = .photoLibrary
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            } else {
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                    if granted {
                        DispatchQueue.main.async {
                            self.imagePicker.sourceType = .photoLibrary
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                    }
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}

// MARK: UITableViewDataSource
extension BankEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.row == profileDataList.count - 1 ? ProfileEditTableViewCell.submitCell : indexPath.row == profileDataList.count - 2 ? ProfileEditTableViewCell.imageCell : ProfileEditTableViewCell.textCell, for: indexPath) as? ProfileEditTableViewCell {
            cell.configureBank(profileDataList[indexPath.row], row: indexPath.row, target: self, selectors: [#selector(tapOnChooseImage(_ :)), #selector(tapOnSubmit(_ :))], isLastRow: indexPath.row == profileDataList.count - 1, isLastSecondRow: indexPath.row == profileDataList.count - 3)
            if cell.textFieldT != nil {
                cell.textFieldT.delegate = self
            }
            if cell.textFieldT2 != nil {
                cell.textFieldT2.delegate = self
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: UITableViewDelegate
extension BankEditViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: UITextFieldDelegate
extension BankEditViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [self] in
            let indexPath = IndexPath(row: textField.tag, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if  textField.returnKeyType == .next {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [self] in
            var nextIndex = 0
            if let extraTag = textField.layer.value(forKey: "extraTag") as? Int {
                if extraTag - 19 == textField.tag {
                    nextIndex = 1
                }
            }
                let indexPath = IndexPath(row: textField.tag + nextIndex, section: 0)
                if let cell = self.tableView.cellForRow(at: indexPath) as? ProfileEditTableViewCell {
                    if nextIndex == 0, cell.textFieldT2 != nil {
                        cell.textFieldT2.becomeFirstResponder()
                    } else if cell.textFieldT != nil {
                        cell.textFieldT.becomeFirstResponder()
                    }
                }
//            }
        } else {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        var nextIndex = 0
        if let extraTag = textField.layer.value(forKey: "extraTag") as? Int {
            if extraTag - 19 == textField.tag {
                nextIndex = 1
            }
        }
        if nextIndex == 0 {
            self.profileDataList[textField.tag].value = textField.text ?? ""
        } else {
            self.profileDataList[textField.tag].value2 = textField.text ?? ""
        }
        self.tableView.reloadRows(at: [IndexPath(item: textField.tag, section: 0)], with: .none)

    }
}

// MARK: - UIImagePickerControllerDelegate -
extension BankEditViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePicker.dismiss(animated: true) {
            if let imageOrig = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                guard let imageData = imageOrig.jpegData(compressionQuality: 0.75) else { return }
                self.passbookImageBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                self.profileDataList[self.profileDataList.count - 2].image = imageOrig
                self.tableView.reloadData()
            }
        }
    }
}
