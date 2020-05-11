//
//  TasksModel.swift
//  Tulips
//
//  Created by Jura on 17.03.2020.
//  Copyright © 2020 Jura. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

struct Task {
    
    let ref: DatabaseReference?
    let userId: String?
    let dateTask: String?
    let nameUser: String?
    let flowersInfo: String?
    let payInfo: String?
    let address: String?
    let phone: String?
    
    
    init(userId: String, dateTask: String,
    nameUser: String, flowersInfo: String,
    payInfo: String, address: String, phone: String) {
        self.userId = userId
        self.dateTask = dateTask
        self.nameUser = nameUser
        self.flowersInfo = flowersInfo
        self.payInfo = payInfo
        self.address = address
        self.phone = phone
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        userId = snapshotValue["userId"] as? String
        dateTask = snapshotValue["dateTask"] as? String
        nameUser = snapshotValue["nameUser"] as? String
        flowersInfo = snapshotValue["flowersInfo"] as? String
        payInfo = snapshotValue["payInfo"] as? String
        address = snapshotValue["address"] as? String
        phone = snapshotValue["phone"] as? String
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["dateTask": dateTask,
                "nameUser": nameUser,
                "flowersInfo": flowersInfo,
                "payInfo": payInfo,
                "address": address,
                "phone": phone,
                "userId": userId]
    } 
}

