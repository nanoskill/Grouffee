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
    @IBOutlet weak var peopleListButton : UIBarButtonItem!
    
    @IBOutlet weak var timerContainer : UIView!
    
    @IBOutlet weak var boardTable: UITableView!
    var room : Room! = (UIApplication.shared.delegate as! AppDelegate).room
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let dragGesture = UIPanGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardTable.dataSource = self
        boardTable.delegate = self
        room.timer.delegate = self
        
        roomName.title = room.name
        
        room.timer.startTimer()
        
        progressBar.progress = 1
        
        appDelegate.connection?.delegate = self
        dragGesture.addTarget(self, action: #selector(timerBeingDragged(_:)))
        timerContainer.addGestureRecognizer(dragGesture)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(freezeTimer), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(unfreezeTimer), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc func freezeTimer()
    {
        room.timer.snapTimer()
    }
    
    @objc func unfreezeTimer()
    {
        room.timer.restoreTimer()
    }
    
    @objc func timerBeingDragged(_ sender : UIPanGestureRecognizer) {
    
        print("Being Dragged : \(dragGesture.translation(in: self.view)) \(dragGesture.velocity(in: self.view))")
        if self.timerContainer.center.x + sender.translation(in: self.view).x >= self.view.center.x - 50
        {
            if self.timerContainer.center.x + sender.translation(in: self.view).x < self.view.center.x
            {
                self.timerContainer.center.x += sender.translation(in: self.view).x
            }
            else
            {
                self.timerContainer.center.x = self.view.center.x
            }
        }
        else
        {
            self.timerContainer.center.x = self.view.center.x - 50
        }
        //masih ngebug
    }
    
    @IBAction func addBoardBtnDidTap(_ sender: Any) {
        //BoardListViewController.boards.append(BoardList(boardName: "hehe", duration: "20", people: "4"))
        //room.boards.append(Board(boardName: "Testing", duration: 50))
        //boardTable.reloadData()
        performSegue(withIdentifier: "addBoardSegue", sender: sender)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        var actions = [UIContextualAction]()
        let theHandler : UIContextualActionHandler =
        {
            (theAction, theView, boolHandler) in
            print("JOINED")
        }
        let theButton = UIContextualAction(style: .normal, title: "JOIN", handler: theHandler)
        theButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        actions.append(theButton)
        return UISwipeActionsConfiguration(actions: actions)
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
       //     self.boardTable.reloadData()
            self.peopleListButton.title = "\(self.room.connectedMembers.count)"
        }
    }
    func timeIsUp() {
        DispatchQueue.main.async {
            self.timerLabel.text! = "Time is Up!"
        }
    }
}
