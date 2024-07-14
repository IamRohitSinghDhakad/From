//
//  ViewController.swift
//  From
//
//  Created by Rohit SIngh Dhakad on 01/07/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var vwLogo: UIView!
    @IBOutlet weak var imgVwAnimate: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwLogo.frame = CGRect(x: self.vwLogo.frame.origin.x, y: UIScreen.main.bounds.size.height/2, width: self.vwLogo.frame.size.width, height: self.vwLogo.frame.size.height)
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Up()
    }
    
    //MARK: - Animation Methods
    
    func Up()  {
        UIView.animate(withDuration: 2.0, delay: 0, options: [.curveLinear], animations: {
            self.vwLogo.frame = CGRect(x: self.vwLogo.frame.origin.x, y: 0, width: self.vwLogo.frame.size.width, height: self.vwLogo.frame.size.height)
          //  self.imgVwAnimation.frame = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
        }) { (finished) in
            if finished {
              //  self.vwLogo.tilt()
                //==============XXXX===============//
                UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                       // HERE
                    self.imgVwAnimate.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5) // Scale your image
                 }) { (finished) in
                     UIView.animate(withDuration: 2, animations: {
                      self.imgVwAnimate.transform = CGAffineTransform.identity // undo in 1 seconds
                   })
                }
                //=============XXXX===============//
                // Repeat animation to bottom to top
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.goToNextController()
                }
            }
        }

    }
    
    //MARK: - Redirection Methods
    func goToNextController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if AppSharedData.sharedObject().isLoggedIn {
            let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            appDelegate.window?.rootViewController = navController
        }
        else {
            let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "WelcomeViewController") as? WelcomeViewController)!
            let navController = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            appDelegate.window?.rootViewController = navController
        }
    }
}

