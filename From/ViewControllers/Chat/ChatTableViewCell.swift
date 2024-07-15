//
//  ChatTableViewCell.swift
//  From
//
//  Created by Dhakad, Rohit Singh (Cognizant) on 15/07/24.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var lblLastMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
