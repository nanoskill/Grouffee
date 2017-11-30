//
//  RoomModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 30/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import Foundation

class Room
{
    var boards = [Board]()
    var connectedMembers = [User]()
    var timer : GrouffeeTimer?
    
    func assignTimer(timer: GrouffeeTimer)
    {
        self.timer = timer
    }
}
