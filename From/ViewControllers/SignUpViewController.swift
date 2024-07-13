//
//  SignUpViewController.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 14/07/24.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var imgVwMaleCheckBox: UIImageView!
    @IBOutlet weak var imgVwFemaleCheckBox: UIImageView!
    @IBOutlet weak var imgVwTransMaleCheckBox: UIImageView!
    @IBOutlet weak var imgVwTransFemaleCheckBox: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnGoBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnOnSignUp(_ sender: Any) {
        
    }
    
    @IBAction func btnOnGenderSelection(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            print("Male")
        case 2:
            print("FeMale")
        case 3:
            print("Trans Male")
        default:
            print("Trans FeMale")
        }
        
        
    }
    

}
