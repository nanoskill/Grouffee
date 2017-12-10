//
//  BoardDetailViewController.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 08/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class BoardDetailViewController: UIViewController {
    
    @IBOutlet var boardName: UILabel!
    @IBOutlet var duration: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet var goalTable: UITableView!
    @IBOutlet weak var member: UILabel!
    
    @IBOutlet weak var timerContainer: UIView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBOutlet weak var detailNavBar: UINavigationItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var joinBoardBtn: UIButton!
    
    var board : Board!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateBoard()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateBoard), userInfo: nil, repeats: true)
    }
    
    @objc func updateBoard()
    {
        boardName.text = board.boardName
        desc.text = board.desc
        var temp = ""
        for m in board.getPeopleWorkingOnBoard() {
            temp.append("\(m.name), ")
        }
        member.text = temp
        duration.text = "\(Int(board.timer.initTime)/3600) \("hours") \(Int(board.timer.initTime)%3600 / 60) \("minutes")"
        goalTable.reloadData()
        timerLabel.text = board.timer.getTimeString()
        detailNavBar.title = appDelegate.room.timer.getTimeString()
    }
    
    @IBAction func backItemDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func joinBoardDidTap(_ sender: Any) {
        userView(isJoined: appDelegate.user.workingOnBoard?.boardId == board.boardId)
        //updateBoard()
    }
    
    func userView(isJoined: Bool)
    {
        if isJoined
        {
            //mau keluar
            joinBoardBtn.imageView?.image = #imageLiteral(resourceName: "Create New Room Button")
            backButton.isEnabled = true
            if appDelegate.user.type == .member
            {
                do
                {
                    let theData = try JSONEncoder().encode(ExitData(user: appDelegate.user.name))
                    try appDelegate.connection?.session.send(theData, toPeers: (appDelegate.connection?.session.connectedPeers)!, with: .reliable)
                }
                catch let error
                {
                    print("Sending exit data error :\(error)")
                }
            }
            appDelegate.user.exitBoard()
        }
        else
        {
            joinBoardBtn.imageView?.image = #imageLiteral(resourceName: "join room button")
            backButton.isEnabled = false
            if appDelegate.user.type == .member
            {
                do
                {
                    let theData = try JSONEncoder().encode(JoinData(targetBoard: board.boardId, user: appDelegate.user.name))
                    try appDelegate.connection?.session.send(theData, toPeers: (appDelegate.connection?.session.connectedPeers)!, with: .reliable)
                }
                catch let error
                {
                    print("Sending join data error :\(error)")
                }
            }
            appDelegate.user.joinBoard(board: board)
        }
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
