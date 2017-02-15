//
//  ViewController.swift
//  AC3.2-Final
//
//  Created by Jason Gresh on 2/14/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var meatlyLogo: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
  
    var databaseObserver:FIRDatabaseHandle?
    var signInUser: FIRUser?
    var links = [Link]()
    var propertyAnimator: UIViewPropertyAnimator?
    var databaseReference: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Unit6Final-staGram"
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let feedVC = FeedTableViewController()
        if FIRAuth.auth()?.currentUser != nil {
            //            FIRAuth.auth()?.currentUser?.uid.
            self.navigationController?.pushViewController(feedVC, animated: true)
            
        }

        
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
        default:
            break
        }
        return true
        
    }

    @IBAction func didTapLogin(_ sender: UIButton) {
        
        if let email = emailTextField.text,
            let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                
                
                if user != nil {
                    let newViewController = FeedTableViewController()
                    if let tabVC =  self.navigationController {
                        tabVC.show(newViewController, sender: nil)
                    }
                }
            })
        }
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func didTapRegister(_ sender: UIButton) {

            if let email = emailTextField.text,
                let password = passwordTextField.text {
                FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
                    if error != nil {
                        print (error!)
                        return
                    }
                    guard let uid = user?.uid else {return}
                    let values = ["email": email]
                    
                    self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                    self.dismiss(animated: true, completion: nil)
                })
            }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        
        let userReference = self.databaseReference.child(uid)
        userReference.updateChildValues(values)
        
        let newViewController = FeedTableViewController()
        if let tabVC =  self.navigationController {
            tabVC.show(newViewController, sender: nil)
        }
        
    }


}

