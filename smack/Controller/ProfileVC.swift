//
//  ProfileVC.swift
//  smack
//
//  Created by Sultan Karybaev on 9/14/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        userName.text = UserDataService.instance.avatarName
        userEmail.text = UserDataService.instance.email
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(closeVC))
        bgView.addGestureRecognizer(closeTouch)
        
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closeVC() {
        self.dismiss(animated: true, completion: nil)
    }

}
