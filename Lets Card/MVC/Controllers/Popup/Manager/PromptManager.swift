//
//  PromptManager.swift
//  Lets Card
//
//  Created by Durgesh on 13/02/23.
//

import UIKit

class PromptVManager: NSObject {
    
    /*
     *  Dynamic Prompt screen
     *  Set prompt properties as per requirement
     */
    static func present(_ controller: UIViewController, titleString: String = "", messageString: String = "", viewTag: Int = -1) {
        if let myobject = UIStoryboard(name: Constants.Storyboard.popup, bundle: nil).instantiateViewController(withIdentifier: AlertCViewController().className) as? AlertCViewController {
            myobject.delegate = controller as? PromptViewDelegate
            myobject.senderTag = viewTag
            controller.navigationController?.present(myobject, animated: true, completion: {
                myobject.titleLabel.text = titleString
                myobject.descriptionLabel.text = messageString
                myobject.alertDialogueView.isHidden = false
            })
        }
    }
}
