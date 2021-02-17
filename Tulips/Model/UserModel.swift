//
//  UserModel.swift
//  Tulips
//
//  Created by Jura on 20.03.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

struct UserInfo {
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
