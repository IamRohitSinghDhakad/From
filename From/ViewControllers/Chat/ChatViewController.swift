//
//  ChatViewController.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 14/07/24.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var tblVwChatLUserList: UITableView!
    
    var arrUsers = [ChatUsersModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.call_WsGetConversation()
        self.tblVwChatLUserList.delegate = self
        self.tblVwChatLUserList.dataSource = self
        // Do any additional setup after loading the view.
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        self.tblVwChatLUserList.addGestureRecognizer(longPress)
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTableViewCell")as! ChatTableViewCell
        
        let obj = self.arrUsers[indexPath.row]
        
        cell.lblName.text = obj.name
        cell.lblLastMsg.text = obj.last_message
        cell.lblTimeAgo.text = obj.time_ago
        
        let imageUrl  = obj.user_image
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            cell.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }else{
            cell.imgVwUser.image = #imageLiteral(resourceName: "image")
        }
        
        return cell
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: self.tblVwChatLUserList)
            if let indexPath = self.tblVwChatLUserList.indexPathForRow(at: touchPoint) {
                print(indexPath)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ChatViewController{
    
    func call_WsGetConversation(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        dicrParam = ["user_id":objAppShareData.UserDetail.strUser_id]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetConversation, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    self.arrUsers.removeAll()
                    for data in user_details{
                        let obj = ChatUsersModel(from: data)
                        self.arrUsers.append(obj)
                    }
                    self.tblVwChatLUserList.reloadData()
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.arrUsers.removeAll()
                    self.tblVwChatLUserList.reloadData()
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
