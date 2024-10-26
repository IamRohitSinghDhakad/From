//
//  ActivityTableViewCell.swift
//  From
//
//  Created by Rohit SIngh Dhakad on 26/10/24.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var imgVwUser: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTimeAgo: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgVwUser.cornerRadius = self.imgVwUser.frame.width / 2
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
