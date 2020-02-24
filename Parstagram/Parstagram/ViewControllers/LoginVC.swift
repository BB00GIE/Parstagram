//
//  LoginVC.swift
//  Parstagram
//
//  Created by Brandon Elmore on 2/23/20.
//  Copyright © 2020 CodePath. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController {

    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        
        let user = PFUser()
        user.username = userNameField.text
        user.password = passwordField.text
    
        user.signUpInBackground { (success, error) in
            if success {
                self.performSegue(withIdentifier: "Login1", sender: nil)
            }
            else{
                print("Error:\(error?.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func onSignIn(_ sender: Any) {
        
        PFUser.logInWithUsername(inBackground: userNameField.text!, password: passwordField.text!) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "Login1", sender: nil)
            }
            else{
                print("Error\(error?.localizedDescription)")
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
