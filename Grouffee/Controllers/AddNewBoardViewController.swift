//
//  AddNewBoardViewController.swift
//  Grouffee
//
//  Created by Aldo Novendi Fadly on 01/12/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

class AddNewBoardViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var boardName: UITextField!
    @IBOutlet weak var durTxt: UITextField!
   
    @IBOutlet weak var desc: UITextView!
    @IBOutlet weak var descPlaceholder: UILabel!
    @IBOutlet weak var topDurPickerMargin: NSLayoutConstraint!
    
    @IBOutlet weak var descLine: UITextField!
    @IBOutlet weak var goalTable: UITableView!
    @IBOutlet weak var goals: UITextField!
    @IBOutlet weak var createBoardBtn: UIButton!
    
    @IBOutlet weak var durPickerView: UIView!
    @IBOutlet weak var pickerContainer: UIView!
    @IBOutlet weak var durPicker: UIPickerView!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let pickerDataSize = 100000
    var selectedHours = 0
    var selectedMinutes = 0
    
    var goalList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        durPicker.dataSource = self
        durPicker.delegate = self
        
        self.goals.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openDurPicker))
        durTxt.addGestureRecognizer(tapGesture)
        
        let hideGesture = UITapGestureRecognizer(target: self, action: #selector(hideDurPicker))
        durPickerView.addGestureRecognizer(hideGesture)
        topDurPickerMargin.constant = view.frame.height
        
        let descDidTap = UITapGestureRecognizer(target: self, action: #selector(hidePlaceholder))
        desc.addGestureRecognizer(descDidTap)
        
        durPickerView.alpha = 0.0
        descLine.isEnabled = false
        
        createBoardBtn.isEnabled = false
        
        //goalTable.dataSource = self
        //createBoardBtn.isEnabled = false
        
        //addKeyboardViewAdjustment()
    }
    
    @IBAction func validateBoardName(_ sender: Any) {
        if durTxt.text != "" {
            if boardName.text != "" {
                createBoardBtn.isEnabled = true
            } else {
                createBoardBtn.isEnabled = false
            }
        }
    }
    
    
    @objc
    func hidePlaceholder(){
        desc.becomeFirstResponder()
        descPlaceholder.isHidden = true
    }
    
    @IBAction func doneBtnDidTap(_ sender: Any) {
        hideDurPicker()
    }
    
    @IBAction func resetBtnDidTap(_ sender: Any) {
        durPicker.selectRow(pickerDataSize / 2 - 8, inComponent: 0, animated: true)
        durPicker.selectRow(pickerDataSize / 2 - 20, inComponent: 1, animated: true)
        showSelectedDataToTextField()
    }
    
    @objc
    func openDurPicker(){
        self.becomeFirstResponder()
        UIView.animate(withDuration: 0.3) {
            self.durPickerView.alpha = 1
            self.durPicker.alpha = 1
            self.pickerContainer.frame = CGRect(x: 0, y: self.durPickerView.bounds.height - self.pickerContainer.bounds.height, width: self.pickerContainer.bounds.width, height: self.pickerContainer.bounds.height)
        }
        self.durPicker.selectRow((pickerDataSize / 2) - 8 + selectedHours, inComponent: 0, animated: false)
        self.durPicker.selectRow((pickerDataSize / 2) - 20 + selectedMinutes, inComponent: 1, animated: false)
    }
    
    @objc
    func hideDurPicker(){
        UIView.animate(withDuration: 0.2) {
            self.durPickerView.alpha = 0
            self.pickerContainer.frame = CGRect(x: 0, y: self.durPickerView.bounds.height, width: self.pickerContainer.bounds.width, height: self.pickerContainer.bounds.height)
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSize
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String(row % 24)
        } else {
            return String(row % 60)
        }
        
    }
    
    @IBAction func cancelDidTap(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createBoardDidTap(_ sender: Any)
    {
    //    appDelegate.room.addBoard(boardName: boardName.text!, duration: selectedHours*3600 + selectedMinutes*60)
        appDelegate.room.boards.append(Board(boardName: boardName.text!, duration: selectedHours*3600 + selectedMinutes*60, desc: desc.text, goals: goalList, boardId: 0))
        
        appDelegate.broadcastRoom()
        dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            if durPicker.selectedRow(inComponent: 0) % 24 == 1 {
                hoursLabel.text = "hour"
            } else {
                hoursLabel.text = "hours"
            }
            let position = pickerDataSize / 2 + row - 8
            pickerView.selectRow(position, inComponent: 0, animated: false)
        } else {
            let position = pickerDataSize / 2 + row - 20
            pickerView.selectRow(position, inComponent: 1, animated: false)
        }
        showSelectedDataToTextField()
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 150
    }
    
    func showSelectedDataToTextField(){
        selectedHours = durPicker.selectedRow(inComponent: 0) % 24
        selectedMinutes = durPicker.selectedRow(inComponent: 1) % 60
        
        var minLabel = "minutes"
        
        if selectedMinutes % 60 == 1 {
            minLabel = "minute"
        } else {
            minLabel = "minutes"
        }
        
        if boardName.text != "" {
            createBoardBtn.isEnabled = true
        }
        
        if selectedHours == 0 && selectedMinutes == 0 {
            durTxt.text = ""
            createBoardBtn.isEnabled = false
        } else if selectedHours == 0 {
            durTxt.text = "\(String(selectedMinutes)) \(minLabel)"
            
        } else if selectedMinutes % 60 == 0{
            durTxt.text = "\(String(selectedHours)) \((hoursLabel.text)!)"
            
        } else {
            durTxt.text = "\(String(selectedHours)) \((hoursLabel.text)!) \(String(selectedMinutes)) \(minLabel)"
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goalList.append(goals.text!)
        goals.text = ""
        goalTable.reloadData()
        let indexPath = IndexPath(row: goalList.count-1, section: 0)
       
        goalTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
        return false
    }
    
    //textField code
    override func viewDidLayoutSubviews() {
        customizeTextField(textField: boardName, placeHolder: "Board name")
        customizeTextField(textField: durTxt, placeHolder: "Duration")
        customizeTextField(textField: descLine, placeHolder: "")
        customizeTextField(textField: goals, placeHolder: "Goals")
    }
    
    func customizeTextField(textField: UITextField, placeHolder: String){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
        textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
        
        let leftView: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: 40, height: 26))
        leftView.backgroundColor = UIColor.clear
        
        textField.leftView = leftView
        textField.leftViewMode = .always
        textField.contentVerticalAlignment = .center
    }
    
}

extension AddNewBoardViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = goalTable.dequeueReusableCell(withIdentifier: "goalCell", for: indexPath) as! GoalTableViewCell
        
        //print(goalList[0])
        cell.goalLabel.text = goalList[indexPath.row]
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
