//
//  ActiveTablesViewController.swift
//  Lets Card
//
//  Created by Durgesh on 28/12/22.
//

import UIKit

class ActiveTablesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var header1Label: UILabel!
    @IBOutlet weak var header2Label: UILabel!
    @IBOutlet weak var header3Label: UILabel!
    @IBOutlet weak var header4Label: UILabel!
    @IBOutlet weak var header5Label: UILabel!

    private var activeTables = [ActiveTableModel]()
    
    var gameType: GameTypes = .teen_patti
    var rummyPlayers = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if gameType == .point_rummy {
            titleLabel.text = "Rummy \(rummyPlayers) Player"
            header1Label.text = "Point Value"
            header2Label.text = "Min Entry"
            header3Label.text = "Max Players"
        }
        getActiveTables()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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

// MARK: Actions
extension ActiveTablesViewController {
    @IBAction func tapOnCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @objc private func tapOnPlaynow(_ sender: UIButton) {
        if gameType == .teen_patti {
            if let myobject = UIStoryboard(name: Constants.Storyboard.game, bundle: nil).instantiateViewController(withIdentifier: TeenPattiViewController().className) as? TeenPattiViewController {
    //            myobject.table_id = "\(self.activeTables[sender.tag].id)"
                myobject.boot_value = self.activeTables[sender.tag].boot_value.cleanValue2
                self.navigationController?.pushViewController(myobject, animated: true)
    //            self.navigationController?.viewControllers.removeLast()
            }
        } else if gameType == .point_rummy {
            if let myobject = UIStoryboard(name: Constants.Storyboard.game, bundle: nil).instantiateViewController(withIdentifier: RummyPointViewController().className) as? RummyPointViewController {
                myobject.isPlayer2 = self.rummyPlayers == 2
                myobject.boot_value = self.activeTables[sender.tag].boot_value.cleanValue2
                myobject.min_entry = Int(self.activeTables[sender.tag].chaal_limit)
                self.navigationController?.pushViewController(myobject, animated: true)
            }
        }
    }
}

// MARK: APIs
extension ActiveTablesViewController {
    func getActiveTables() {
        APIClient.shared.post(parameters: GameRequest(), feed: self.gameType == .teen_patti ? .Game_get_table_master : .rummy_get_table_master, responseKey: "table_data") { [self] result in
            switch result {
            case .success(let aPIResponse):
                self.activeTables = [ActiveTableModel]()
                if let response = aPIResponse, let tabledata = response.data_array, tabledata.count > 0 {
                    if response.code == 200 {
                        tabledata.forEach { object in
                            var actObj = ActiveTableModel(object)
                            if gameType == .point_rummy {
                                actObj.pot_limit = Double(rummyPlayers)
                            }
                            self.activeTables.append(actObj)
                        }
                    } else if response.code == 205 || response.message == "You are Already On Table" {
                        var tableArr = [GameTablePlayer]()
                        tabledata.forEach { object in
                            tableArr.append(GameTablePlayer(object))
                        }
                        if self.gameType == .teen_patti {
                            if let myobject = UIStoryboard(name: Constants.Storyboard.game, bundle: nil).instantiateViewController(withIdentifier: TeenPattiViewController().className) as? TeenPattiViewController {
                                myobject.table_id = tableArr.first?.table_id ?? -1
                                self.navigationController?.pushViewController(myobject, animated: true)
    //                            self.dismiss(animated: true)
                            }
                        } else if self.gameType == .point_rummy {
                            if let myobject = UIStoryboard(name: Constants.Storyboard.game, bundle: nil).instantiateViewController(withIdentifier: RummyPointViewController().className) as? RummyPointViewController {
                                myobject.isPlayer2 = self.rummyPlayers == 2
                                myobject.table_id = tableArr.first?.table_id ?? -1
                                self.navigationController?.pushViewController(myobject, animated: true)
                            }
                        }
                    }
                }
                self.tableView.reloadData()
                break
            case .failure(let error):
                Toast.makeToast(error.customDescription)
                break
            }
        }
    }
}

// MARK: UITableViewDataSource
extension ActiveTablesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeTables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: ActiveTableTableViewCell.dataCell, for: indexPath) as? ActiveTableTableViewCell {
            cell.configure(activeTables[indexPath.row], row: indexPath.row, target: self, selector: #selector(tapOnPlaynow(_:)), gameType: gameType)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: UITableViewDelegate
extension ActiveTablesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
