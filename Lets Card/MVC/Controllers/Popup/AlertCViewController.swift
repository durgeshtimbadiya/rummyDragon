//
//  AlertCViewController.swift
//  Lets Card
//
//  Created by Durgesh on 13/02/23.
//

import UIKit

// MARK: - Protocol used for sending data back -
protocol PromptViewDelegate: AnyObject {
    func didActionOnPromptButton(_ tag: Int)
}

class AlertCViewController: UIViewController {
    
    @IBOutlet weak var alertDialogueView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    var senderTag = -1
    
    // Making this a weak variable, so that it won't create a strong reference cycle
    weak var delegate: PromptViewDelegate? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapOnButton(_ sender: UIButton) {
        self.dismiss(animated: true)
        if sender.tag != 0, let del = delegate {
            del.didActionOnPromptButton(sender.tag == 1 ? senderTag : sender.tag)
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
