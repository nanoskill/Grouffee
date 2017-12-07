//
//  BoardListViewController.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import MultipeerConnectivity

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
        appDelegate.connection?.session.delegate = self
        dragGesture.addTarget(self, action: #selector(timerBeingDragged(_:)))
        timerContainer.addGestureRecognizer(dragGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(enteredBackground), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(enteredForeground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @objc func enteredBackground()
    {
        room.timer.snapTimer()
    }
    
    @objc func enteredForeground()
    {
        appDelegate.connection?.serviceBrowser.startBrowsingForPeers()
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
            let popup = UIAlertController.createAcceptDeclinePopup(title: "Join Request", message: "\(fromPeer.displayName) has requested to join \(room.name)", handlerAccept:
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
            self.timerLabel.text! = self.room.timer.getTimeString()
            self.progressBar.progress = Float(self.room.timer.timeRemaining) / Float(self.room.timer.initTime)
            self.boardTable.reloadData() //need optimization
            self.peopleListButton.title = "\(self.room.connectedMembers.count)"
        }
    }
    func timeIsUp() {
        DispatchQueue.main.async {
            self.timerLabel.text! = "Time is Up!"
        }
    }
}

extension BoardListViewController : MCSessionDelegate
{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        if state == .connected
        {
            appDelegate.broadcastRoom()
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
                self.room = self.appDelegate.room
            }
            catch let error
            {
                print(error)
            }
            self.boardTable.reloadData()
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
