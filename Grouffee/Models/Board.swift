//
//  BoardList.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 01/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import MultipeerConnectivity


class Board : Codable{
    var boardId : Int
    var boardName: String
    var desc: String
    var duration: Int
    var timer : GrouffeeTimer!
    var goals : [Goal]
    
    init(boardName: String, duration: Int, desc: String, goals: [Goal], boardId: Int) {
        self.boardName = boardName
        self.duration = duration
        timer = GrouffeeTimer(seconds: duration)
        self.boardId = boardId
        self.desc = desc
        self.goals = goals
    }
    
    enum CodingKeys : String, CodingKey
    {
        case boardId
        case boardName
        case desc
        case duration
        case timer
        case goals
    }
    
    required init(from decoder:Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        boardId = try values.decode(Int.self, forKey: .boardId)
        boardName = try values.decode(String.self, forKey: .boardName)
        desc = try values.decode(String.self, forKey: .desc)
        duration = try values.decode(Int.self, forKey: .duration)
        timer = try values.decode(GrouffeeTimer.self, forKey: .timer)
        goals = try values.decode([Goal].self, forKey: .goals)
    }
    
    func getPeopleWorkingOnBoard() -> [User]
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let members = appDelegate.room.connectedMembers
        var workingOnBoard = [User]()
        for member in members
        {
            guard let memberBoardId = member.workingOnBoard?.boardId else {continue}
            if memberBoardId == self.boardId
            {
                workingOnBoard.append(member)
            }
        }
        return workingOnBoard
    }
    /*
    func joinBoard(user: User)
    {
        user.startWorking(inBoard: self)
        members.append(user)
        if members.count > 0 && !timer.isRunning {timer.startTimer()}
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.broadcastRoom()
        }
//        let encoder = JSONEncoder()
//        do
//        {
//            let theData = try encoder.encode(JoinData.init(targetBoard: self.boardId, user: appDelegate.user.name))
//            try appDelegate.connection?.session.send(theData, toPeers: (appDelegate.connection?.session.connectedPeers)!, with: MCSessionSendDataMode.reliable)
//        }
//        catch let error
//        {
//            print("joinBoard error : \(error)")
//        }
    }
 
    func exitBoard(user: User)
    {
        if members.count == 1 {timer.stopTimer()}
        for (idx, usr) in members.enumerated() {
            if usr.name == user.name
            {
                usr.stopWorking()
                members.remove(at: idx)
            }
        }
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.broadcastRoom()
        }
    }
 */
}
