//
//  AvatarViewController.swift
//  Lets Card
//
//  Created by Durgesh on 21/12/22.
//

import UIKit

@objc protocol AvatarViewDelegate: AnyObject {
    func changeAvatar(_ selectedIndex: Int)
    @objc optional func changeBankDetail()
}

class AvatarViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    // Making this a weak variable, so that it won't create a strong reference cycle
    weak var delegate: AvatarViewDelegate? = nil
    
    var arrayList = [String]()
    var profileData = ProfileData()
    private var selectedAvatar = ""
    private var selectedIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapOnCloseBtn(_ sender: UIButton) {
        
    }
    
    @IBAction func tapOnConfirmButton(_ sender: UIButton) {
        if selectedAvatar.isEmpty {
            Toast.makeToast("Please select avatar")
            return
        }
        self.updateProfile()
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
extension AvatarViewController {
    private func updateProfile() {
        let params = UpdateAvatarRequest(name: profileData.name, bank_detail: profileData.bank_detail, upi: profileData.upi, adhar_card: profileData.adhar_card, avatar: selectedAvatar)
        APIClient.shared.post(parameters: params, feed: .update_profile, responseKey: "") { result in
            switch result {
            case .success(let aPIResponse):
                if let response = aPIResponse, response.code == 200 {
                    if let deleg = self.delegate {
                        deleg.changeAvatar(self.selectedIndex)
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
}

// MARK: UICollectionViewDataSource
extension AvatarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        if let imageV = cell.contentView.viewWithTag(2) as? UIImageView {
            imageV.sd_setImage(with: URL(string: "\(Constants.baseURL)\(APIClient.imagePath)\(arrayList[indexPath.row])"), placeholderImage: Constants.profileDefaultImage, context: nil)
        }
        cell.contentView.backgroundColor = indexPath.row == selectedIndex ? UIColor(hexString: "3A7792") : .clear
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension AvatarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.selectedAvatar = arrayList[indexPath.row]
        self.collectionView.reloadData()
    }
}
