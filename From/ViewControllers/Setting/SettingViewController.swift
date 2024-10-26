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
        }else if indexPath.row == 4{
            // The URL to your app on the App Store
            let appURL = URL(string: "https://apps.apple.com/us/app/your-app-name/idYOUR_APP_ID")!
            let items: [Any] = ["Check out this From cool app!", appURL]
            // Initialize the activity view controller with the items you want to share
            let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            // Exclude some activity types from the list
            activityViewController.excludedActivityTypes = [
                .addToReadingList,
                .saveToCameraRoll
            ]
            // Present the view controller
            present(activityViewController, animated: true, completion: nil)
        
    }else if indexPath.row == 5{
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
        vc.isComingFrom = self.arrMenu[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }else if indexPath.row == 6{
        objAlert.showAlertCallBack(alertLeftBtn: "Yes", alertRightBtn: "No", title: "Delete Account?", message: "Are you sure you want to delete account?\n this action will erase all your data", controller: self) {
            self.call_DeleteUser()
        }
    }
    
}

    func call_DeleteUser(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        var url = ""
        dicrParam = ["user_id":objAppShareData.UserDetail.strUser_id]as [String:Any]
            
        url = WsUrl.url_delete_user_account
        
        print(dicrParam)
        
        objWebServiceManager.requestPost(strURL: url, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                objAppShareData.signOut()
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

}
