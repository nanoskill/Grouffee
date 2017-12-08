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
    var boardName: String
    var duration: Int
    var members: [User]
    var timer : GrouffeeTimer!
    var goals : [Goal]

    init(boardName: String, duration: Int) {
        self.boardName = boardName
        self.duration = duration
        members = [User]()
        goals = [Goal]()
        timer = GrouffeeTimer(seconds: duration)
    }
    
    func joinBoard(user: User)
    {
        if members.count == 0 {timer.startTimer()}
        user.startWorking(inBoard: self)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let encoder = JSONEncoder()
        do
        {
            let theData = try encoder.encode(JoinData.init(targetBoard: self, user: appDelegate.user))
            try appDelegate.connection?.session.send(theData, toPeers: (appDelegate.connection?.session.connectedPeers)!, with: MCSessionSendDataMode.reliable)

        }
        catch let error
        {
            print("joinBoard error : \(error)")
        }
        members.append(user)
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
    }
}
