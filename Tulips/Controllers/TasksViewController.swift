//
//  TasksViewController.swift
//  Tulips
//
//  Created by Jura on 16.03.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import UIKit
import Firebase

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.tableView.tableFooterView = UIView()
       guard let currentUser = Auth.auth().currentUser else { return }
       userInfo = UserInfo(user: currentUser)
       ref = Database.database().reference(withPath: "users").child(String(userInfo.uid)).child("tasks")

    }
    
    override  func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        ref?.observe(.value, with: { [weak self] (snapshot) in
            var _tasks = Array<Task>()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            tasks = _tasks
            self?.tableView.reloadData()
        })
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CastomTableViewCell

        let dateTask = tasks[indexPath.row].dateTask
        let nameTask = tasks[indexPath.row].nameUser
        let flowersInfoTask = tasks[indexPath.row].flowersInfo
        let payInfoTask = tasks[indexPath.row].payInfo
        let addressTask = tasks[indexPath.row].address
        let taskPhone = tasks[indexPath.row].phone


        cell.dateTaskLabel?.text = dateTask
        cell.nameUserLabel?.text = nameTask
        cell.flowersInfoLabel?.text = flowersInfoTask
        cell.payInfoLabel?.text = payInfoTask
        cell.addressLabel?.text = addressTask
        cell.phoneLabel?.text = taskPhone
        return cell
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let task = tasks[indexPath.row]
            let newTaskVC = segue.destination as! NewTaskViewController
            newTaskVC.currentTask = task
        }
    }
   
//    @IBAction func addTapped(_ sender: UIBarButtonItem) { }
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
 
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {}
}
