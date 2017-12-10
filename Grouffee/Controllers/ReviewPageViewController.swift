//
//  ReviewPageViewController.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 09/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class ReviewPageViewController: UIViewController {

    @IBOutlet weak var memberListView: UIView!
    @IBOutlet weak var boardListView: UIView!
    @IBOutlet weak var boardTable: UITableView!
    @IBOutlet weak var memberTable: UITableView!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        memberListView.isHidden = false
        boardListView.isHidden = true
        
        boardTable.dataSource = self
        memberTable.dataSource = self
        
    }

    @IBAction func segmentedDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            memberListView.isHidden = false
            boardListView.isHidden = true
        case 1:
            memberListView.isHidden = true
            boardListView.isHidden = false
        default:
            print("error")
        }
    }
    
}

extension ReviewPageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.memberTable {
            return 2//appDelegate.room.connectedMembers.count
        } else if tableView == self.boardListView {
            return 2//appDelegate.room.boards.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if tableView == self.memberTable {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell") as! MemberListTableCell
            return cell
        } else if tableView == self.boardListView {
            return cell
        }
        return cell
    }
    
    
}
