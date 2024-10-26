//
//  HomeViewController.swift
//  From
//
//  Created by Rohit SIngh Dhakad on 14/07/24.
//

import UIKit
import TinderSwipeView
import CoreLocation
import SDWebImage
import iOSDropDown


class HomeViewController: UIViewController {
    
    private var swipeView: TinderSwipeView<UserModel>!{
        didSet{
            self.swipeView.delegate = self
        }
    }
    
    @IBOutlet weak var noRecordFoundView: UIView!
    @IBOutlet weak var ageSlider: UISlider!
    @IBOutlet weak var lblAgeFilter: UILabel!
    @IBOutlet weak var tfGenderFilter: DropDown!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var lblKMDistanceFilter: UILabel!
    @IBOutlet weak var vwFilter: UIView!
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vwNaviagtion: UIView!{
        didSet{
            self.vwNaviagtion.alpha = 1.0
        }
    }
    
    let locationManager = CLLocationManager()
    var sourceLatitude = ""
    var sourceLongitude = ""
    var age = ""
    var gender = ""
    var distance = ""
    var arrUserModal = [UserModel]()
    var arrIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vwFilter.isHidden = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        self.noRecordFoundView.isHidden = true
        self.tfGenderFilter.delegate = self
        self.tfGenderFilter.optionArray = ["Male", "Female"]
        
        self.tfGenderFilter.didSelect { selectedText, index, id in
            self.tfGenderFilter.text = selectedText
            self.gender = selectedText
        }
        
        call_WsGetUsers()
    }
    
    @IBAction func distanceOnFilter(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        self.distance = "\(currentValue)"
        self.lblKMDistanceFilter.text = "\(currentValue) KM"
    }
    @IBAction func ageOnFiler(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        self.age = "\(currentValue)"
        self.lblAgeFilter.text = "\(currentValue) Years"
    }
    
    
    @IBAction func btnOnCloseFilterVw(_ sender: Any) {
        self.vwFilter.fadeOut()
    }
    
    @IBAction func btnOnRetry(_ sender: Any) {
        let obj = self.arrUserModal[arrIndex]
        print(obj.name)
    }
    
    @IBAction func btnOnCross(_ sender: Any) {
        if let swipeView = swipeView{
            swipeView.makeLeftSwipeAction()
        }
    }
    
    @IBAction func btnOnChat(_ sender: Any) {
        let obj = self.arrUserModal[arrIndex]
        print(obj.name)
    }
    
    @IBAction func btnOnLike(_ sender: Any) {
        if let swipeView = swipeView{
            swipeView.makeRightSwipeAction()
        }
    }
    @IBAction func btnOnStar(_ sender: Any) {
        let obj = self.arrUserModal[arrIndex]
        print(obj.name)
    }
    
    @IBAction func btnOnApply(_ sender: Any) {
        self.vwFilter.fadeOut()
        self.call_WsGetUsers()
    }
    
    @IBAction func btnOnrefresh(_ sender: Any) {
        self.distance = ""
        self.age = ""
        self.gender = ""
        call_WsGetUsers()
    }
    //MARK: Configure Tinder View
    func configureTinderView() {
        let contentView: (Int, CGRect, UserModel) -> (UIView) = { (index: Int ,frame: CGRect , userModel: UserModel) -> (UIView) in
            
            print(index)
            
            let customView = CustomView(frame: frame)
            customView.userModel = userModel
            let imageUrl  = userModel.user_image
            if imageUrl != "" {
                let url = URL(string: imageUrl)
                customView.imageViewBackground.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
            }else{
                customView.imageViewBackground.image = #imageLiteral(resourceName: "image")
            }
            customView.buttonAction.addTarget(self, action: #selector(self.customViewButtonSelected), for: UIControl.Event.touchUpInside)
            return customView
            // Programitcally creating content view
            //            if index % 2 != 0 {
            //                print("Inside number--->",index)
            //                return self.programticViewForOverlay(frame: frame, userModel: userModel)
            //            }
            //                // loading contentview from nib
            //            else{
            //                let customView = CustomView(frame: frame)
            //                customView.userModel = userModel
            //                customView.buttonAction.addTarget(self, action: #selector(self.customViewButtonSelected), for: UIControl.Event.touchUpInside)
            //                return customView
            //            }
        }
        let heightMinus = UIApplication.shared.statusBarFrame.size.height + 125
        let myFrame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - heightMinus)
        //        swipeView = TinderSwipeView<UserModel>(frame: viewContainer.bounds, contentView: contentView)
        swipeView = TinderSwipeView<UserModel>(frame: myFrame, contentView: contentView)
        vwContainer.addSubview(swipeView)
        swipeView.showTinderCards(with: arrUserModal ,isDummyShow: true)
    }
    
    
    
    //MARK: Button Actions
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnOpenFilter(_ sender: Any) {
        // self.vwFilter.isHidden = false
        self.vwFilter.fadeIn()
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.sourceLatitude = "\(locValue.latitude)"
        self.sourceLongitude = "\(locValue.longitude)"
        locationManager.stopUpdatingLocation()
    }
}

//MARK: TinderView Extra Functions
extension HomeViewController{
    
    private func programticViewForOverlay(frame:CGRect, userModel:UserModel) -> UIView{
        
        let containerView = UIView(frame: frame)
        
        let backGroundImageView = UIImageView(frame:containerView.bounds)
        //  backGroundImageView.image = UIImage(named: "logo")//UIImage(named:String(Int(1 + arc4random() % (8 - 1))))
        
        let imageUrl  = userModel.user_image
        print(imageUrl)
        if imageUrl != "" {
            let url = URL(string: imageUrl)
            backGroundImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }else{
            backGroundImageView.image = #imageLiteral(resourceName: "image")
        }
        backGroundImageView.contentMode = .scaleAspectFill
        backGroundImageView.clipsToBounds = true;
        containerView.addSubview(backGroundImageView)
        
        //        let profileImageView = UIImageView(frame:CGRect(x: 25, y: frame.size.height - 80, width: 60, height: 60))
        //
        //        //Set User Image on Swipe view
        //        let imageUrl1  = userModel.user_image
        //        if imageUrl != "" {
        //            let url = URL(string: imageUrl)
        //            profileImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        //        }else{
        //            profileImageView.image = #imageLiteral(resourceName: "image")
        //        }
        //
        //        profileImageView.contentMode = .scaleAspectFill
        //        profileImageView.layer.cornerRadius = 30
        //        profileImageView.clipsToBounds = true
        //        containerView.addSubview(profileImageView)
        
        let labelText = UILabel(frame:CGRect(x: 90, y: frame.size.height - 40, width: frame.size.width - 100, height: 80))
        labelText.attributedText = self.attributeStringForModel(userModel: userModel)
        labelText.numberOfLines = 4
        containerView.addSubview(labelText)
        
        return containerView
    }
    
    @objc func customViewButtonSelected(button:UIButton) {
        
        if let customView = button.superview(of: CustomView.self) , let userModel = customView.userModel {
            print("button selected for \(userModel.name)")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController")as! MyProfileViewController
            vc.strID = self.arrUserModal[arrIndex].strUser_id
            vc.isComingFrom = "Home"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    private func attributeStringForModel(userModel:UserModel) -> NSAttributedString{
        
        let attributedText = NSMutableAttributedString(string: userModel.name, attributes: [.foregroundColor: UIColor.white,.font:UIFont.boldSystemFont(ofSize: 25)])
        attributedText.append(NSAttributedString(string: "\nnums :\( userModel.num) (programitically)", attributes: [.foregroundColor: UIColor.white,.font:UIFont.systemFont(ofSize: 18)]))
        return attributedText
    }
}

extension UIView {
    
    func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.map { $0.superview(of: type)! }
    }
    
    func subview<T>(of type: T.Type) -> T? {
        return subviews.compactMap { $0 as? T ?? $0.subview(of: type) }.first
    }
}

//MARK: Tinder View Delegates
extension HomeViewController : TinderSwipeViewDelegate {
    
    func dummyAnimationDone() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
            self.vwNaviagtion.alpha = 1.0
        }, completion: nil)
        print("Watch out shake action")
    }
    
    func didSelectCard(model: Any) {
        print("Selected card")
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController")as! MyProfileViewController
        //        vc.strID = self.arrUserModal[arrIndex].strUser_id
        //        vc.isComingFrom = "Home"
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fallbackCard(model: Any) {
        let userModel = model as! UserModel
        print("Cancelling \(userModel.name)")
    }
    
    func cardGoesLeft(model: Any) {
        let userModel = model as! UserModel
        print("Watchout Left \(userModel.name)")
        self.arrIndex = self.arrIndex + 1
    }
    
    func cardGoesRight(model : Any) {
        let userModel = model as! UserModel
        print("Watchout Right \(userModel.name)")
        self.arrIndex = self.arrIndex + 1
    }
    
    func undoCardsDone(model: Any) {
        let userModel = model as! UserModel
        print("Reverting done \(userModel.name)")
    }
    
    func endOfCardsReached() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            self.vwNaviagtion.alpha = 0.0
            self.noRecordFoundView.isHidden = false
        }, completion: nil)
        print("End of all cards")
        self.arrIndex = 0
    }
    
    func currentCardStatus(card object: Any, distance: CGFloat) {
        print("Current card")
    }
}

//MARK:- Call Webservice
extension HomeViewController{
    
    func call_WsGetUsers(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        dicrParam = ["login_id":objAppShareData.UserDetail.strUser_id,
                     "distance":self.distance,
                     "gender":self.gender,
                     "age":self.age,
                     "lat":self.sourceLatitude,
                     "long":self.sourceLongitude]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetUsers, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    self.arrUserModal.removeAll()
                    for data in user_details{
                        let obj = UserModel(from: data)
                        self.arrUserModal.append(obj)
                    }
                    DispatchQueue.main.async {
                        self.noRecordFoundView.isHidden = true
                        self.vwNaviagtion.alpha = 1.0
                        self.configureTinderView()
                    }
                    
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.arrUserModal.removeAll()
                    DispatchQueue.main.async {
                        self.vwNaviagtion.alpha = 0.0
                        self.swipeView.removeFromSuperview()
                        self.noRecordFoundView.isHidden = false
                    }
                    // objAlert.showAlert(message: msgg, title: "", controller: self)
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


