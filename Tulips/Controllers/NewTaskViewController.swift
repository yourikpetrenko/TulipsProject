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
let formatter = DateFormatter()

class NewTaskViewController: UITableViewController  {
    var currentTask: Task?
    let datePicker = UIDatePicker()
    @IBOutlet weak var dateTaskCreate: UITextField?
    @IBOutlet weak var nameUserCreate: UITextField?
    @IBOutlet weak var flowersInfoCreate: UITextView?
    @IBOutlet weak var payInfoCreate: UITextField?
    @IBOutlet weak var addressCreate: UITextField?
    @IBOutlet weak var phoneCreate: UITextField?
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupEditScreen()
        datePickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let currentUser = Auth.auth().currentUser else { return }
        userInfo = UserInfo(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(userInfo.uid)).child("tasks")
        observingDateTextField()
        saveButtonIsHidden()
        self.tableView.reloadData()
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
    private func datePickerView() {
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        if #available(iOS 14.0, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        
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
        saveButton.isEnabled = true
        view.endEditing(true)
    }
    
    @objc func dateChanged() {
        getDateFromPicker()
    }
    
    private func getDateFromPicker() {
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        dateTaskCreate?.text = formatter.string(from: datePicker.date)
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
            let task = Task(userId: userInfo.uid,
                            dateTask: dateTaskCreate,
                            nameUser: nameUserCreate,
                            flowersInfo: flowersInfoCreate,
                            payInfo: payInfoCreate,
                            address: addressCreate,
                            phone: phoneCreate)
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
    
    private func observingDateTextField() {
        saveButton.isEnabled = false
        self.dateTaskCreate?.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    @objc private func textFieldChanged() {
        if dateTaskCreate?.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    func saveButtonIsHidden() {
        if currentTask != nil {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

