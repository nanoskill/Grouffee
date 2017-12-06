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
    var people: Int
    var timer : GrouffeeTimer!

    init(boardName: String, duration: Int) {
        self.boardName = boardName
        self.duration = duration
        people = 0
        timer = GrouffeeTimer(seconds: duration)
    }
}
