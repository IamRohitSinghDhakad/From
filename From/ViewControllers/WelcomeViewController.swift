//
//  WelcomeViewController.swift
//  From
//
//  Created by Rohit SIngh Dhakad on 13/07/24.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var vwBotoom: UIView!
    @IBOutlet weak var vwInstantlyMeet: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.vwInstantlyMeet.isHidden = true
           // self.vwInstantlyMeet.animHide()
            self.vwBotoom.isHidden = false
            self.vwBotoom.roundedCorners(corners: [.topLeft, .topRight], radius: 10)
            self.vwBotoom.animShow()
           
        })
       
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      //  self.vwBotoom.roundedCorners(corners: [.topLeft, .topLeft], radius: 10)
    }
    
    @IBAction func btnOnLogin(_ sender: Any) {
        self.pushVc(viewConterlerId: "LoginViewController")
    }
    
    @IBAction func btnOnSignUp(_ sender: Any) {
        self.pushVc(viewConterlerId: "SignUpViewController")
    }
    
    

}

extension UIView{
    func animShow(){
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseIn],
                       animations: {
                        self.center.y -= self.bounds.height
                        self.layoutIfNeeded()
        }, completion: nil)
        self.isHidden = false
    }
    func animHide(){
        UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear],
                       animations: {
                        self.center.y += self.bounds.height
                        self.layoutIfNeeded()

        },  completion: {(_ completed: Bool) -> Void in
        self.isHidden = true
            })
    }
}
