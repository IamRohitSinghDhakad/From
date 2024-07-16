//
//  SetInterestViewController.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 14/07/24.
//

import UIKit
import iOSDropDown

class SetInterestViewController: UIViewController {

    @IBOutlet weak var tfSexualOrientation: DropDown!
    @IBOutlet weak var tfFatherComesFrom: DropDown!
    @IBOutlet weak var tfMotherComesFrom: DropDown!
    @IBOutlet weak var tfLikeToMeet: DropDown!
    @IBOutlet weak var tfCountryOfOrigin: DropDown!
    @IBOutlet weak var tfLookingForRelation: DropDown!
    @IBOutlet weak var tfGym: DropDown!
    @IBOutlet weak var tfAlcohol: DropDown!
    @IBOutlet weak var tfSmoking: DropDown!
    @IBOutlet weak var tfPet: DropDown!
    @IBOutlet weak var tfLoveLanguage: DropDown!
    @IBOutlet weak var tfEducation: DropDown!
    @IBOutlet weak var tfHobbies: DropDown!
    @IBOutlet var vwSubVw: UIView!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblVwCountries: UITableView!
    
    var arrCountry = [CountryModel]()
    
    var  arrOrientation:[String]  = ["What Is Your Sexual Orientation?", "Straight", "Gay", "Lesbian", "Not Very Sure At The Moment", "Others"]
    var arrWhoMeet:[String]  = ["Who Would You Like To Meet?", "Straight", "Male", "Female", "No Preference"]
    var arrLookingForArr:[String] = ["What Are you Looking For ?", "A Serious Relationship", "Nothing Serious", "New Friends", "We'll See As Time Goes On"]
    var arrGym:[String] = ["Do You Go To The Gym?", "Every Day", "Very Often", "From Time To Time", "Never"]
    var arrAlcohol:[String] = ["Do You Consume Alcohol?", "Every Day", "Very Often", "From Time To Time", "Never"]
    var arrSmoke:[String] = ["Do You Smoke ?", "Every Day", "Very Often", "From Time To Time", "Never"]
    var arrPet:[String] = ["Do you have Pets ?", "No I Don't Have Pet", "Dog", "Cat", "Fish", "Rabbit", "Bird", "Reptile", "Others"]
    var arrLove_language:[String]  = ["What Is Your Love Language? (Optional)", "quality Moments", "Gifts", "Compliments", "Physical Contact", "Being There For Each Other"]
    var arrEducation:[String] = ["What Is Your Level Of Education? (Optional)", "Secondary", "Still Studying", "Baccalaureate", "Mastery", "Doctorate"]
    var arrInterests:[String] = ["What Are Your Interests?", "kitchen", "While Reading", "Music", "Volunteering", "Photography", "Movie Theater", "Sport", "Theater", "Yoga", "Paint", "Artistic Activities", "Computing", "Video Games", "In Writing", "Artificial Intelligence", "Etc"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblVwCountries.delegate = self
        self.tblVwCountries.dataSource = self
        
        self.call_WsGetCountry()
        
        self.tfSexualOrientation.placeholder = "What Is Your Sexual Orientation?"
        self.tfFatherComesFrom.placeholder = "Your Father's Side Country"
        self.tfMotherComesFrom.placeholder = "Your Mother's Side Country"
        self.tfLikeToMeet.placeholder = "Who Would You Like To Meet?lf"
        self.tfCountryOfOrigin.placeholder = "What countyry of origin would you ?"
        self.tfLookingForRelation.placeholder = "What Are you Looking For ?"
        self.tfGym.placeholder = "Do You Go To The Gym?"
        self.tfAlcohol.placeholder = "Do You Consume Alcohol?"
        self.tfSmoking.placeholder = "Do You Smoke ?"
        self.tfPet.placeholder = "Do you have Pets ?"
        self.tfLoveLanguage.placeholder = "What Is Your Love Language? (Optional)"
        self.tfEducation.placeholder = "What Is Your Level Of Education? (Optional)"
        self.tfHobbies.placeholder = "What Are Your Interests?"
        
        
        //MARK: - Set Delegates
        self.tfSexualOrientation.delegate = self
        self.tfFatherComesFrom.delegate = self
        self.tfMotherComesFrom.delegate = self
        self.tfLikeToMeet.delegate = self
        self.tfCountryOfOrigin.delegate = self
        self.tfLookingForRelation.delegate = self
        self.tfGym.delegate = self
        self.tfAlcohol.delegate = self
        self.tfSmoking.delegate = self
        self.tfPet.delegate = self
        self.tfLoveLanguage.delegate = self
        self.tfEducation.delegate = self
        self.tfHobbies.delegate = self
       
        //MARK: - Set Arrays
        self.tfSexualOrientation.optionArray = self.arrOrientation
        self.tfLikeToMeet.optionArray = self.arrWhoMeet
        self.tfLookingForRelation.optionArray = self.arrLookingForArr
        self.tfGym.optionArray = self.arrGym
        self.tfAlcohol.optionArray = self.arrAlcohol
        self.tfSmoking.optionArray = self.arrSmoke
        self.tfPet.optionArray = self.arrPet
        self.tfLoveLanguage.optionArray = self.arrLove_language
        self.tfEducation.optionArray = self.arrEducation
        self.tfHobbies.optionArray = self.arrInterests
        
        self.tfSexualOrientation.didSelect { selectedText, index, id in
            self.tfSexualOrientation.text = selectedText
        }
        
        self.tfLikeToMeet.didSelect { selectedText, index, id in
            self.tfLikeToMeet.text = selectedText
        }
        
        self.tfLookingForRelation.didSelect { selectedText, index, id in
            self.tfLookingForRelation.text = selectedText
        }
        
        self.tfGym.didSelect { selectedText, index, id in
            self.tfGym.text = selectedText
        }
        
        self.tfAlcohol.didSelect { selectedText, index, id in
            self.tfAlcohol.text = selectedText
        }
        
        self.tfSmoking.didSelect { selectedText, index, id in
            self.tfSmoking.text = selectedText
        }
        
        self.tfPet.didSelect { selectedText, index, id in
            self.tfPet.text = selectedText
        }
        
        self.tfLoveLanguage.didSelect { selectedText, index, id in
            self.tfLoveLanguage.text = selectedText
        }
        
        self.tfEducation.didSelect { selectedText, index, id in
            self.tfEducation.text = selectedText
        }
        
        self.tfHobbies.didSelect { selectedText, index, id in
            self.tfHobbies.text = selectedText
        }
        
        self.tfFatherComesFrom.didSelect { selectedText, index, id in
            self.tfFatherComesFrom.text = selectedText
        }
        
        self.tfMotherComesFrom.didSelect { selectedText, index, id in
            self.tfMotherComesFrom.text = selectedText
        }
        
    }
    
    @IBAction func btnShowSubVw(_ sender: Any) {
        self.lblHeader.text = "What country of origin would you"
        self.addSubviewWithAnimation(isAdd: true)
    }
    @IBAction func btnDoneSubVw(_ sender: Any) {
        self.addSubviewWithAnimation(isAdd: false)
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        self.sideMenuController?.revealMenu()
    }
    
    @IBAction func btnOnSkip(_ sender: Any) {
        
    }
    
    @IBAction func btnOnSubmit(_ sender: Any) {
        
    }
}

extension SetInterestViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCountry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell")as! CountryTableViewCell
        
        cell.lblTitle.text = self.arrCountry[indexPath.row].strCountryName
        
        if self.arrCountry[indexPath.row].isSelected == true{
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        }else{
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let obj = self.arrCountry[indexPath.row]
        
        if obj.isSelected == true{
            obj.isSelected = false
        }else{
            obj.isSelected = true
        }
        self.tblVwCountries.reloadData()
    }
    
    
    
}


extension SetInterestViewController{
    
    func call_WsGetCountry(){
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
            return
        }
        
        objWebServiceManager.showIndicator()
        
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_GetCountry, queryParams: [:], params: [:], strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            if status == MessageConstant.k_StatusCode{
                if let user_details  = response["result"] as? [[String:Any]] {
                  var arrCountry = [String]()
                    var arrCountryID = [Int]()
                    for data in user_details{
                        let country_name = data["country_name"]as! String
                        let country_id = data["country_id"]as! String
                        arrCountry.append(country_name)
                        arrCountryID.append(Int(country_id) ?? 0)
                        
                        let obj = CountryModel(from: data)
                        self.arrCountry.append(obj)
                    }
                    
                    self.tblVwCountries.reloadData()
                    
                    self.tfFatherComesFrom.optionArray = arrCountry
                    self.tfMotherComesFrom.optionArray = arrCountry
                    
                    self.tfFatherComesFrom.optionIds = arrCountryID
                    self.tfMotherComesFrom.optionIds = arrCountryID
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


extension SetInterestViewController{
    func addSubviewWithAnimation(isAdd: Bool) {
            if isAdd {
                self.vwSubVw.frame = CGRect(x: 0, y: -(self.view.frame.height), width: self.view.frame.width, height: self.view.frame.height)
                self.view.addSubview(vwSubVw)
                
                UIView.animate(withDuration: 0.3) {
                    self.vwSubVw.frame.origin.y = 0
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.vwSubVw.frame.origin.y = self.view.frame.height
                } completion: { y in
                    self.vwSubVw.removeFromSuperview()
                }
            }
        }
}
