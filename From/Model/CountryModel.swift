//
//  RegistrationModel.swift
//  FitMate
//
//  Created by Rohit SIngh Dhakad on 17/06/23.
//

import Foundation


class CountryModel:NSObject{
    
    
    var strCountryName : String?
    var strCountryID : String?
    var isSelected : Bool?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["country_name"] as? String {
            strCountryName = value
        }
        
        if let value = dictionary["country_id"] as? String {
            strCountryID = value
        }else if let value = dictionary["country_id"] as? Int {
            strCountryID = "\(value)"
        }
    }
}


class MembershipPlanModel:NSObject{
    
    
    var strDescription : String?
    var strCountryID : String?
    var planName : String?
    var planPrice : String?
    var planValidity : String?
    var planID : String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["description"] as? String {
            strDescription = value
        }
        
        if let value = dictionary["name"] as? String {
            planName = value
        }
        
        if let value = dictionary["price"] as? String {
            planPrice = value
        }
        
        if let value = dictionary["validity"] as? String {
            planValidity = value
        }
        
        if let value = dictionary["id"] as? String {
            planID = value
        }else if let value = dictionary["id"] as? Int {
            planID = "\(value)"
        }
    }
}
