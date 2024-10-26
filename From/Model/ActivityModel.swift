//
//  ActivityModel.swift
//  From
//
//  Created by Rohit SIngh Dhakad on 26/10/24.
//

import UIKit

import UIKit

class ActivityModel: NSObject {
    
    var arrNotification: [ActivityNotificationModel] = []
    var arrSuperLike: [ActivitySuperLikeModel] = []
    var arrLikes: [ActivityLikesModel] = []
    
    init(from dictionary: [String: Any]) {
        if let notificationData = dictionary["notifications"] as? [[String: Any]] {
            self.arrNotification = notificationData.map { ActivityNotificationModel(from: $0) }
        }
        
        if let superLikeData = dictionary["super_likes"] as? [[String: Any]] {
            self.arrSuperLike = superLikeData.map { ActivitySuperLikeModel(from: $0) }
        }
        
        if let likesData = dictionary["likes"] as? [[String: Any]] {
            self.arrLikes = likesData.map { ActivityLikesModel(from: $0) }
        }
    }
}

class ActivityNotificationModel: NSObject {
    var message: String
    var strTimeAgo: String
    var strName: String
    var strUserImage: String
    
    init(from dictionary: [String: Any]) {
        self.message = dictionary["message"] as? String ?? ""
        self.strTimeAgo = dictionary["time_ago"] as? String ?? ""
        self.strName = dictionary["name"] as? String ?? ""
        self.strUserImage = dictionary["user_image"] as? String ?? ""
    }
}

class ActivitySuperLikeModel: NSObject {
    var message: String
    var strTimeAgo: String
    var strName: String
    var strUserImage: String
    
    init(from dictionary: [String: Any]) {
        self.message = dictionary["message"] as? String ?? ""
        self.strTimeAgo = dictionary["time_ago"] as? String ?? ""
        self.strName = dictionary["name"] as? String ?? ""
        self.strUserImage = dictionary["user_image"] as? String ?? ""
    }
}

class ActivityLikesModel: NSObject {
    var message: String
    var strTimeAgo: String
    var strName: String
    var strUserImage: String
    
    init(from dictionary: [String: Any]) {
        self.message = dictionary["message"] as? String ?? ""
        self.strTimeAgo = dictionary["time_ago"] as? String ?? ""
        self.strName = dictionary["name"] as? String ?? ""
        self.strUserImage = dictionary["user_image"] as? String ?? ""
    }
}
