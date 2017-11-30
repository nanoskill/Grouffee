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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(timeRemaining)
        // Do any additional setup after loading the view.
        
        timerLabel.text = timeString(time: TimeInterval(timeRemaining))
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        //timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(BoardListViewController.updateTimer)), userInfo: nil, repeats: true)
        
        appDelegate.connection?.delegate = self
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

extension BoardListViewController : ConnectionModelDelegate
{
    func invitationWasReceived(fromPeer: String)
    {
        let popup = UIAlertController.createAcceptDeclinePopup(title: "Join Request", message: "Invitation from \(fromPeer). Do you want to accept this invitation?", handlerAccept:
        { (UIAlertAction) in
            self.appDelegate.connection?.invitationHandler(true, self.appDelegate.connection?.session)
        }, handlerDecline:
        { (UIAlertAction) in
            self.appDelegate.connection?.invitationHandler(true, self.appDelegate.connection?.session)
        })
        
        self.present(popup, animated: true, completion: nil)
    }
}
