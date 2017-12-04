//
//  ViewController.swift
//  Task
//
//  Created by Guest User on 01/12/17.
//  Copyright © 2017 Guest User. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var customerTableView: UITableView!
    
    //MARK:- Variables
    var employeeRecord = [EmployeeDetails]()
    var activityIndicator = UIActivityIndicatorView()
    //varK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.customerTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getEmployeeDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Outlet Actions
    
    @IBAction func AddRecordButtonAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "", message: Task.Alert.alertMessage, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: Task.Alert.okButton, style: .default, handler: {
            alert -> Void in
            let nameField = alertController.textFields![0] as UITextField
            let ageField = alertController.textFields![1] as UITextField
            self.view.endEditing(true)
            if nameField.text != "", ageField.text != "" {
                self.employeeAddRequest(name:nameField.text!,age:ageField.text!)
            } else {
                self.popupAlert(title: Task.Alert.alertTitle, message: Task.Alert.fieldsError, actionTitles: [Task.Alert.okButton], actions: [nil])
            }
        }))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = Task.Parameters.userName
            textField.textAlignment = .center
            textField.keyboardType = .default
            textField.autocapitalizationType = .words
        })
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = Task.Parameters.age
            textField.textAlignment = .center
            textField.keyboardType = .numberPad
        })
        alertController.addAction(UIAlertAction(title: Task.Alert.cancelButton, style: .cancel, handler: { (action) in
        
        }))
        self.present(alertController, animated: true, completion: nil)
    }



//MARK:- Others Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == Task.StoryBord.detailsView {
        // Setup new view controller
        let destination = segue.destination as? DetailsViewController
        let indexPath = self.customerTableView.indexPathForSelectedRow
        let employee = employeeRecord[(indexPath?.row)!]
        destination?.Employee = employee
    }
}
    
    //MARK: All Employee Details API
    func getEmployeeDetails(){
        Utilities.customActivityIndicatory(self.view,startAnimate:true)
        let urlString = Task.SecondaryURL.getCustomer
        if Reachability.isConnectedToNetwork() {
            NetworkManager.get(request: NetworkManager.clientURLRequest(path: urlString, params: nil)) { (success, object) -> () in
                DispatchQueue.main.async {
                    Utilities.customActivityIndicatory(self.view,startAnimate:false)
                    if success {
                        if let empDict = object as? [String: AnyObject] {
                            let key = empDict.keys
                            self.employeeRecord.removeAll()
                            for keyValue in key {
                                
                                if let d = empDict[keyValue] as? [String:AnyObject]{
                                    let name = d["Name"] as? String
                                    let age = d["Age"] as? Int
                                    let empRecd = EmployeeDetails(name: name!, age: age!, id:keyValue )
                                    self.employeeRecord.append(empRecd)
                                }
                            }
                            self.customerTableView.reloadData()
                            // access nested dictionary values by key
                        }
                        
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
    
    //MARK: Add Employee API
    func employeeAddRequest(name:String,age:String){
        let urlString = Task.SecondaryURL.getCustomer
        let parameters = [Task.Parameters.age:Int(age)!,
                          Task.Parameters.name:name] as [String : AnyObject]
        Utilities.customActivityIndicatory(self.view,startAnimate:true)
        if Reachability.isConnectedToNetwork(){
            NetworkManager.post(request: NetworkManager.clientURLRequest(path: urlString, params: parameters as Dictionary<String, AnyObject>)) { (success, object) -> () in
                DispatchQueue.main.async {
                    Utilities.customActivityIndicatory(self.view,startAnimate:false)
                    if success {
                        if let object = object, let id = object["name"] as? String {
                            self.popupAlert(title: Task.Alert.alertTitle, message: Task.Alert.addMessage, actionTitles: [Task.Alert.okButton], actions:[ { (action) in
                                let empRecord = EmployeeDetails(name: name, age: Int(age)!, id: id)
                                self.employeeRecord.append(empRecord)
                                self.customerTableView.reloadData()
                            }])
                        }
                        
                    } else {
                        var message = "there was an error"
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
    
    //MARK: Delete Employee API
    func employeeDeleteRequest(id:String,indexPath:IndexPath){
        let urlString = "\(id)" + Task.SecondaryURL.getTypeURL
        Utilities.customActivityIndicatory(self.view,startAnimate:true)
        if Reachability.isConnectedToNetwork(){
            NetworkManager.delete(request: NetworkManager.clientURLRequest(path: urlString, params: nil)) { (success, object) -> () in
                DispatchQueue.main.async {
                    Utilities.customActivityIndicatory(self.view,startAnimate:false)
                    if success {
                        self.employeeRecord.remove(at: indexPath.row)
                        self.customerTableView.deleteRows(at: [indexPath], with: .automatic)
                    } else {
                        var message = ""
                        if let object = object, let passedMessage = object["message"] as? String {
                            message = passedMessage
                        }
                        self.popupAlert(title: Task.Alert.alertTitle, message: message, actionTitles: [Task.Alert.okButton], actions: [nil])
                    }
                }
            }
        }else {
            Utilities.customActivityIndicatory(self.view,startAnimate:false)
            self.popupAlert(title: Task.Alert.alertTitle, message: Task.Alert.netWorkError, actionTitles: [Task.Alert.okButton], actions: [nil])
        }
    }
    
}


//MARK:- Tableview Delegates and Datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employeeRecord.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = self.customerTableView.dequeueReusableCell(withIdentifier: Task.Identifier.customerCell, for: indexPath) as! CustomerTableViewCell
        let empDetails = employeeRecord[indexPath.row]
        cell.userName.text = empDetails.userName
        cell.age.text = "\(empDetails.age!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Task.StoryBord.detailsView, sender: self)
        self.customerTableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.popupAlert(title: Task.Alert.alertTitle, message: Task.Alert.deleteMessage, actionTitles: [Task.Alert.cancelButton,Task.Alert.okButton], actions: [nil,{action in
                let empDetails = self.employeeRecord[indexPath.row]
                self.employeeDeleteRequest(id: empDetails.id!,indexPath:indexPath)
                }])
            
        }
    }
}

