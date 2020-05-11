//
//  ViewController.swift
//  Tulips
//
//  Created by Jura on 16.03.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    let segueIndetefier = "tasksSegue"
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var warnLabel: UILabel!
    @IBOutlet weak var emailTextFild: UITextField!
    @IBOutlet weak var passwordTextFild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "users")
        self.passwordTextFild.delegate = self
        self.emailTextFild.delegate = self
        warnLabel.alpha = 0
        
       
        Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            if user != nil {
                self?.performSegue(withIdentifier: (self?.segueIndetefier)!, sender: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextFild.text = ""
        passwordTextFild.text = ""
    }

    func displayWarningLabel(withText text: String) {
        warnLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,
            options: .curveEaseInOut, animations: { [weak self] in
            self?.warnLabel.alpha = 1
        }) { [weak self] complete in
            self?.warnLabel.alpha = 0
    }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let email = emailTextFild.text, let password = passwordTextFild.text, email != "", password != ""
            else {
             displayWarningLabel(withText: "Неправильно :(")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (user, error) in
            if error != nil {
                self?.displayWarningLabel(withText: "ошибка")
                return
            }
            if user != nil {
                self?.performSegue(withIdentifier: "tasksSegue", sender: nil)
                return
            }
            
            self?.displayWarningLabel(withText: "пользователя не существует")
        }
        
               performSegue(withIdentifier: "tasksSegue", sender: self)
        
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
//        guard let email = emailTextFild.text, let password = passwordTextFild.text, email != "", password != ""
//            else {
//             displayWarningLabel(withText: "Неправильно :(")
//            return
//        }
//
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
//            guard error == nil, user != nil else {
//
//                print(error!.localizedDescription)
//                return
//            }
//
//            let userRef = self?.ref.child((userInfo?.uid)!)
//            userRef?.setValue(["email": userInfo.email])
            
//            if error == nil {
//                if user != nil {
//
//                } else {
//                    print("пользователь не создан")
//                }
//            } else {
//                    print(error!.localizedDescription)
//                }
//            }
        }
}

    extension LoginViewController: UITextFieldDelegate {
        
    //    скрываем клавиатуру по нажатию на Done
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}
  


