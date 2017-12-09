//
//  BoardDetailViewController.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 08/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class BoardDetailViewController: UIViewController {
    
    @IBOutlet weak var boardTimer: UIView!
    
    @IBOutlet var boardName: UILabel!
    @IBOutlet var duration: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet var goalTable: UITableView!
    @IBOutlet weak var member: UILabel!
    var goals: [String] = []
    
    var boardNameInput: String?
    var durInput: Int?
    var descInput: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        boardName.text = boardNameInput
        duration.text = "\(durInput!/3600) \("hours") \(durInput!%3600 / 60) \("minutes")"
        desc.text = descInput
        
        let checkedGesture = UITapGestureRecognizer(target: self, action: #selector(checkListDidTap))
        
        
    }
    
    @objc func checkListDidTap() {
        
    }
    
    @IBAction func backItemDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension BoardDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        let selectedCell = goalTable.cellForRow(at: indexPath) as! GoalTableViewCell
        //print(selectedCell.checkBox.isEqual(UIImage(named: "blank-check-box")))
        if (selectedCell.checkBox.image?.isEqual(UIImage(named: "blank-check-box")))! {
            selectedCell.checkBox.image = UIImage(named: "check-box")
            //print("hai")
        } else {
            selectedCell.checkBox.image = UIImage(named: "blank-check-box")
        }
        
        //self.becomeFirstResponder()
    }
}

extension BoardDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = goalTable.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as! GoalTableViewCell

        cell.goalLabel.text = goals[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
