//
//  MyProfileViewController.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 14/07/24.
//

import UIKit

class MyProfileViewController: UIViewController {

    @IBOutlet weak var cvIMAGES: UICollectionView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblNameAge: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnOnEdit(_ sender: Any) {
    }
    
    @IBAction func btnOnApplyForVerifiedProfile(_ sender: Any) {
    }
    @IBAction func btnOnAddImage(_ sender: Any) {
    }
}
