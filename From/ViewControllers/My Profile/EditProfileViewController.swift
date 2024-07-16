//
//  EditProfileViewController.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 16/07/24.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var tfLocation: UITextField!
    @IBOutlet weak var txtVwBio: UITextView!
    @IBOutlet weak var imgVwMalke: UIImageView!
    @IBOutlet weak var imgVwFemale: UIImageView!
    @IBOutlet weak var imgVwTransMale: UIImageView!
    @IBOutlet weak var imgVwTransFemale: UIImageView!
    
    var destinationLatitude = Double()
    var destinationLongitude = Double()
    let datePicker = UIDatePicker()
    var strGender = ""
    var objUserData = UserModel(from: [:])
    
    var location: Location? {
        didSet {
            self.tfLocation.text = location.flatMap({ $0.title }) ?? "Select Location".localized()
            let cordinates = location.flatMap({ $0.coordinate })
            if (cordinates != nil){
                
                destinationLatitude = cordinates?.latitude ?? 0.0
                destinationLongitude = cordinates?.longitude ?? 0.0
              
                var xCordinate = ""
                var yCordinate = ""
                
                if let latitude = cordinates?.latitude {
                    xCordinate = "\(latitude)"
                }
                if let longitude = cordinates?.longitude{
                    yCordinate = "\(longitude)"
                }
                print(xCordinate)
                print(yCordinate)
                
                LocationService.shared.getAddressFromLatLong(plLatitude: xCordinate, plLongitude: yCordinate, completion: { (dictAddress) in
                    
                    let locality = dictAddress["locality"]as? String
                    let SubLocality = dictAddress["subLocality"]as? String
                    let throughFare = dictAddress["thoroughfare"]as? String
                    
                    if locality != ""{
                        self.tfLocation.text = locality
                    }else{
                        if SubLocality != ""{
                            self.tfLocation.text = SubLocality
                        }else{
                            if throughFare != ""{
                                self.tfLocation.text = throughFare
                            }
                        }
                    }
                    if let fullAddress = dictAddress["fullAddress"]as? String{
                        self.tfLocation.text = fullAddress
                    }else{
                        self.tfLocation.text = dictAddress["country"]as? String ?? ""
                    }
                    
                    LocationService.shared.stopUpdatingLocation()
                    
                }) { (Error) in
                    print(Error)
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tfDOB.delegate = self
        self.setDatePicker()
        setUserData()
    }

    func setUserData(){
        
        let imageUrl  = self.objUserData.user_image
        if imageUrl != "" {
            let url = URL(string: imageUrl)
            self.imgVwUser.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "logo"))
        }else{
            self.imgVwUser.image = #imageLiteral(resourceName: "Shape 2")
        }
        
        self.txtVwBio.textColor = .white
        self.tfName.text = self.objUserData.name
        self.tfEmail.text = self.objUserData.strEmail
        self.tfDOB.text = self.objUserData.dob
        self.txtVwBio.text = self.objUserData.strBio
        self.tfLocation.text = self.objUserData.address
        self.tfMobile.text = self.objUserData.mobile
        self.tfPassword.text = self.objUserData.password
       
        switch objUserData.gender {
        case "Male":
            self.imgVwMalke.image = UIImage(named: "select_dot")
            strGender = "Male"
        case "Female":
            self.imgVwFemale.image = UIImage(named: "select_dot")
            strGender = "Female"
        case "Trans Male":
            self.imgVwTransMale.image = UIImage(named: "select_dot")
            strGender = "Trans Male"
        case "Trans Female":
            self.imgVwTransMale.image = UIImage(named: "select_dot")
            strGender = "Trans Female"
        default:
            break
        }
        
    }
    
    @IBAction func btnOnBack(_ sender: Any) {
        onBackPressed()
    }
    @IBAction func btnOnSave(_ sender: Any) {
        self.call_WsUpdateProfile()
    }
    
    @IBAction func btnOpenImagePicker(_ sender: Any) {
        MediaPicker.shared.pickMedia(from: self) { Image in
            self.imgVwUser.image = Image
        }
    }
    
    @IBAction func btnOnLocation(_ sender: Any) {
        let sb = UIStoryboard.init(name: "LocationPicker", bundle: Bundle.main)
        let locationPicker = sb.instantiateViewController(withIdentifier: "LocationPickerViewController")as! LocationPickerViewController//segue.destination as! LocationPickerViewController
        locationPicker.location = location
        locationPicker.showCurrentLocationButton = true
        locationPicker.useCurrentLocationAsHint = true
        locationPicker.selectCurrentLocationInitially = true
        
        locationPicker.completion = { self.location = $0 }
        
        self.navigationController?.pushViewController(locationPicker, animated: true)
    }
    
    @IBAction func btnMale(_ sender: Any) {
        resetImage()
        self.imgVwMalke.image = UIImage(named: "select_dot")
        strGender = "Male"
    }
    @IBAction func btnFemale(_ sender: Any) {
        resetImage()
        self.imgVwFemale.image = UIImage(named: "select_dot")
        strGender = "Female"
    }
    @IBAction func btnTransMale(_ sender: Any) {
        resetImage()
        self.imgVwTransMale.image = UIImage(named: "select_dot")
        strGender = "Trans Male"
    }
    @IBAction func btnTransFemale(_ sender: Any) {
        resetImage()
        self.imgVwTransFemale.image = UIImage(named: "select_dot")
        strGender = "Trans Female"
    }
    
    func resetImage(){
        self.imgVwMalke.image = UIImage(named: "deselect")
        self.imgVwFemale.image = UIImage(named: "deselect")
        self.imgVwTransMale.image = UIImage(named: "deselect")
        self.imgVwTransFemale.image = UIImage(named: "deselect")
    }
}


extension EditProfileViewController{
    
    func setDatePicker() {
        let calendar = Calendar(identifier: .gregorian)
        
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        
        components.year = -18
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        components.year = -150
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        datePicker.minimumDate = minDate
        datePicker.maximumDate = maxDate
        
        
        //Format Date
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        self.tfDOB.inputAccessoryView = toolbar
        self.tfDOB.inputView = datePicker
    }
    
    @objc func doneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.tfDOB.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}


//MARK: - Webservice


extension EditProfileViewController{
    
    
    func call_WsUpdateProfile(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        dicrParam = ["user_id":objUserData.strUser_id,
                     "name":self.tfName.text!,
                     "email":self.tfEmail.text!,
                     "mobile":self.tfMobile.text!,
                     "dob":self.tfDOB.text!,
                     "password":self.tfPassword.text!,
                     "address":self.tfLocation.text!,
                     "gender":self.strGender,
                     "bio":self.txtVwBio.text!,
                     "lat":"\(self.destinationLatitude)",
                     "lng":"\(self.destinationLongitude)",]as [String:Any]
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_UpdateProfile, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                   
                    objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "Profile Update!", message: "Your profile update sucessfully", controller: self) {
                        self.onBackPressed()
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
    
}
