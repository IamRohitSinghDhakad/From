//
//  ActivityViewController.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 14/07/24.
//

import UIKit

class ActivityViewController: UIViewController {
    
    @IBOutlet weak var btnNotification: UIButton!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnSuperLike: UIButton!
    @IBOutlet weak var tblVw: UITableView!
    
    
    var arrNotification = [ActivityNotificationModel]()
    var arrSuperLikeNotification = [ActivitySuperLikeModel]()
    var arrLikesNotification = [ActivityLikesModel]()
    
    var currentDisplayData: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.call_WsGetActivity()
    }
    
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    
    @IBAction func btnOnNotification(_ sender: Any) {
        self.currentDisplayData = arrNotification
        self.tblVw.reloadData()
    }
    
    @IBAction func btnOnSuperNotification(_ sender: Any) {
        self.currentDisplayData = arrSuperLikeNotification
        self.tblVw.reloadData()
    }
    @IBAction func btnOnLike(_ sender: Any) {
        self.currentDisplayData = arrLikesNotification
        self.tblVw.reloadData()
    }
}


extension ActivityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDisplayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
        
        if currentDisplayData[indexPath.row] is ActivityNotificationModel {
            let obj = self.arrNotification[indexPath.row]
            cell.lblTitle.text = obj.message
            cell.lblTimeAgo.text = obj.strTimeAgo
            
            let imageUrl  = obj.strUserImage
            if imageUrl != "" {
                let url = URL(string: imageUrl)
                cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }else{
                cell.imgVwUser.image = #imageLiteral(resourceName: "image")
            }
            
            // cell.configure(with: data)
        } else if currentDisplayData[indexPath.row] is ActivitySuperLikeModel {
            let obj = self.arrSuperLikeNotification[indexPath.row]
            cell.lblTitle.text = obj.message
            cell.lblTimeAgo.text = obj.strTimeAgo
            let imageUrl  = obj.strUserImage
            if imageUrl != "" {
                let url = URL(string: imageUrl)
                cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }else{
                cell.imgVwUser.image = #imageLiteral(resourceName: "image")
            }
            //cell.configure(with: data)
        } else if currentDisplayData[indexPath.row] is ActivityLikesModel {
            let obj = self.arrLikesNotification[indexPath.row]
            cell.lblTitle.text = obj.message
            cell.lblTimeAgo.text = obj.strTimeAgo
            let imageUrl  = obj.strUserImage
            if imageUrl != "" {
                let url = URL(string: imageUrl)
                cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }else{
                cell.imgVwUser.image = #imageLiteral(resourceName: "image")
            }
            //cell.configure(with: data)
        }
        
        return cell
    }
}

extension ActivityViewController {
    
    func call_WsGetActivity() {
        
        guard objWebServiceManager.isNetworkAvailable() else {
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        let dicrParam: [String: Any] = ["user_id": objAppShareData.UserDetail.strUser_id]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetActivity, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { response in
            objWebServiceManager.hideIndicator()
            
            let status = response["status"] as? Int
            let message = response["message"] as? String ?? "Unknown error"
            
            if status == MessageConstant.k_StatusCode {
                if let userDetails = response["result"] as? [String: Any] {
                    let activityModel = ActivityModel(from: userDetails)
                    self.arrNotification = activityModel.arrNotification
                    self.arrSuperLikeNotification = activityModel.arrSuperLike
                    self.arrLikesNotification = activityModel.arrLikes
                    self.currentDisplayData = self.arrNotification
                    self.updateBackgroundText()
                    self.tblVw.reloadData()
                    
                } else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            } else {
                let errorMsg = response["result"] as? String ?? message
                objAlert.showAlert(message: errorMsg, title: "", controller: self)
            }
        } failure: { error in
            objWebServiceManager.hideIndicator()
        }
    }
    
    private func updateBackgroundText() {
           if arrNotification.isEmpty && arrSuperLikeNotification.isEmpty && arrLikesNotification.isEmpty {
               self.tblVw.displayBackgroundText(text: "No Data Found")
           } else {
               self.tblVw.displayBackgroundText(text: "")
           }
       }
}
