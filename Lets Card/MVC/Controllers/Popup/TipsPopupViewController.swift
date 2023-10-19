//
//  TipsPopupViewController.swift
//  Lets Card
//
//  Created by Durgesh on 28/07/23.
//

import UIKit

// MARK: - Protocol used for sending data back -
protocol TipsPopupDelegate: AnyObject {
    func setDealerImage(_ imageName: String)
}

class TipsPopupViewController: UIViewController {
    
    @IBOutlet weak var tipsView: UIView!
    @IBOutlet weak var dealerImage: UIImageView!
    @IBOutlet weak var dealersView: UIView!
    @IBOutlet weak var dealerCollectionView: UICollectionView!
    @IBOutlet weak var tipsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel! //"Dealer Changed Just Now"
    
    weak var delegate: TipsPopupDelegate? = nil

    private var totalTip = 100
    private var selectedIndex = -1
    private let dealersImages = ["poker11", "poker1", "poker2", "poker3", "poker4", "poker5", "poker6", "poker7", "poker8", "poker9", "poker10", "poker11", "poker12"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dealersView.isHidden = true
        self.tipsLabel.text = "\(totalTip)"
        self.dealerCollectionView.reloadData()
    }
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        if sender.tag == 0 {
            self.dismiss(animated: true) {
                if self.selectedIndex >= 0, let del = self.delegate {
                    del.setDealerImage(self.dealersImages[self.selectedIndex])
                }
            }
        } else {
            self.dealersView.isHidden = true
        }
    }
    
    @IBAction func tapOnChangeDealer(_ sender: UIButton) {
        self.dealersView.isHidden = false
    }
    
    @IBAction func tapOnTip(_ sender: UIButton) {
        sendTips()
    }
    
    @IBAction func tapOnAddMinusTip(_ sender: UIButton) {
        if sender.tag == 0 { // Add
            totalTip += 100
        } else { // Minus
            if totalTip > 100 {
                totalTip -= 100
            }
        }
        self.tipsLabel.text = "\(totalTip)"
    }
}

// MARK: API Calls
extension TipsPopupViewController {
    private func sendTips() {
        APIClient.shared.post(parameters: GameTipsRequest(tip: "\(self.totalTip)"), feed: .Game_tip, responseKey: "all") { result in
            switch result {
            case .success(let apiResponse):
                if let response = apiResponse, response.code == 200 {
                    let alertView = UIAlertController(title: "", message: "Thanks you for tip!", preferredStyle: .alert)
                    alertView.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
                        self.dismiss(animated: true) {
                            if self.selectedIndex >= 0, let del = self.delegate {
                                del.setDealerImage(self.dealersImages[self.selectedIndex])
                            }
                            self.dismiss(animated: true)
                        }
                    }))
                    self.present(alertView, animated: true)
                } else if let message = apiResponse?.message {
                    Toast.makeToast(message)
                }
                break
            case .failure(_):
//                    Toast.makeToast(error.localizedDescription)
                break
            }
        }
    }
}

// MARK: UICollectionViewDataSource
extension TipsPopupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dealersImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GiftCollectionViewCell.identifier, for: indexPath) as? GiftCollectionViewCell {
            cell.configureDealer(dealersImages[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: UICollectionViewDelegate
extension TipsPopupViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.timeLabel.text = "Dealer Changed Just Now"
        self.dealerImage.image = UIImage(named: dealersImages[indexPath.row])
        self.dealersView.isHidden = true
    }
}
