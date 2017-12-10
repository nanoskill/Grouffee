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
    
    var boardId : Int!
    var board : Board!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for board in appDelegate.room.boards {
            if board.boardId == self.boardId
            {
                self.board = board
                break;
            }
        }
        member.text = "members"
        goalTable.dataSource = self
        updateGoalTable()
        updateBoard()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateBoard), userInfo: nil, repeats: true)
    }
    
    func updateGoalTable()
    {
        if appDelegate.user.workingOnBoard?.boardId == board.boardId
        {
            joinBoardBtn.setImage(#imageLiteral(resourceName: "exit board 003"), for: .normal)
            backButton.isEnabled = false
        }
        else
        {
            joinBoardBtn.setImage(#imageLiteral(resourceName: "join room button"), for: .normal)
            backButton.isEnabled = true
        }
    }
    
    @objc func updateBoard()
    {
        for board in appDelegate.room.boards {
            if board.boardId == self.boardId
            {
                self.board = board
                break;
            }
        }
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
            updateGoalTable()
        }
        else
        {
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
            updateGoalTable()
        }
    }
    
}

extension BoardDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = goalTable.cellForRow(at: indexPath) as! GoalTableViewCell
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.user.workingOnBoard?.boardId != board.boardId { return }
        if board.goals[indexPath.row].isChecked() == false
        {
            selectedCell.checkBox.image = UIImage(named: "check-box")
            DispatchQueue.main.async {
                [weak self] in
                self!.board.goals[indexPath.row].checked(user: self!.appDelegate.user)
                if appDelegate.user.type == .leader
                {
                    self!.appDelegate.broadcastRoom()
                }
                else
                {
                    do
                    {
                        let theData = try JSONEncoder().encode(GoalCheckData(board: self!.board))
                        try self!.appDelegate.connection?.session.send(theData, toPeers: (self!.appDelegate.connection?.session.connectedPeers)!, with: .reliable)
                    }
                    catch let error
                    {
                        print("send checked error : \(error)")
                    }
                }
            }
        } else {
            selectedCell.checkBox.image = UIImage(named: "blank-check-box")
            DispatchQueue.main.async {
                [weak self] in
                self!.board.goals[indexPath.row].unchecked()
                if appDelegate.user.type == .leader
                {
                    self!.appDelegate.broadcastRoom()
                }
                else
                {
                    do
                    {
                        let theData = try JSONEncoder().encode(GoalCheckData(board: self!.board))
                        try self!.appDelegate.connection?.session.send(theData, toPeers: (self!.appDelegate.connection?.session.connectedPeers)!, with: .reliable)
                    }
                    catch let error
                    {
                        print("send checked error : \(error)")
                    }
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
        cell.checkBox.image = (board.goals[indexPath.row].isChecked() ? #imageLiteral(resourceName: "check-box") : #imageLiteral(resourceName: "blank-check-box"))
        cell.goalLabel.text = board.goals[indexPath.row].name
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
