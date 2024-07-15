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
    @IBOutlet weak var imgVwEULA: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOnLogin(_ sender: Any) {
        self.call_WsLogin()
    }
    
    @IBAction func btnOnForgotPassword(_ sender: Any) {
        self.pushVc(viewConterlerId: "ForgotPasswordViewController")
    }
    
    @IBAction func btnOnSignUp(_ sender: Any) {
        self.pushVc(viewConterlerId: "SignUpViewController")
    }
    
    @IBAction func btnOnGoToEULA(_ sender: Any) {
    }
    
}


//MARK: Login API

extension LoginViewController{
    
    
    func call_WsLogin(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        dicrParam = ["username":self.tfEmail.text!,
                     "password":self.tfPassword.text!,
                     "device_type":"iOS",
                     "device_token":objAppShareData.strFirebaseToken]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_Login, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                    objAppShareData.fetchUserInfoFromAppshareData()
                    self.makeRootControllerHome()
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    objAlert.showAlert(message: msgg, title: "", controller: self)
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
                
                
            }
            
            
        } failure: { (Error) in
            //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    func makeRootControllerHome(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
}
