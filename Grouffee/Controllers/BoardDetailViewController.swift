//
//  BoardDetailViewController.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 08/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class BoardDetailViewController: UIViewController {
    
    @IBOutlet weak var boardTimer: UIView!
    
    @IBOutlet var boardName: UILabel!
    @IBOutlet var duration: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet var goalTable: UITableView!
    @IBOutlet weak var member: UILabel!
    //var goals: [String] = []
    /*
    var boardNameInput: String?
    var durInput: Int?
    var descInput: String?
    */
    var board : Board!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        boardName.text = board.boardName
        duration.text = "\(Int(board.timer.initTime)/3600) \("hours") \(Int(board.timer.initTime)%3600 / 60) \("minutes")"
        desc.text = board.desc
    }
    
    @IBAction func backItemDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension BoardDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("hello")
        let selectedCell = goalTable.cellForRow(at: indexPath) as! GoalTableViewCell
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if (selectedCell.checkBox.image?.isEqual(UIImage(named: "blank-check-box")))! {
            selectedCell.checkBox.image = UIImage(named: "check-box")
            if appDelegate.user.type == .leader
            {
                board.goals[indexPath.row].checked(user: appDelegate.user)
                appDelegate.broadcastRoom()
            }
            else
            {
                do
                {
                    let theData = try JSONEncoder().encode(GoalCheckData(board: board))
                    try appDelegate.connection?.session.send(theData, toPeers: (appDelegate.connection?.session.connectedPeers)!, with: .reliable)
                }
                catch let error
                {
                    print("send checked error : \(error)")
                }
            }
        } else {
            selectedCell.checkBox.image = UIImage(named: "blank-check-box")
            if appDelegate.user.type == .leader
            {
                board.goals[indexPath.row].unchecked()
                appDelegate.broadcastRoom()
            }
            else
            {
                do
                {
                    let theData = try JSONEncoder().encode(GoalCheckData(board: board))
                    try appDelegate.connection?.session.send(theData, toPeers: (appDelegate.connection?.session.connectedPeers)!, with: .reliable)
                }
                catch let error
                {
                    print("send checked error : \(error)")
                }
            }
        }
    }
}

extension BoardDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return board.goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = goalTable.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as! GoalTableViewCell

        cell.goalLabel.text = board.goals[indexPath.row].name
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
