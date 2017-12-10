//
//  BoardListViewController.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class BoardListViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet weak var roomName: UINavigationItem!
    @IBOutlet weak var peopleListButton : UIBarButtonItem!
    
    @IBOutlet weak var timerContainer : UIView!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var addBoardButton: UIButton!
    
    @IBOutlet weak var boardTable: UITableView!

    
   // @IBOutlet weak var boardCell: BoardListViewCell!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let dragGesture = UIPanGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //boardTable.dataSource = self
        //boardTable.delegate = self
        appDelegate.room.timer.delegate = self
        roomName.title = appDelegate.room.name

        
        progressBar.progress = 1
        
        appDelegate.connection?.delegate = appDelegate.room
        
        dragGesture.addTarget(self, action: #selector(timerBeingDragged(_:)))
        timerContainer.addGestureRecognizer(dragGesture)
        
        if appDelegate.user.type == .member
        {
            plusButton.isHidden = true
            addBoardButton.isHidden = true
        }
        else
        {
            appDelegate.room.timer.startTimer()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(enteredBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enteredForeground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        //boardCell.addGestureRecognizer(tapBoardGesture)
    }
    
    @objc func enteredBackground()
    {
        appDelegate.room.timer.snapTimer()
    }
    
    @objc func enteredForeground()
    {
        appDelegate.connection?.serviceBrowser.startBrowsingForPeers()
        appDelegate.room.timer.restoreTimer()
    }
    
    @IBAction func peopleListButtonDidTap(_ sender: Any)
    {
        //performSegue(withIdentifier: "showMembersSegue", sender: sender)
        let storyboard = UIStoryboard.init(name: "MemberList", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        //controller?.modalTransitionStyle = .partialCurl
        //controller?.modalPresentationStyle = .currentContext
        //show(controller!, sender: nil)
        present(controller!, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonDidTap(_ sender: Any) {
        let sb = UIStoryboard.init(name: "ReviewPage", bundle: nil)
        let con = sb.instantiateInitialViewController() as! ReviewPageViewController
        //this
        present(con, animated: true, completion: nil)
    }
    
    @objc func timerBeingDragged(_ sender : UIPanGestureRecognizer) {
        print("Being Dragged : \(dragGesture.translation(in: self.view)) \(dragGesture.velocity(in: self.view))")
        if self.timerContainer.center.x + sender.translation(in: self.view).x >= self.view.center.x - 80
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
            self.timerContainer.center.x = self.view.center.x - 80
        }
        //masih ngebug
    }
    
    @IBAction func addBoardBtnDidTap(_ sender: Any) {
        //BoardListViewController.boards.append(BoardList(boardName: "hehe", duration: "20", people: "4"))
        //room.boards.append(Board(boardName: "Testing", duration: 50))
        //boardTable.reloadData()
        performSegue(withIdentifier: "addBoardSegue", sender: sender)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) {
            self.timerContainer.center.x = self.view.center.x
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBoardDetail" {
            let destination = segue.destination as! BoardDetailViewController
            let selectedBoard = sender as! Board
            
//            destination.boardNameInput = selectedBoard.boardName
//            destination.durInput = selectedBoard.duration
//            destination.descInput = selectedBoard.desc
//            destination.goals = selectedBoard.goals
            destination.boardId = selectedBoard.boardId
        }
    }
}

extension BoardListViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        var actions = [UIContextualAction]()
        let theHandler : UIContextualActionHandler =
        {   [weak self]
            (theAction, theView, boolHandler) in
            if self?.appDelegate.user.type == .member
            {
                do
                {
                    let theData = try JSONEncoder().encode(JoinData(targetBoard: indexPath.row, user: (self?.appDelegate.user.name)!))
                    try self?.appDelegate.connection?.session.send(theData, toPeers: (self?.appDelegate.connection?.session.connectedPeers)!, with: .reliable)
                }
                catch let error
                {
                    print("Sending join data error :\(error)")
                }
            }
            self?.appDelegate.user.joinBoard(board: (self?.appDelegate.room.boards[indexPath.row])!)
            self!.performSegue(withIdentifier: "showBoardDetail", sender: self!.appDelegate.room.boards [indexPath.row])
        }
        
        let theButton = UIContextualAction(style: .normal, title: "JOIN", handler: theHandler)
        theButton.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        actions.append(theButton)
        return UISwipeActionsConfiguration(actions: actions)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showBoardDetail", sender: appDelegate.room.boards [indexPath.row])
    }
    
}

extension BoardListViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.room.boards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "boardCell", for: indexPath) as! BoardListViewCell
        
        cell.boardName.text = appDelegate.room.boards[indexPath.row].boardName
        cell.duration.text = appDelegate.room.boards[indexPath.row].timer.getTimeString()
        cell.people.text = String(appDelegate.room.boards[indexPath.row].getPeopleWorkingOnBoard().count)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension BoardListViewController : GrouffeeTimerDelegate
{
    func timeIsTicking() {
        DispatchQueue.main.async {
            self.timerLabel.text! = self.appDelegate.room.timer.getTimeString()
            self.progressBar.progress = Float(self.appDelegate.room.timer.timeRemaining) / Float(self.appDelegate.room.timer.initTime)
            self.boardTable.reloadData() //need optimization
            self.peopleListButton.title = "\(self.appDelegate.room.connectedMembers.count)"
        }
    }
    func timeIsUp() {
        DispatchQueue.main.async {
            self.timerLabel.text! = "Time is Up!"
        }
    }
}
