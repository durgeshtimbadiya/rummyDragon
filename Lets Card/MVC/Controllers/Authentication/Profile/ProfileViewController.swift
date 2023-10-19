//
//  ProfileViewController.swift
//  Lets Card
//
//  Created by Durgesh on 21/12/22.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImage: UIImageView!
    
    weak var delegate: AvatarViewDelegate? = nil
    
    var userProfileData = ProfileData()
    var userBankData = UserBankDetailModel()
    var avatars = [String]()
    
    private var profileDataList = [ProfileCellData]()
    private var profilePicStr = ""
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setProfileData()
        self.hideKeyboard()
        self.imagePicker.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
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
    
    private func setProfileData() {
        self.profileImage.sd_setImage(with: URL(string: userProfileData.profile_pic), placeholderImage: Constants.profileDefaultImage, context: nil)
        self.profileDataList.append(ProfileCellData(title: "User Name:", placeHolder: "Enter Name", value: userProfileData.name))
        self.profileDataList.append(ProfileCellData(title: "UPI Details", placeHolder: "Enter UPI Details", value: userProfileData.bank_detail))
        self.profileDataList.append(ProfileCellData(title: "Aadhar card no.", placeHolder: "Enter Aadhar card no.", value: userProfileData.adhar_card))
        self.profileDataList.append(ProfileCellData(title: "UPI", placeHolder: "Enter UPI", value: userProfileData.upi))
        self.profileDataList.append(ProfileCellData(title: "Phone Details:", placeHolder: "Enter Phone Details", value: userProfileData.mobile))
        self.profileDataList.append(ProfileCellData())
        self.tableView.reloadData()
    }
}

// MARK: Avatar change Delegate
extension ProfileViewController: AvatarViewDelegate {
    func changeAvatar(_ selectedIndex: Int) {
        self.profileImage.sd_setImage(with: URL(string: "\(Constants.baseURL)\(APIClient.imagePath)\(avatars[selectedIndex])"), placeholderImage: Constants.profileDefaultImage, context: nil)
        if let del = self.delegate {
            del.changeAvatar(selectedIndex)
        }
        self.dismiss(animated: true)
    }
    
    func changeBankDetail() {
        self.getUserProfile()
    }
}

// MARK: Actions
extension ProfileViewController {
    @IBAction func tapOnProfileImage(_ sender: UIButton) {
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
        
        alert.addAction(UIAlertAction(title: "Choose Avatar", style: .default, handler: { result in
            if let myobject = UIStoryboard(name: Constants.Storyboard.auth, bundle: nil).instantiateViewController(withIdentifier: AvatarViewController().className) as? AvatarViewController {
                myobject.delegate = self
                myobject.arrayList = self.avatars
                myobject.profileData = self.userProfileData
                self.present(myobject, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func tapOnSegmentButtons(_ sender: UIButton) {
        if sender.tag == 0 {
            if let myobject = UIStoryboard(name: Constants.Storyboard.auth, bundle: nil).instantiateViewController(withIdentifier: BankEditViewController().className) as? BankEditViewController {
                myobject.delegate = self
                myobject.userBankData = self.userBankData
                self.present(myobject, animated: true, completion: nil)
            }
        }
        // 0 - Bank details
        // 1 - KYC
        // 2 - Update Password
    }
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc func tapOnSubmit(_ sender: UIButton) {
        if profileDataList[0].value.isEmpty || profileDataList[profileDataList.count - 2].value.isEmpty {
            Toast.makeToast("Input field in empty!")
            return
        }
        self.updateProfile()
    }
}

// MARK: API Calls
extension ProfileViewController {
    private func updateProfile() {
        let params = ProfileUpdateRequest(name: profileDataList.count > 0 ? profileDataList[0].value : "", bank_detail: profileDataList.count > 1 ? profileDataList[1].value : "", upi: profileDataList.count > 3 ? profileDataList[3].value : "", adhar_card: profileDataList.count > 2 ? profileDataList[2].value : "", profile_pic: profilePicStr)
        APIClient.shared.post(parameters: params, feed: .update_profile, responseKey: "") { result in
            switch result {
            case .success(let aPIResponse):
                if let response = aPIResponse, response.code == 200 {
                    if let del = self.delegate {
                        del.changeAvatar(0)
                    }
                    self.dismiss(animated: true)
                }
                break
            case .failure(let error):
                Toast.makeToast(error.customDescription)
                break
            }
        }
    }
    
    private func getUserProfile() {
        APIClient.shared.post(parameters: ProfileRequest(), feed: .profile, responseKey: "user_bank_details") { result in
            switch result {
            case .success(let aPIResponse):
                if let response = aPIResponse, response.code == 200 {
                    if let userbnkD = response.data_array, userbnkD.count > 0 {
                        self.userBankData = UserBankDetailModel(userbnkD[0])
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

// MARK: UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.row == profileDataList.count - 1 ? ProfileEditTableViewCell.submitCell : ProfileEditTableViewCell.textCell, for: indexPath) as? ProfileEditTableViewCell {
            cell.configure(profileDataList[indexPath.row], row: indexPath.row, target: self, selector: #selector(tapOnSubmit(_ :)), isLastRow: indexPath.row == profileDataList.count - 2, isLastSecondRow: indexPath.row == profileDataList.count - 3)
            if cell.textFieldT != nil {
                cell.textFieldT.delegate = self
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: UITextFieldDelegate
extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [self] in
            let indexPath = IndexPath(row: textField.tag, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if  textField.returnKeyType == .next {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [self] in
                let indexPath = IndexPath(row: textField.tag + 1, section: 0)
                if let cell = self.tableView.cellForRow(at: indexPath) as? ProfileEditTableViewCell, cell.textFieldT != nil {
                    cell.textFieldT.becomeFirstResponder()
                }
//            }
        } else {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.profileDataList[textField.tag].value = textField.text ?? ""
        self.tableView.reloadRows(at: [IndexPath(item: textField.tag, section: 0)], with: .none)
    }
}

// MARK: - UIImagePickerControllerDelegate -
extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate  {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePicker.dismiss(animated: true) {
            if let imageOrig = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                guard let imageData = imageOrig.jpegData(compressionQuality: 0.75) else { return }
                self.profilePicStr = imageData.base64EncodedString(options: .lineLength64Characters)
                self.profileImage.image = imageOrig
                self.updateProfile()
            }
        }
    }
    
    /*private func imageOrientation(_ src:UIImage)->UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(Float.pi))
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Float.pi))
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-Float.pi))
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        default:
            break;
        }

        switch src.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        default:
            break
        }

        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!

        ctx.concatenate(transform)

        switch src.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }

        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)

        return img
    }*/
}
