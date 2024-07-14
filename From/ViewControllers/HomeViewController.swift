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

class HomeViewController: UIViewController {

    private var swipeView: TinderSwipeView<UserModel>!{
        didSet{
            self.swipeView.delegate = self
        }
    }
    
    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vwNaviagtion: UIView!{
        didSet{
            self.vwNaviagtion.alpha = 0.0
        }
    }
    
    var arrUserModal = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureTinderView()
    }
    
    
    
    //MARK: Configure Tinder View
    func configureTinderView() {
        let contentView: (Int, CGRect, UserModel) -> (UIView) = { (index: Int ,frame: CGRect , userModel: UserModel) -> (UIView) in
            
            // Programitcally creating content view
            if index % 2 != 0 {
                return self.programticViewForOverlay(frame: frame, userModel: userModel)
            }
                // loading contentview from nib
            else{
                let customView = CustomView(frame: frame)
                customView.userModel = userModel
                customView.buttonAction.addTarget(self, action: #selector(self.customViewButtonSelected), for: UIControl.Event.touchUpInside)
                return customView
            }
        }
        print(vwContainer.bounds)
        let heightMinus = UIApplication.shared.statusBarFrame.size.height + 225
        let myFrame = CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - heightMinus)
//        swipeView = TinderSwipeView<UserModel>(frame: viewContainer.bounds, contentView: contentView)
        print(myFrame)
        swipeView = TinderSwipeView<UserModel>(frame: myFrame, contentView: contentView)
        vwContainer.addSubview(swipeView)
        swipeView.showTinderCards(with: arrUserModal ,isDummyShow: true)
    }
    
    
    
    //MARK: Button Actions
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnOpenFilter(_ sender: Any) {
        
    }

}


//MARK: TinderView Extra Functions
extension HomeViewController{
    
    private func programticViewForOverlay(frame:CGRect, userModel:UserModel) -> UIView{
        
        let containerView = UIView(frame: frame)
        
        let backGroundImageView = UIImageView(frame:containerView.bounds)
        backGroundImageView.image = UIImage(named:String(Int(1 + arc4random() % (8 - 1))))
        backGroundImageView.contentMode = .scaleAspectFill
        backGroundImageView.clipsToBounds = true;
        containerView.addSubview(backGroundImageView)
        
        let profileImageView = UIImageView(frame:CGRect(x: 25, y: frame.size.height - 80, width: 60, height: 60))
        
        //Set User Image on Swipe view
        let imageUrl  = userModel.user_image
        if imageUrl != "" {
            let url = URL(string: imageUrl)
            profileImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "img"))
        }else{
            profileImageView.image = #imageLiteral(resourceName: "profileimage")
        }
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        containerView.addSubview(profileImageView)
        
        let labelText = UILabel(frame:CGRect(x: 90, y: frame.size.height - 80, width: frame.size.width - 100, height: 60))
        labelText.attributedText = self.attributeStringForModel(userModel: userModel)
        labelText.numberOfLines = 2
        containerView.addSubview(labelText)
        
        return containerView
    }
    
    @objc func customViewButtonSelected(button:UIButton) {
        
        if let customView = button.superview(of: CustomView.self) , let userModel = customView.userModel {
            print("button selected for \(userModel.name)")
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
    }
    
    func fallbackCard(model: Any) {
        let userModel = model as! UserModel
        print("Cancelling \(userModel.name)")
    }
    
    func cardGoesLeft(model: Any) {
        let userModel = model as! UserModel
        print("Watchout Left \(userModel.name)")
    }
    
    func cardGoesRight(model : Any) {
        let userModel = model as! UserModel
        print("Watchout Right \(userModel.name)")
    }
    
    func undoCardsDone(model: Any) {
        let userModel = model as! UserModel
        print("Reverting done \(userModel.name)")
    }
    
    func endOfCardsReached() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            self.vwNaviagtion.alpha = 0.0
        }, completion: nil)
         print("End of all cards")
    }
    
    func currentCardStatus(card object: Any, distance: CGFloat) {
        
    }
}

//MARK:- Call Webservice
extension HomeViewController{
    
//    func call_WSGetUserDetail(){
//        
//        if !objWebServiceManager.isNetworkAvailable(){
//            objWebServiceManager.hideIndicator()
//            objAppShareData.showNetworkAlert(view:self)
//            return
//        }
//        //objWebServiceManager.showIndicator()
//        self.view.endEditing(true)
//        
//        let userID = objAppShareData.userDetail.strUserID
//        
//        
//        
//       
//        let finalUrl = userID + "&lat=" + self.sourceLatitude + "&lng=" + self.sourceLongitude + "&distance=" + self.filter_distance + "&min_age=" + self.filter_minAge + "&max_age=" + self.filter_maxAge + "&sex=" + self.filter_gender
//        
//        print(finalUrl)
//        
//        objWebServiceManager.requestGet(strURL: WsUrl.getUserList + finalUrl, params: [:], queryParams: [:], strCustomValidation: "", success: { (response) in
//            self.hideProgressBar()
//            print(response)
//            
//            if let user_details = response["result"]as? [[String:Any]]{
//
//              
//                for data in user_details{
//                    let obj = UserModel.init(dict: data)
//                    self.arrUserModal.append(obj)
//                }
//                
//                self.configureTinderView()
//                
//                
//                
//            }else{
//                self.hideProgressBar()
//                objAppShareData.showAlert(title: "Alert", message: "Result not found", view: self)
//            }
//            
//            
//        }) { (Error) in
//            self.hideProgressBar()
//            print(Error)
//        }
//        
//        
//    }
    
}
