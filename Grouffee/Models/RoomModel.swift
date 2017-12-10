//
//  RoomModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 30/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import UserNotifications
import MultipeerConnectivity

class Room : Codable
{
    var name : String
    var boards = [Board]()
    var connectedMembers = [User]()
    var timer : GrouffeeTimer!
    var lastBoardId = 0
    
    init(name : String, duration: Int) {
        self.name = name
        self.timer = GrouffeeTimer(seconds: duration)
        self.connectedMembers.append(appDelegate.user!)
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    /*
    func assignTimer(timer: GrouffeeTimer)
    {
        self.timer = timer
    }
     */
    
    enum CodingKeys : String, CodingKey
    {
        case name
        case boards
        case connectedMembers
        case timer
        case lastBoardId
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: CodingKeys.name)
        try container.encode(boards, forKey: CodingKeys.boards)
        try container.encode(connectedMembers, forKey: CodingKeys.connectedMembers)
        try container.encode(timer, forKey: CodingKeys.timer)
        try container.encode(lastBoardId, forKey: CodingKeys.lastBoardId)
    }
    
    func addBoard(boardName: String, duration : Int, desc : String, goals : [Goal])
    {
        boards.append(Board(boardName: boardName, duration: duration, desc: desc, goals: goals, boardId: lastBoardId))
        lastBoardId += 1
    }
    
    /*
    required init(from decoder: Decoder) throws {
        
    }
    */
}

extension Room : ConnectionModelDelegate
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
            
            UIApplication.topViewController()?.present(popup, animated: true, completion: nil)
        }
    }
}
