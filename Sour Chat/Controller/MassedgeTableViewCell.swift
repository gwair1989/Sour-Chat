//
//  MassedgeTableViewCell.swift
//  Sour Chat
//
//  Created by Aleksandr Khalupa on 05.03.2021.
//

import UIKit

class MassedgeTableViewCell: UITableViewCell {

    @IBOutlet weak var cahatBackgroundImage: UIImageView!
    
    @IBOutlet weak var chatLabel: UILabel!
    
    @IBOutlet weak var currentUserAvatar: UIImageView!
    
    @IBOutlet weak var guestAvatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
