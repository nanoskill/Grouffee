//
//  UserModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 30/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import Foundation
import MultipeerConnectivity

enum UserStatus : Int, Codable
{
    case idle
    case working
}

enum UserType : Int, Codable
{
    case member
    case leader
}

class User : Codable{
    var name : String
    var timer : GrouffeeTimer
    var status = UserStatus.idle
    //var sessions = [GrouffeeSession]()
    var peerId : MCPeerID!
    var type = UserType.member
    var workingOnBoard : Board?
    
    enum CodingKeys : String, CodingKey {
        case name
        case timer
        case status
        case type
        //case sessions
        case workingOnBoard
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        timer = try values.decode(GrouffeeTimer.self, forKey: .timer)
        status = try values.decode(UserStatus.self, forKey: .status)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        for ids in (appDelegate.connection?.session.connectedPeers)!
        {
            if name == ids.displayName
            {
                peerId = ids
            }
        }
        type = try values.decode(UserType.self, forKey: .type)
        workingOnBoard = try values.decode(Board.self, forKey: .workingOnBoard)
        //sessions = try values.decode([GrouffeeSession].self, forKey: .sessions)
    }
    
    init(name: String)
    {
        self.name = name
        self.timer = GrouffeeTimer()
        //peerId = (UIApplication.shared.delegate as! AppDelegate).myPeerId
        //NotificationCenter.default.addObserver(self, selector: #selector(self.saveTimer(notif:)), name: nil, object: nil)
    }
    
    init(peerId: MCPeerID)
    {
        name = peerId.displayName
        self.timer = GrouffeeTimer()
        self.peerId = peerId
    }
    
    func joinBoard(board: Board)
    {
        status = .working
        timer.startTimer()
        workingOnBoard = board
        if !board.timer.isRunning {board.timer.startTimer()}
    }
    
    func exitBoard()
    {
        status = .idle
        timer.stopTimer()
        if workingOnBoard!.getPeopleWorkingOnBoard().count == 1
        {
            workingOnBoard!.timer.stopTimer()
        }
        workingOnBoard = nil
    }
}
