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
    }
    
    @IBAction func registerTapped(_ sender: UIButton) { }
    @IBAction func resetPassword(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: "email@email") { error in
            let forgotPasswordAlert = UIAlertController(title: "Забыли пароль?", message: "Введите адрес электронной почты", preferredStyle: .alert)
            forgotPasswordAlert.addTextField { (textField) in
                textField.placeholder = "Введите адрес электронной почты"
            }
            forgotPasswordAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
            forgotPasswordAlert.addAction(UIAlertAction(title: "Сбросить пароль", style: .default, handler: { (action) in
                let resetEmail = forgotPasswordAlert.textFields?.first?.text
                Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                    if error != nil{
                        let resetFailedAlert = UIAlertController(title: "Сброс не выполнен", message: "Ошибка: не введен адрес", preferredStyle: .alert)
                        resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetFailedAlert, animated: true, completion: nil)
                    }else {
                        let resetEmailSentAlert = UIAlertController(title: "Пароль сброшен", message: "Проверьте почту", preferredStyle: .alert)
                        resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(resetEmailSentAlert, animated: true, completion: nil)
                    }
                })
            }))
            self.present(forgotPasswordAlert, animated: true, completion: nil)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



