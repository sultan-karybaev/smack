//
//  MessageCell.swift
//  smack
//
//  Created by Sultan Karybaev on 9/22/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    
    @IBOutlet weak var userImage: CircleImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(message: Message) {
        userImage.image = UIImage(named: message.userAvatar)
        userImage.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        messageLabel.text = message.message
        timeStampLabel.text = message.timeStamp
        userNameLabel.text = message.userName
    }

}
