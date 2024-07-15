//
//  GamePlayersModel.swift
//  SocialGame
//
//  Created by Rohit SIngh Dhakad on 21/02/24.
//

import UIKit

class GetUsersImagesModel: NSObject {
    
  
    var strImageId: String?
    var image: String?
    var user_id: String?
    
    init(from dictionary: [String: Any]) {
        super.init()
        
        if let value = dictionary["id"] as? Int {
            strImageId = "\(value)"
        }else if let value = dictionary["id"] as? String {
            strImageId = value
        }
        
        if let value = dictionary["image"] as? String {
            image = value
        }
        
        if let value = dictionary["user_id"] as? String {
            user_id = value
        } else if let value = dictionary["user_id"] as? Int {
            user_id = "\(value)"
        }
    }
    
}
