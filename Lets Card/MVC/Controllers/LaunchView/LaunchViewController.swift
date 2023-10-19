//
//  LaunchViewController.swift
//  Lets Card
//
//  Created by Durgesh on 15/12/22.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if UserDefaults.standard.bool(forKey: Constants.UserDefault.isLogin) {
            getGamesOnOff()
        } else {
            Core.push(self, storyboard: Constants.Storyboard.auth, storyboardId: LoginViewController().className)
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

extension LaunchViewController {
    func getGamesOnOff() {
        APIClient.shared.post(parameters: EmptyRequest(), feed: .game_on_off, showLoading: false, responseKey: "game_setting") { result in
            switch result {
            case .success(let aPIResponse):
                if let response = aPIResponse, let gamesData = response.data {
//                    print(response)
                    let gameOnOff = GameOnOffModel(gamesData)
                    GameOnOffModel.storeData(gameOnOff)
                }
                break
            case .failure(let error):
                Toast.makeToast(error.customDescription)
                break
            }
            Core.push(self, storyboard: Constants.Storyboard.main, storyboardId: DashboardViewController().className)
//            Core.push(self, storyboard: Constants.Storyboard.game, storyboardId: RummyPointViewController().className)
        }
    }
}
