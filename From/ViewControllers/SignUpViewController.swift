//
//  SignUpViewController.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 14/07/24.
//

import UIKit

class SignUpViewController: UIViewController, LocationServiceDelegate {
    
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    @IBOutlet weak var tfAddress: UITextField!
    @IBOutlet weak var imgVwMaleCheckBox: UIImageView!
    @IBOutlet weak var imgVwFemaleCheckBox: UIImageView!
    @IBOutlet weak var imgVwTransMaleCheckBox: UIImageView!
    @IBOutlet weak var imgVwTransFemaleCheckBox: UIImageView!
    @IBOutlet weak var imgVwEULA: UIImageView!
    
    var destinationLatitude = Double()
    var destinationLongitude = Double()
    let datePicker = UIDatePicker()
    var strSelectedGender = ""
    
    var location: Location? {
        didSet {
            self.tfAddress.text = location.flatMap({ $0.title }) ?? "Select Location".localized()
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
                        self.tfAddress.text = locality
                    }else{
                        if SubLocality != ""{
                            self.tfAddress.text = SubLocality
                        }else{
                            if throughFare != ""{
                                self.tfAddress.text = throughFare
                            }
                        }
                    }
                    if let fullAddress = dictAddress["fullAddress"]as? String{
                        self.tfAddress.text = fullAddress
                    }else{
                        self.tfAddress.text = dictAddress["country"]as? String ?? ""
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
        location = nil
        LocationService.shared.delegate = self
        // Do any additional setup after loading the view.
        
        if LocationService.shared.getPermission(){
            //LocationService.shared.startUpdatingLocation()
        }else{
            LocationService.shared.showAlertOfLocationNotEnabled()
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
    
    func tracingLocation(currentLocation: [String : Any]) {
        
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        
    }
    
    @IBAction func btnGoBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnOnSignUp(_ sender: Any) {
        if validateFields() {
            call_WsSignUp()
        }
    }
    
    
    func validateFields() -> Bool {
        guard let fullName = tfFullName.text, !fullName.isEmpty else {
            showAlert(message: "Please enter your full name.")
            return false
        }
        guard let email = tfEmail.text, isValidEmail(email) else {
            showAlert(message: "Please enter a valid email.")
            return false
        }
        guard let password = tfPassword.text, password.count >= 6 else {
            showAlert(message: "Password must be at least 6 characters.")
            return false
        }
        guard let dob = tfDOB.text, !dob.isEmpty else {
            showAlert(message: "Please select your date of birth.")
            return false
        }
        guard let address = tfAddress.text, !address.isEmpty else {
            showAlert(message: "Please select your address.")
            return false
        }
        guard !strSelectedGender.isEmpty else {
            showAlert(message: "Please select your gender.")
            return false
        }
        //        guard isEULAAccepted else {
        //            showAlert(message: "Please accept the EULA to proceed.")
        //            return false
        //        }
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        // Basic email validation using regex
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Validation Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    @IBAction func btnOnGenderSelection(_ sender: UIButton) {
        resetImage()
        switch sender.tag {
        case 1:
            print("Male")
            self.imgVwMaleCheckBox.image = UIImage(named: "select_dot")
            self.strSelectedGender = "Male"
        case 2:
            print("FeMale")
            self.imgVwFemaleCheckBox.image = UIImage(named: "select_dot")
            self.strSelectedGender = "Female"
        case 3:
            print("Trans Male")
            self.imgVwTransMaleCheckBox.image = UIImage(named: "select_dot")
            self.strSelectedGender = "Trans Male"
        default:
            print("Trans FeMale")
            self.imgVwTransFemaleCheckBox.image = UIImage(named: "select_dot")
            self.strSelectedGender = "Trans Female"
        }
    }
    
    func resetImage(){
        self.imgVwMaleCheckBox.image = UIImage(named: "deselect")
        self.imgVwFemaleCheckBox.image = UIImage(named: "deselect")
        self.imgVwTransMaleCheckBox.image = UIImage(named: "deselect")
        self.imgVwTransFemaleCheckBox.image = UIImage(named: "deselect")
    }
    
    @IBAction func btnGoToEULA(_ sender: Any) {
        self.imgVwEULA.image = UIImage(named: "select")
        let vc = self.mainStoryboard.instantiateViewController(withIdentifier: "WebViewController")as! WebViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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


extension SignUpViewController {
    
    func call_WsSignUp(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        var dicrParam = [String:Any]()
        
        dicrParam = ["name":self.tfFullName.text!,
                     "email":self.tfEmail.text!,
                     "dob":self.tfDOB.text!,
                     "password":self.tfPassword.text!,
                     "address":self.tfAddress.text!,
                     "gender":self.strSelectedGender,
                     "lat":"\(self.destinationLatitude)",
                     "lng":"\(self.destinationLongitude)",
                     "device_type":"iOS",
                     "device_token":objAppShareData.strFirebaseToken]as [String:Any]
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_SignUp, queryParams: [:], params: dicrParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [String:Any] {
                    
                    objAppShareData.SaveUpdateUserInfoFromAppshareData(userDetail: user_details)
                    objAppShareData.fetchUserInfoFromAppshareData()
                    self.makeRootControllerHome()
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
    
    func makeRootControllerHome(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = (self.mainStoryboard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
        let navController = UINavigationController(rootViewController: vc)
        navController.isNavigationBarHidden = true
        appDelegate.window?.rootViewController = navController
    }
}
