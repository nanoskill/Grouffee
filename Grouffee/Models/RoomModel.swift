//
//  RoomModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 30/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import UserNotifications

class Room : Codable
{
    var name : String
    var boards = [Board]()
    //var leader : User
    var connectedMembers = [User]()
    var timer : GrouffeeTimer!
    var lastBoardId = 0
    
    init(name : String, duration: Int) {
        self.name = name
        //self.leader = leader
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
        //case leader
        case connectedMembers
        case timer
        case lastBoardId
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: CodingKeys.name)
        try container.encode(boards, forKey: CodingKeys.boards)
        //try container.encode(leader, forKey: CodingKeys.leader)
        try container.encode(connectedMembers, forKey: CodingKeys.connectedMembers)
        try container.encode(timer, forKey: CodingKeys.timer)
        try container.encode(lastBoardId, forKey: CodingKeys.lastBoardId)
    }
    
    func addBoard(boardName: String, duration : Int)
    {
        boards.append(Board(boardId: lastBoardId, boardName: boardName, duration: duration))
        lastBoardId += 1
    }
    
    /*
    required init(from decoder: Decoder) throws {
        
    }
    */
}
