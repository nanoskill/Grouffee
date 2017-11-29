//
//  BoardListViewController.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class BoardListViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    var timeRemaining = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(timeRemaining)
        // Do any additional setup after loading the view.
        
        timerLabel.text = timeString(time: TimeInterval(timeRemaining))
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        //timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(BoardListViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc
    func updateTimer() {
        timeRemaining -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = timeString(time: TimeInterval(timeRemaining)) //This will update the label.
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

}
