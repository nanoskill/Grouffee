//
//  UserModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 30/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import Foundation

enum UserStatus
{
    case idle
    case working
}

class User {
    var name : String
    var timer : GrouffeeTimer?
    var status = UserStatus.idle
    
    init(name: String)
    {
        self.name = name
        self.timer = GrouffeeTimer()
        //NotificationCenter.default.addObserver(self, selector: #selector(self.saveTimer(notif:)), name: nil, object: nil)
    }
    
    func assignTimer(timer: GrouffeeTimer)
    {
        self.timer = timer
    }
}
