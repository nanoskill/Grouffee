//
//  GrouffeeTimer.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 29/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import Foundation

@objc public protocol GrouffeeTimerDelegate
{
    @objc optional func timeIsUp()
    @objc optional func timeIsTicking()
}

class GrouffeeTimer {
    var timeRemaining : Int
    var initTime : Int
    
    var delegate : GrouffeeTimerDelegate?
    
    var timer = Timer()
    
    init(hour: Int, minute: Int, second: Int) {
        initTime = hour * 60 * 60 + minute * 60 + second
        timeRemaining = initTime
    }
    
    func startTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDidTick), userInfo: nil, repeats: true)
    }
    
    func stopTimer()
    {
        timer.invalidate()
    }
    
    func resetTimer()
    {
        stopTimer()
        timeRemaining = initTime
    }
    
    @objc func timerDidTick()
    {
        timeRemaining -= 1
        delegate?.timeIsTicking!()
        if timeRemaining == 0
        {
            delegate?.timeIsUp!()
        }
    }
    
    func getHour() -> Int
    {
        return Int(timeRemaining) / 3600
    }
    
    func getMinute() -> Int
    {
        return Int(timeRemaining) / 60 % 60
    }
    
    func getSecond() -> Int
    {
        return Int(timeRemaining) % 60
    }
    
    func getTime() -> (hour:Int, minute:Int, second:Int)
    {
        return (getHour(), getMinute(), getSecond())
    }
}
