//
//  RoomModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 30/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import UserNotifications

class Room
{
    var name : String
    var boards = [Board]()
    var leader : User
    var connectedMembers = [User]()
    var timer : GrouffeeTimer!
    
    init(name : String, leader : User, duration: Int) {
        self.name = name
        self.leader = leader
        self.timer = GrouffeeTimer(seconds: duration)
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func assignTimer(timer: GrouffeeTimer)
    {
        self.timer = timer
    }
    
    
}
