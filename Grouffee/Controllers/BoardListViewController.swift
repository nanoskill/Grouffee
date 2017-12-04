//
//  BoardListViewController.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class BoardListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var progressBar: UIProgressView!
    @IBOutlet weak var roomName: UINavigationItem!
    
    @IBOutlet weak var boardTable: UITableView!
    static var boards: [Board] = []
    
   // static var timeRemaining = 0
    var startTime = 0
    
    static var roomNameInput: String?
    
    static var projectTimer = MyTimer()
    static var timer = Timer()

    static var alreadyOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardTable.dataSource = self
        boardTable.delegate = self
        print(BoardListViewController.boards.count)
        
        startTime = BoardListViewController.projectTimer.timeRemaining!
        // Do any additional setup after loading the view.
        roomName.title = BoardListViewController.roomNameInput!
        
        
        //updateTimer()
        if !BoardListViewController.alreadyOpen {
            timerLabel.text = BoardListViewController.projectTimer.timeString(time: TimeInterval(BoardListViewController.projectTimer.timeRemaining!))
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            //BoardListViewController.alreadyOpen = true
        } else {
            
        }
        
        progressBar.progress = 1
    }
    
    
    @objc
    func updateTimer() {
        
        if BoardListViewController.projectTimer.timeRemaining != 0 {
           
            BoardListViewController.projectTimer.timeRemaining! -= 1     //This will decrement(count down)the seconds.
            self.timerLabel.text! = BoardListViewController.projectTimer.timeString(time: TimeInterval(BoardListViewController.projectTimer.timeRemaining!)) //This will update the label.
            //print(timerLabel.text)
            print(BoardListViewController.projectTimer.timeString(time: TimeInterval(BoardListViewController.projectTimer.timeRemaining!)))
            progressBar.progress = Float(BoardListViewController.projectTimer.timeRemaining!) / Float(startTime)
            
            boardTable.reloadData()
        } else {
            timerLabel.text = "Time's up!"
        }
//        BoardListViewController.boardTimer.updateTimer(timerLabel: timerLabel, progress: progressBar)
        
    }
    
    func timeString(time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    @IBAction func addBoardBtnDidTap(_ sender: Any) {
        //BoardListViewController.boards.append(BoardList(boardName: "hehe", duration: "20", people: "4"))
        //boardTable.reloadData()
    }
    
}

extension BoardListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BoardListViewController.boards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = boardTable.dequeueReusableCell(withIdentifier: "boardCell", for: indexPath) as! BoardListViewCell
        
        cell.boardName.text = BoardListViewController.boards[indexPath.row].boardName
        cell.duration.text = timeString(time: TimeInterval(BoardListViewController.boards[indexPath.row].timeRemaining))
        cell.people.text = String(BoardListViewController.boards[indexPath.row].people)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
