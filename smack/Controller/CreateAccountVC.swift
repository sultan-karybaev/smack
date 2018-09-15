//
//  CreateAccountVC.swift
//  smack
//
//  Created by Sultan Karybaev on 8/31/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != "" {
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            if avatarName.contains("light") && bgColor == nil {
                userImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    @IBAction func chooseAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    @IBAction func generateGBColorPressed(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        UIView.animate(withDuration: 0.2, animations: {
            self.userImg.backgroundColor = self.bgColor
        })
        
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let name = usernameTxt.text, usernameTxt.text != "" else {return}
        guard let email = emailTxt.text, emailTxt.text != "" else {return}
        guard let pass = passwordTxt.text, passwordTxt.text != "" else {return}
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        AuthService.instance.registerUser(email: email, password: pass, completion: { success in
            if success {
                print("registered user!")
                AuthService.instance.loginUser(email: email, password: pass, completion: { bool in
                    if bool {
                        
                        AuthService.instance.createUser(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor, completion: { response in
                            if response {
                                print(UserDataService.instance.name, UserDataService.instance.avatarName)
                                self.spinner.isHidden = true
                                self.spinner.stopAnimating()
                                self.performSegue(withIdentifier: UNWIND_TO_CHANNELVC, sender: nil)
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                            }
                        })
                    }
                })
            }
            
        })
    }
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNELVC, sender: nil)
    }
    
    func setUpView() {
        spinner.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [.foregroundColor: SMACK_PURPLE_PLACEHOLDER])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [.foregroundColor: SMACK_PURPLE_PLACEHOLDER])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [.foregroundColor: SMACK_PURPLE_PLACEHOLDER])
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
















