//
//  MyProfileViewController.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 14/07/24.
//

import UIKit

class MyProfileViewController: UIViewController {
    
    @IBOutlet weak var vwBio: UIView!
    @IBOutlet weak var cvIMAGES: UICollectionView!
    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblNameAge: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var vwSocialAccounts: UIView!
    @IBOutlet weak var vwForPaidAccount: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var vwTelegram: UIView!
    @IBOutlet weak var vwTwitter: UIView!
    @IBOutlet weak var vwFacebook: UIView!
    @IBOutlet weak var vwInstagram: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var vwAddImages: UIView!
    @IBOutlet var subVw: UIView!
    @IBOutlet weak var vwNoPhotosFound: UIView!
    @IBOutlet weak var imgVwOnSubVw: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    
    var arrUserImages = [GetUsersImagesModel]()
    var objUser = UserModel(from: [:])
    var strID = ""
    var isComingFrom = ""
    var pickedImage = UIImage()
    var strImageID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cvIMAGES.delegate = self
        self.cvIMAGES.dataSource = self
        
//        self.vwSocialAccounts.isHidden = true
//        self.vwForPaidAccount.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vwNoPhotosFound.isHidden = true
        if isComingFrom == ""{
            self.vwForPaidAccount.isHidden = false
            self.btnEdit.isHidden = false
            self.vwAddImages.isHidden = false
            self.call_WsGetProfile(strID: objAppShareData.UserDetail.strUser_id)
            self.call_WsGetUserImages(strID: objAppShareData.UserDetail.strUser_id)
            self.btnDelete.isHidden = false
        }else{
            self.vwAddImages.isHidden = true
            self.vwForPaidAccount.isHidden = true
            self.btnEdit.isHidden = true
            self.call_WsGetProfile(strID: strID)
            self.call_WsGetUserImages(strID: strID)
            self.btnDelete.isHidden = true
        }
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        self.addSubviewWithAnimation(isAdd: false)
        self.call_WsDeleteImage(strImageID: self.strImageID)
    }
    @IBAction func btnHideSubVw(_ sender: Any) {
        self.addSubviewWithAnimation(isAdd: false)
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        if isComingFrom == ""{
            self.sideMenuController?.revealMenu()
        }else{
            self.onBackPressed()
        }
        
    }
    
    @IBAction func btnOnEdit(_ sender: Any) {
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "EditProfileViewController")as! EditProfileViewController
        vc.objUserData = self.objUser
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnOnApplyForVerifiedProfile(_ sender: Any) {
        
    }
    @IBAction func btnOnAddImage(_ sender: Any) {
        MediaPicker.shared.pickMedia(from: self) { Image in
            if Image != nil{
                self.pickedImage = Image ?? UIImage()
                self.callWebserviceForAddUserImage()
            }else{
                print(Image as Any)
            }
            
        }
    }
}

extension MyProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrUserImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesCollectionViewCell", for: indexPath)as! ImagesCollectionViewCell
        
        
        let obj = self.arrUserImages[indexPath.row]
        
        //Set User Image on Swipe view
        let imageUrl  = obj.image
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            cell.imgVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }else{
            cell.imgVw.image = #imageLiteral(resourceName: "logo")
        }
        
//        if indexPath.row == self.strSelectedIndex{
//            cell.vwOuter.borderColor = UIColor.red
//        }else{
//            cell.vwOuter.borderColor = UIColor.white
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let obj = self.arrUserImages[indexPath.row]
        
        let imageUrl  = obj.image
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            self.imgVwOnSubVw.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }else{
            self.imgVwOnSubVw.image = #imageLiteral(resourceName: "logo")
        }
        self.strImageID = obj.strImageId ?? ""
        self.addSubviewWithAnimation(isAdd: true)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = collectionView.bounds.width/3.0
        let yourHeight = yourWidth

        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}


extension MyProfileViewController {
    func call_WsGetProfile(strID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        dicrParam = ["user_id":strID]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getUserProfile, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                   
                    self.objUser = UserModel(from: user_details)
                    
                    self.lblEmail.text = self.objUser.strEmail
                    self.lblAddress.text = self.objUser.address
                    self.lblNameAge.text = "\(self.objUser.name), \(self.objUser.strAge)"
                    if self.objUser.strBio == ""{
                        self.vwBio.isHidden = true
                    }else{
                        self.vwBio.isHidden = false
                        self.lblDescription.text = self.objUser.strBio
                    }
                    
                    if self.objUser.instagram == ""{
                        self.vwInstagram.isHidden = true
                    }else{
                        self.vwInstagram.isHidden = false
                    }
                    
                    if self.objUser.facebook == ""{
                        self.vwFacebook.isHidden = true
                    }else{
                        self.vwFacebook.isHidden = false
                    }
                    
                    if self.objUser.twitter == ""{
                        self.vwTwitter.isHidden = true
                    }else{
                        self.vwTwitter.isHidden = false
                    }
                    
                    if self.objUser.telegram == ""{
                        self.vwTelegram.isHidden = true
                    }else{
                        self.vwTelegram.isHidden = false
                    }
                    
                    if self.objUser.facebook == "" && self.objUser.twitter == "" && self.objUser.instagram == "" && self.objUser.telegram == ""{
                        self.vwSocialAccounts.isHidden = true
                    }else{
                        self.vwSocialAccounts.isHidden = false
                    }
                    
                    if self.objUser.strBio == ""{
                        self.vwBio.isHidden = true
                    }else{
                        self.vwBio.isHidden = false
                    }
                    
                    
                    
                    //Set User Image on Swipe view
                    let imageUrl  = self.objUser.user_image
                    if imageUrl != "" {
                        let url = URL(string: imageUrl)
                        self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
                    }else{
                        self.imgVwUser.image = #imageLiteral(resourceName: "Shape 2")
                    }
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
    
    
    func call_WsGetUserImages(strID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        dicrParam = ["user_id":strID]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetUserImages, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    self.arrUserImages.removeAll()
                    for data in user_details{
                        let obj = GetUsersImagesModel(from: data)
                        self.arrUserImages.append(obj)
                    }
                    self.vwNoPhotosFound.isHidden = true
                    self.cvIMAGES.reloadData()
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.arrUserImages.removeAll()
                    self.cvIMAGES.reloadData()
                    self.vwNoPhotosFound.isHidden = false
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
                
                
            }
            
            
        } failure: { (Error) in
            //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    func call_WsDeleteImage(strImageID:String){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        dicrParam = ["image_id":strImageID]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_DeleteImage, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{

                self.call_WsGetUserImages(strID: objAppShareData.UserDetail.strUser_id)
                
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.arrUserImages.removeAll()
                    self.cvIMAGES.reloadData()
                    self.vwNoPhotosFound.isHidden = false
                }else{
                    objAlert.showAlert(message: message ?? "", title: "", controller: self)
                }
                
                
            }
            
            
        } failure: { (Error) in
            //  print(Error)
            objWebServiceManager.hideIndicator()
        }
    }
    
    
    
    func callWebserviceForAddUserImage(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        objWebServiceManager.showIndicator()
        self.view.endEditing(true)
        
        var imageData = [Data]()
        var imgData : Data?
        if self.pickedImage != nil{
            imgData = (self.pickedImage.jpegData(compressionQuality: 0.2))!
        }
        else {
          //  imgData = (self.imgVwUser.image?.jpegData(compressionQuality: 0.2))!
        }
        imageData.append(imgData!)
        
        let imageParam = ["image"]
        
        let dicrParam = [
            "user_id":objAppShareData.UserDetail.strUser_id,
        ]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.uploadMultipartWithImagesData(strURL: WsUrl.url_AddUserImage, params: dicrParam, showIndicator: true, customValidation: "", imageData: imgData, imageToUpload: imageData, imagesParam: imageParam, fileName: "image", mimeType: "image/jpeg") { (response) in
            objWebServiceManager.hideIndicator()
            print(response)
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            
            if status == MessageConstant.k_StatusCode{
                
                self.call_WsGetUserImages(strID: objAppShareData.UserDetail.strUser_id)
                
            }else{
                objWebServiceManager.hideIndicator()
                objAlert.showAlert(message: response["result"] as? String ?? "", title: "Alert", controller: self)
            }
        } failure: { (Error) in
            print(Error)
        }
    }
}


extension MyProfileViewController{
    func addSubviewWithAnimation(isAdd: Bool) {
            if isAdd {
                self.subVw.frame = CGRect(x: 0, y: -(self.view.frame.height), width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(subVw)
                
                UIView.animate(withDuration: 0.3) {
                    self.subVw.frame.origin.y = 0
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.subVw.frame.origin.y = self.view.frame.height
                } completion: { y in
                    self.subVw.removeFromSuperview()
                }
            }
        }
}
