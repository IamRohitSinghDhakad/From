//
//  LoginViewController.swift
//  From
//
//  Created by Rohit SIngh Dhakad on 01/07/24.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnLogin(_ sender: Any) {
        
    }
    
    @IBAction func btnOnForgotPassword(_ sender: Any) {
        self.pushVc(viewConterlerId: "ForgotPasswordViewController")
    }
    
    @IBAction func btnOnSignUp(_ sender: Any) {
        self.pushVc(viewConterlerId: "SignUpViewController")
    }
    
}
