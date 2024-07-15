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
        
    }
    
    @IBAction func btnOnGenderSelection(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            print("Male")
        case 2:
            print("FeMale")
        case 3:
            print("Trans Male")
        default:
            print("Trans FeMale")
        }
        
        
    }
    @IBAction func btnGoToEULA(_ sender: Any) {
        
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
