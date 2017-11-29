//
//  Timer.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class MyTimer {
    var timeRemaining: Int?
    
    init(time: Int) {
        timeRemaining = time
    }
    
    @objc
    func updateTimer(timerLabel: UILabel) {
        timeRemaining! -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = timeString(time: TimeInterval(timeRemaining!)) //This will update the label.
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

}
