//
//  Constants.swift
//  Task
//
//  Created by Guest User on 01/12/17.
//  Copyright © 2017 Guest User. All rights reserved.
//

import Foundation
import UIKit

struct Task {
    struct Base  {
        static let baseURL = "https://interview-ae670.firebaseio.com/"
    }

    struct SecondaryURL {
        static let getCustomer = "Employees.json"
        static let getTypeURL = ".json"
    }
    
    struct Identifier {
        static let customerCell = "Cell"
    }
    
    struct StoryBord {
        static let detailsView = "detailsView"
    }
    
    struct Parameters {
        static let userName = "User Name"
        static let age = "Age"
        static let name = "Name"
    }
    struct Alert {
        static let alertTitle = "Alert"
        static let alertMessage = "Please enter employee details"
        static let okButton = "OK"
        static let cancelButton = "Cancel"
        static let fieldsError = "Please fill all fields"
        static let netWorkError = "Please check your internet conected or not"
        static let updateMessage = "Updated Successfully"
        static let addMessage = "Added successfully"
        static let deleteMessage = "Are you sure want to delete"
    }
}
