//
//  SpinViewController.swift
//  Lets Card
//
//  Created by Durgesh on 26/06/23.
//

import UIKit

class SpinViewController: UIViewController {
    
    @IBOutlet weak var spinWheelImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    private var wheelResultDegree = [12.57, 12.22, 11.87, 11.52, 11.17, 17.12, 16.77, 16.42, 16.07, 15.72, 15.32, 14.97, 14.62, 14.27, 13.93, 13.57, 13.23, 12.84]


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.spinWheelImage.rotateWithAnimation(angle: 15.32)
        
        let delayTime1 = 4
        var count1 = 0
        _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(delayTime1), repeats: true){ [self] t1 in
            self.spinWheelImage.rotateWithAnimation(angle: self.wheelResultDegree[count1])
            delay(2.0) {
                self.spinWheelImage.transform = CGAffineTransform.identity
                count1 += 1
            }
            if self.wheelResultDegree.count > count1 {
                t1.invalidate()
            }
        }
    }
    
    private func delay(_ delay: Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
    }
    
    // 01 - 12.57
    // 02 - 12.22
    // 05 - 11.87
    // 10 - 11.52
    // 15 - 11.17
    // 30 - 17.12
    // 45 - 16.77
    // 50 - 16.42
    // 65 - 16.07
    // 70 - 15.72
    // 78 - 15.47
    // 83 - 15.02
    // 90 - 14.67
    // 100 - 14.32
    // 110 - 13.97
    // 121 - 13.62
    // 130 - 13.27
    // 150 - 12.92
    
    @IBAction func tapOnClose(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func tapOnSpin(_ sender: UIButton) {
        
    }
}
