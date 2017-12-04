//
//  DetailsViewController.swift
//  Task
//
//  Created by Guest User on 01/12/17.
//  Copyright © 2017 Guest User. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    
    //MARK:- Variables
    var Employee : EmployeeDetails!
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
      self.userNameField.text = Employee.userName
      self.ageField.text = String(describing: Employee.age!)
        // Do any additional setup after loading the view.
        self.ageField.isUserInteractionEnabled = false
        self.userNameField.isUserInteractionEnabled = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Outlet Actions
    @IBAction func updateAction(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        let name = self.userNameField.text
        let age = self.ageField.text
        if name != "", age != "" {
            self.employeeUpdateRequest(id: Employee.id!, name: name!, age: age!)
        } else {
            self.popupAlert(title: Task.Alert.alertTitle, message: Task.Alert.fieldsError, actionTitles: [Task.Alert.okButton], actions: [nil])
        }
    }
    
    @IBAction func nameFieldEditAction(_ sender: UIButton) {
        self.userNameField.isUserInteractionEnabled = true
        self.userNameField.becomeFirstResponder()
    }
    
    @IBAction func ageFieldEditAction(_ sender: UIButton) {
        self.ageField.isUserInteractionEnabled = true
        self.ageField.becomeFirstResponder()
    }
    
    //MARK:- Other functions
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    //MARK: Update employee API
    func employeeUpdateRequest(id:String,name:String,age:String){
        let urlString = "\(id)" + Task.SecondaryURL.getTypeURL
        let parameters = [Task.Parameters.age:Int(age)!,
                          Task.Parameters.name:name] as [String : AnyObject]
        Utilities.customActivityIndicatory(self.view,startAnimate:true)
        if Reachability.isConnectedToNetwork(){
            NetworkManager.put(request: NetworkManager.clientURLRequest(path: urlString, params: parameters)) { (success, object) -> () in
                DispatchQueue.main.async {
                    Utilities.customActivityIndicatory(self.view,startAnimate:false)
                    if success {
                        self.popupAlert(title: Task.Alert.alertTitle, message: Task.Alert.updateMessage, actionTitles: [Task.Alert.okButton], actions: [nil])
                    } else {
                        var message = ""
                        if let object = object, let passedMessage = object["message"] as? String {
                            message = passedMessage
                        }
                        self.popupAlert(title: Task.Alert.alertTitle, message: message, actionTitles: [Task.Alert.okButton], actions: [nil])
                    }
                }
            }
        }else{
            Utilities.customActivityIndicatory(self.view,startAnimate:false)
                self.popupAlert(title: Task.Alert.alertTitle, message: Task.Alert.netWorkError, actionTitles: [Task.Alert.okButton], actions: [nil])
            }
    }
       
    
}
