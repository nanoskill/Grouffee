//
//  GoalModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 08/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class Goal : Codable{
    var name : String
    var user : User?
    var time : Date?
    
    init(name : String) {
        self.name = name
    }
    
    func checked(user: User) {
        self.user = user
        time = Date()
    }
    
    enum CodingKeys : String, CodingKey
    {
        case name
        case user
        case time
    }
    
    required init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try values.decode(String.self, forKey: .name)
        let temp = try values.decodeIfPresent(User.self, forKey: .user)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if temp != nil
        {
            for user in appDelegate.room.connectedMembers
            {
                if user.name == temp?.name
                {
                    self.user = user
                    break
                }
            }
        }
        time = try values.decodeIfPresent(Date.self, forKey: .time)
    }
    
    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: CodingKeys.name)
        try container.encodeIfPresent(user, forKey: CodingKeys.user)
        try container.encodeIfPresent(time, forKey: CodingKeys.time)
    }
    
    func unchecked() {
        self.user = nil
        time = nil
    }
    
    func isChecked() -> Bool
    {
        return user != nil
    }
}
