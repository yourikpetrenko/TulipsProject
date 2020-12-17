//
//  NewTaskViewController.swift
//  Tulips
//
//  Created by Jura on 18.03.2020.
//  Copyright © 2020 Jura. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth

var userInfo: UserInfo!
var ref: DatabaseReference?
var tasks = Array<Task>()
let taskDateID = Date()
let formatter = DateFormatter()
var _taskId: String? = "\(Date())"

class NewTaskViewController: UITableViewController  {
    var currentTask: Task?
    let datePicker = UIDatePicker()
    @IBOutlet weak var dateTaskCreate: UITextField?
    @IBOutlet weak var nameUserCreate: UITextField?
    @IBOutlet weak var flowersInfoCreate: UITextView?
    @IBOutlet weak var payInfoCreate: UITextField?
    @IBOutlet weak var addressCreate: UITextField?
    @IBOutlet weak var phoneCreate: UITextField?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupEditScreen()
        datePickerView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
    
    private func setupEditScreen() {
        if currentTask != nil {
            dateTaskCreate?.text = currentTask?.dateTask
            nameUserCreate?.text = currentTask?.nameUser
            flowersInfoCreate?.text = currentTask?.flowersInfo
            payInfoCreate?.text = currentTask?.payInfo
            addressCreate?.text = currentTask?.address
            phoneCreate?.text = currentTask?.phone
            setupNaviBar()
        }
    }
    
    //    castom select task
    private func setupNaviBar() {
        title = "Заказ"
    }
    
    //    MARK: Date Picker
    func datePickerView() {
        dateTaskCreate?.inputView = datePicker
        datePicker.datePickerMode = .dateAndTime
        
        guard let localeID = Locale.preferredLanguages.first else { return }
        datePicker.locale = Locale(identifier: localeID)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: true)
        dateTaskCreate?.inputAccessoryView = toolbar
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    @objc func doneAction() {
        getDateFromPicker()
        view.endEditing(true)
    }
    
    @objc func dateChanged() {
        getDateFromPicker()
    }
    
    func getDateFromPicker() {
        
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateTaskCreate?.text = formatter.string(from: datePicker.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func saveTaskButton(_ sender: UIBarButtonItem) {
        let taskId = formatter.string(from: datePicker.date)
        guard let dateTaskCreate = dateTaskCreate?.text else { return }
        guard let nameUserCreate = nameUserCreate?.text else { return }
        guard let flowersInfoCreate = flowersInfoCreate?.text else { return }
        guard let payInfoCreate = payInfoCreate?.text else { return }
        guard let addressCreate = addressCreate?.text else { return }
        guard let phoneCreate = phoneCreate?.text else { return }
        
        if currentTask != nil {
            
            print(currentTask?.dateTask ?? "")
            ref?.updateChildValues([currentTask?.dateTask ?? "" :
                                    ["dateTask": dateTaskCreate,
                                    "address": addressCreate,
                                    "nameUser": nameUserCreate,
                                    "flowersInfo": flowersInfoCreate,
                                    "payInfo": payInfoCreate,
                                    "phone": phoneCreate,
                                    "userId": userInfo.uid]])
        } else {
            
            let task = Task(userId: userInfo.uid, dateTask: dateTaskCreate, nameUser: nameUserCreate, flowersInfo: flowersInfoCreate, payInfo: payInfoCreate, address: addressCreate, phone: phoneCreate)
            let taskRef = ref?.child(taskId.lowercased())
            taskRef?.setValue(task.convertToDictionary())
        }
        navigationController?.popViewController(animated: true)
        dismiss(animated: true)
        
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true)
    }
}

// MARK: Text field delegate
extension NewTaskViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

