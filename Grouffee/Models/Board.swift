//
//  BoardList.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 01/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import Foundation

class Board : Codable{
    var boardName: String
    var duration: Int
    var members: [User]
    var timer : GrouffeeTimer!

    init(boardName: String, duration: Int) {
        self.boardName = boardName
        self.duration = duration
        members = [User]()
        timer = GrouffeeTimer(seconds: duration)
    }
    
    func joinBoard(user: User)
    {
        if members.count == 0 {timer.startTimer()}
        user.startWorking()
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
