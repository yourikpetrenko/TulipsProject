//
//  RegisterViewController.swift
//  Tulips
//
//  Created by Jura on 02.05.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTFReg: UITextField!
    @IBOutlet weak var passTFReg: UITextField!
    @IBOutlet weak var errorRegLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorRegLabel.text = ""
        
    }
    func displayWarningLabel(withText text: String) {
        errorRegLabel.text = text
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,
                       options: .curveEaseInOut, animations: { [weak self] in
                        self?.errorRegLabel.alpha = 1
                       }) { [weak self] complete in
            self?.errorRegLabel.alpha = 0
        }
    }
    
    
    @IBAction func regPushAction(_ sender: UIButton) {
        guard let email = emailTFReg.text, let password = passTFReg.text, email != "", password != ""
        else {
            displayWarningLabel(withText: "Неправильно :(")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            guard error == nil, user != nil else {
                print(error!.localizedDescription)
                return
            }
            
            let userRef = ref?.child((userInfo?.uid)!)
            userRef?.setValue(["email": userInfo.email])
            
            if error == nil {

                if user != nil {
                    
                } else {
                    print("пользователь не создан")
                }
            } else {
                print(error!.localizedDescription)
            }
            self.performSegue(withIdentifier: "taskSegueSecond", sender: self)
        }
    }
}
