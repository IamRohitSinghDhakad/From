//
//  SettingViewController.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 14/07/24.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var tblVw: UITableView!
    
    var arrMenu = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.arrMenu = ["Notifications", "Privacy Policy", "Help center", "About Us", "Share App", "Terms and Conditions", "Delete Account"]
        
        let nib = UINib(nibName: "SettingTableViewCell", bundle: nil)
        self.tblVw.register(nib, forCellReuseIdentifier: "SettingTableViewCell")
    }
    
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell")as! SettingTableViewCell
        
        if indexPath.row == 0{
            cell.imgVw.isHidden = false
        }else{
            cell.imgVw.isHidden = true
        }
        
        cell.lblTitle.text = self.arrMenu[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
            vc.isComingFrom = self.arrMenu[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 2{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
            vc.isComingFrom = self.arrMenu[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 3{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
            vc.isComingFrom = self.arrMenu[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 5{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
            vc.isComingFrom = self.arrMenu[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
}
