//
//  BoardListViewController.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class BoardListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet weak var roomName: UINavigationItem!
    
    @IBOutlet weak var boardTable: UITableView!
    var room : Room!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardTable.dataSource = self
        boardTable.delegate = self
        room.timer.delegate = self
        
        roomName.title = room.name
        
        room.timer.startTimer()
        
        progressBar.progress = 1
        
        appDelegate.connection?.delegate = self
    }
    
    @IBAction func addBoardBtnDidTap(_ sender: Any) {
        //BoardListViewController.boards.append(BoardList(boardName: "hehe", duration: "20", people: "4"))
        room.boards.append(Board(boardName: "Testing", duration: 50))
        boardTable.reloadData()
    }
    
}

extension BoardListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return room.boards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = boardTable.dequeueReusableCell(withIdentifier: "boardCell", for: indexPath) as! BoardListViewCell
        
        cell.boardName.text = room.boards[indexPath.row].boardName
        cell.duration.text = room.boards[indexPath.row].timer.getTimeString()
        cell.people.text = String(room.boards[indexPath.row].people)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension BoardListViewController : ConnectionModelDelegate
{
    func invitationWasReceived(fromPeer: String)
    {
        let popup = UIAlertController.createAcceptDeclinePopup(title: "Join Request", message: "Invitation from \(fromPeer). Do you want to accept this invitation?", handlerAccept:
        { (UIAlertAction) in
            self.appDelegate.connection?.invitationHandler(true, self.appDelegate.connection?.session)
        }, handlerDecline:
        { (UIAlertAction) in
            self.appDelegate.connection?.invitationHandler(true, self.appDelegate.connection?.session)
        })
        
        self.present(popup, animated: true, completion: nil)
    }
}

extension BoardListViewController : GrouffeeTimerDelegate
{
    func timeIsTicking() {
        DispatchQueue.main.async {
            self.timerLabel.text! = self.room.timer.getTimeString()
            self.progressBar.progress = Float(self.room.timer.timeRemaining) / Float(self.room.timer.initTime)
            self.boardTable.reloadData()
        }
    }
    func timeIsUp() {
        DispatchQueue.main.async {
            self.timerLabel.text! = "Time is Up!"
        }
    }
}
