//
//  UserModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 30/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import Foundation

class User {
    var name : String
    var timer : GrouffeeTimer?
    
    init(name: String) {
        self.name = name
    }
    
    func assignTimer(timer: GrouffeeTimer)
    {
        self.timer = timer
    }
}
