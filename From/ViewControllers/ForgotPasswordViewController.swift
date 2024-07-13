//
//  ForgotPasswordViewController.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 14/07/24.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnResetPassword(_ sender: Any) {
        
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        self.onBackPressed()
    }
   

}
