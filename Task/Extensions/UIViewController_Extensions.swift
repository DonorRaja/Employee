//
//  UIViewController_Extensions.swift
//  Task
//
//  Created by Rajesh Kannan M on 12/4/17.
//  Copyright © 2017 Guest User. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    //Global alert
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
