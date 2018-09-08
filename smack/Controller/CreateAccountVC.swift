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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func chooseAvatarPressed(_ sender: Any) {
    }
    
    @IBAction func generateGBColorPressed(_ sender: Any) {
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        guard let email = emailTxt.text, emailTxt.text != "" else {return}
        guard let pass = passwordTxt.text, passwordTxt.text != "" else {return}
        
        AuthService.instance.registerUser(email: email, password: pass, completion: { success in
            if success {
                print("registered user!")
                AuthService.instance.loginUser(email: email, password: pass, completion: { bool in
                    if bool {
                        print("logged in user!", AuthService.instance.userEmail)
                    }
                })
            }
            
        })
        
        performSegue(withIdentifier: UNWIND_TO_CHANNELVC, sender: nil)
    }
    
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNELVC, sender: nil)
    }
}
