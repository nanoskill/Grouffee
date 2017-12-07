//
//  MemberListViewController.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 07/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class MemberListTableCell : UITableViewCell
{
    @IBOutlet weak var logo : UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var timeLabel : UILabel!
}

class MemberListViewController: UIViewController {
    @IBOutlet weak var viewTitle: UINavigationItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var memberTable: UITableView!
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var refreshPerOneSec : Timer!
    override func viewDidLoad() {
        super.viewDidLoad()
        memberTable.dataSource = self
        refreshPerOneSec = Timer(timeInterval: 1, repeats: true, block: { (_) in
            DispatchQueue.main.async {
                self.memberTable.reloadData()
            }
        })
    }
    
    @IBAction func backButtonDidTap(_ sender: Any)
    {
        refreshPerOneSec.invalidate()
        dismiss(animated: true, completion: nil)
    }
}

extension MemberListViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.room.connectedMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell") as! MemberListTableCell
        cell.logo.image =  (appDelegate.room.connectedMembers[indexPath.row].status == .idle ? #imageLiteral(resourceName: "Logo - Blue Fix") : #imageLiteral(resourceName: "Logo - White"))
        cell.nameLabel.text = appDelegate.room.connectedMembers[indexPath.row].name
        cell.timeLabel.text = appDelegate.room.connectedMembers[indexPath.row].timer.getTimeString()
        return cell
    }
}
