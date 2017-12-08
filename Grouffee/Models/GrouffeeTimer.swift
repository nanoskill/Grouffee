//
//  GrouffeeTimer.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 29/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import Foundation
import NotificationCenter

@objc public protocol GrouffeeTimerDelegate
{
    @objc optional func timeIsUp()
    @objc optional func timeIsTicking()
}

class GrouffeeTimer : Codable {
    var timeRemaining : TimeInterval
    var initTime : TimeInterval
    var isRunning = false
    var delegate : GrouffeeTimerDelegate?
    
    var milisecTicks = 0
    
    var timer = Timer()
    
    var savedTime = Date()
    
    /**
     Create a timer that will count down
     */
    init(hour: Int, minute: Int, second: Int) {
        initTime = TimeInterval(hour * 60 * 60 + minute * 60 + second)
        timeRemaining = initTime
    }
    
    /**
     Create a timer that will count down
     */
    init(seconds: Int) {
        initTime = TimeInterval(seconds)
        timeRemaining = initTime
    }
    
    /**
     Create a stopwatch that will count up
     */
    init()
    {
        initTime = 0
        timeRemaining = 0
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        timeRemaining = try values.decode(TimeInterval.self, forKey: .timeRemaining)
        initTime = try values.decode(TimeInterval.self, forKey: .initTime)
        isRunning = try values.decode(Bool.self, forKey: .isRunning)
        if isRunning
        {
            startTimer()
        }
    }
    
    enum GTType {
        case timer
        case stopwatch
    }
    
    private enum CodingKeys : String, CodingKey {
        case timeRemaining = "time_left"
        case initTime = "init_time"
        case isRunning
    }
    
    func getType() -> GTType
    {
        return (initTime == 0 ? GTType.stopwatch : GTType.timer)
    }
    
    func startTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerDidTick), userInfo: nil, repeats: true)
        isRunning = true
    }
    
    func stopTimer()
    {
        timer.invalidate()
        isRunning = false
    }
    
    func resetTimer()
    {
        stopTimer()
        timeRemaining = initTime
    }
    
    @objc func timerDidTick()
    {
        timeRemaining += (initTime == 0 ? 0.01 : -0.01)
        milisecTicks += 1
        if milisecTicks == 100
        {
            delegate?.timeIsTicking!()
            milisecTicks = 0
        }
        if initTime != 0 && timeRemaining <= 0
        {
            stopTimer()
            delegate?.timeIsUp!()
        }
        //print("Timer is ticking at \(timeRemaining)")
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
    
    func getMilisecond() -> Int
    {
        return Int(timeRemaining*100) % 100
    }
    
    func getTimeString() -> String {
        return String(format:"%02i : %02i : %02i", getHour(), getMinute(), getSecond())
    }
    
    @objc func snapTimer()
    {
        savedTime = Date.init()
        print("SNAPPED: \(savedTime)")
    }
    
    @objc func restoreTimer()
    {
        print(Date().timeIntervalSince(savedTime))
        var diff = Date().timeIntervalSince(savedTime)
        diff *= (initTime == 0 ? 1 : -1)
        timeRemaining += diff
        if timeRemaining <= 0 {delegate?.timeIsUp! ()}
        
        print("RESTORED, diff: \(diff)")
    }
}
