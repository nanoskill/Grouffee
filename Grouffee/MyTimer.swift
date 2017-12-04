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
   // var startTime: Int?
    
    @objc
    func updateTimer(timerLabel: UILabel!, progress: UIProgressView!) {
        //print(timeRemaining)
        let startTime = timeRemaining
        
        timeRemaining! -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = timeString(time: TimeInterval(timeRemaining!)) //This will update the label.
        progress.progress = Float(timeRemaining!) / Float(startTime!)
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

}
