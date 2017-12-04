//
//  BoardList.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 01/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import Foundation

class Board {
    var boardName: String
    var duration: Int
    var people: Int
    var timeRemaining: Int
    var timeLabel: String

    var boardTimer = MyTimer()

    init(boardName: String, duration: Int) {
        self.boardName = boardName
        self.duration = duration
        people = 0
        timeRemaining = duration
        timeLabel = boardTimer.timeString(time: TimeInterval(duration))
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc
    func updateTimer() {
        
        if timeRemaining != 0 {
            
            self.timeRemaining -= 1     //This will decrement(count down)the seconds.
            //self.timerLabel.text! = BoardListViewController.boardTimer.timeString(time: TimeInterval(BoardListViewController.boardTimer.timeRemaining!)) //This will update the label.
            //print(timerLabel.text)
            //progressBar.progress = Float(BoardListViewController.boardTimer.timeRemaining!) / Float(duration)
        } else {
           // timerLabel.text = "Time's up!"
        }
        //        BoardListViewController.boardTimer.updateTimer(timerLabel: timerLabel, progress: progressBar)
        
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
