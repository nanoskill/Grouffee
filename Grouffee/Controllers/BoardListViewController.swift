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
        
        boardTable.dataSource = self
        boardTable.delegate = self
        
        //print(appDelegate.room!)
        //ingetin nanti diganti
        /*appDelegate.user = User(name: "Wennie")
        appDelegate.user.type = .leader
        appDelegate.room = Room(name: "RoomByWennie", duration: 15000)
        */
        appDelegate.room.timer.delegate = self
        roomName.title = appDelegate.room.name
        
        appDelegate.room.timer.startTimer()
        
        progressBar.progress = 1
        
        appDelegate.connection?.delegate = self
        //appDelegate.connection?.session.delegate = self
        dragGesture.addTarget(self, action: #selector(timerBeingDragged(_:)))
        timerContainer.addGestureRecognizer(dragGesture)
        
        if appDelegate.user.type == .member
        {
            plusButton.isHidden = true
            addBoardButton.isHidden = true
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
            destination.board = selectedBoard
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
        /*
        if appDelegate.user.type == .leader
        {
            if appDelegate.room.boards[indexPath.row].members.contains(where: { [weak self] (theUser) -> Bool in
                if theUser.name == self?.appDelegate.user.name
                {
                    return true
                }
                return false
            })
            {
                appDelegate.room.boards[indexPath.row].exitBoard(user: (appDelegate.user)!)
            }
            else
            {
                appDelegate.room.boards[indexPath.row].joinBoard(user: (appDelegate.user)!)
            }
        }
        else
        {
            if appDelegate.room.boards[indexPath.row].members.contains(where: { [weak self] (theUser) -> Bool in
                if theUser.name == self?.appDelegate.user.name
                {
                    return true
                }
                return false
            })
            {
                do
                {
                    let theData = try JSONEncoder().encode(ExitData(fromBoard: indexPath.row, user: appDelegate.user.name))
                    try appDelegate.connection?.session.send(theData, toPeers: (appDelegate.connection?.session.connectedPeers)!, with: .reliable)
                }
                catch let error
                {
                    print("Sending exit data error :\(error)")
                }
            }
            else
            {
                do
                {
                    let theData = try JSONEncoder().encode(JoinData(targetBoard: indexPath.row, user: appDelegate.user.name))
                    try appDelegate.connection?.session.send(theData, toPeers: (appDelegate.connection?.session.connectedPeers)!, with: .reliable)
                }
                catch let error
                {
                    print("Sending join data error :\(error)")
                }
            }
        }*/
        /*
        let sb = UIStoryboard.init(name: "BoardDetail", bundle: nil)
        let destination! = sb.instantiateInitialViewController() as! BoardListViewController
        //let selectedBoard = appDelegate.room.boards [(boardTable.indexPathForSelectedRow?.row)!]
        
        destination.boardNameInput = selectedBoard.boardName
        destination.durInput = selectedBoard.duration
        destination.descInput = selectedBoard.desc
        destination.goals = selectedBoard.goals
 */
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

extension BoardListViewController : ConnectionModelDelegate
{
    func foundPeer(peer: MCPeerID) {
        if appDelegate.user.type == .leader { return }
        appDelegate.connection?.serviceBrowser.invitePeer(peer, to: (appDelegate.connection?.session)!, withContext: nil, timeout: 10)
        print("Auto connected by member")
    }
    func connectedWithPeer(peerID: MCPeerID, state: MCSessionState) {
        if appDelegate.user.type == .leader { return }
        appDelegate.connection?.serviceBrowser.stopBrowsingForPeers()
    }
    func invitationWasReceived(fromPeer: MCPeerID)
    {
        if appDelegate.user.type == .member { return }
        
        print("Current connPeer : \((appDelegate.connection?.session.connectedPeers)!)")
        if appDelegate.room.connectedMembers.contains(where: { (user) -> Bool in
            return user.peerId == fromPeer
        })
        {
            print("Auto connected by leader")
            self.appDelegate.connection?.invitationHandler(true, self.appDelegate.connection?.session)
        }
        else
        {
            let popup = UIAlertController.createAcceptDeclinePopup(title: "Join Request", message: "\(fromPeer.displayName) has requested to join \(appDelegate.room.name)", handlerAccept:
            { (UIAlertAction) in
                self.appDelegate.connection?.invitationHandler(true, self.appDelegate.connection?.session)
                self.appDelegate.room.connectedMembers.append(User(peerId: fromPeer))
                
            }, handlerDecline:
            { (UIAlertAction) in
                self.appDelegate.connection?.invitationHandler(false, self.appDelegate.connection?.session)
            })
            
            self.present(popup, animated: true, completion: nil)
        }
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
/*
extension BoardListViewController : MCSessionDelegate
{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        if state == .connected
        {
            if appDelegate.user.type == .leader
            {
                appDelegate.broadcastRoom()
            }
            /*
             var theData = Data()
             let enc = JSONEncoder()
             do
             {
             theData = try enc.encode(self.appDelegate.room)
             
             var tempArray = [MCPeerID]()
             tempArray.append(peerID)
             try self.appDelegate.connection?.session.send(theData, toPeers: tempArray, with: MCSessionSendDataMode.reliable)
             }
             catch let error
             {
             print(error)
             }
             */
        }
    }
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
    {
        let decoder = JSONDecoder()
        DispatchQueue.main.async {
            do
            {
                self.appDelegate.room = try decoder.decode(Room.self, from: data)
            }
            catch let error
            {
                print(error)
            }
            //self.boardTable.reloadData()
        }
    }
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {
        
    }
    
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress)
    {
        
    }
    
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?)
    {
        
    }
}
*/
