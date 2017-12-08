//
//  SessionModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 03/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

struct GrouffeeSession : Codable
{
    var board : Board
    var startTime : Date
    var endTime : Date?
}
