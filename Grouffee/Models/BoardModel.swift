//
//  BoardModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 30/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import Foundation

class Board {
    var members = [User]()
    var leader : User
    var name : String
    var timer : Timer?
    
    init(name: String, leader: User) {
        self.name = name
        self.leader = leader
    }
    
    func assignTimer(timer: Timer)
    {
        self.timer = timer
    }
}
