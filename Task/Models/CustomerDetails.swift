//
//  CustomerDetails.swift
//  Task
//
//  Created by Guest User on 01/12/17.
//  Copyright © 2017 Guest User. All rights reserved.
//

import Foundation
import UIKit


class EmployeeDetails {
    let userName: String?
    let age: Int?
    let id: String?
    
    init(name: String, age: Int, id: String) {
        self.userName = name
        self.age = age
        self.id = id
    }
}
