//
//  MembershipViewController.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 14/07/24.
//

import UIKit

class MembershipViewController: UIViewController {

    @IBOutlet weak var cvPlans: UICollectionView!
    @IBOutlet weak var txtVwDescription: UITextView!
    
    var strSelectedIndex = -1
    
    var arrPlans = [MembershipPlanModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.call_WsGetPlans()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnOnOpenMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }

    @IBAction func btnOnContinue(_ sender: Any) {
        
    }
}


extension MembershipViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrPlans.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MembershipCollectionViewCell", for: indexPath)as! MembershipCollectionViewCell
        
        let obj = self.arrPlans[indexPath.row]
        
        cell.lblPlanType.text = obj.planName
        cell.lblDays.text = "\(obj.planValidity ?? "") Days"
        if obj.planPrice == "0"{
            cell.lblPrice.text = "Free"
        }else{
            cell.lblPrice.text = "\(obj.planPrice ?? "") USD"
        }
        
        
        if indexPath.row == self.strSelectedIndex{
            cell.vwOuter.borderColor = UIColor.red
        }else{
            cell.vwOuter.borderColor = UIColor.white
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.strSelectedIndex = indexPath.row
        
        self.txtVwDescription.attributedText = self.arrPlans[indexPath.row].strDescription?.htmlToAttributedString
        
        self.cvPlans.reloadData()
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


extension MembershipViewController{
    
    func call_WsGetPlans(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        dicrParam = ["user_id":objAppShareData.UserDetail.strUser_id]as [String:Any]
        
        print(dicrParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetMembershipPlans, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                    self.arrPlans.removeAll()
                    for data in user_details{
                        let obj = MembershipPlanModel(from: data)
                        self.arrPlans.append(obj)
                    }
                    
                    self.arrPlans = self.arrPlans.reversed()
                    DispatchQueue.main.async {
                        self.cvPlans.reloadData()
                    }
                    
                }
                else {
                    objAlert.showAlert(message: "Something went wrong!", title: "", controller: self)
                }
            }else{
                objWebServiceManager.hideIndicator()
                if let msgg = response["result"]as? String{
                    self.arrPlans.removeAll()
                    self.cvPlans.reloadData()
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


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
