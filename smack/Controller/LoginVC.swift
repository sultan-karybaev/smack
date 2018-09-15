//
//  LoginVC.swift
//  smack
//
//  Created by Sultan Karybaev on 8/30/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextfield.delegate = self
        setUpView()
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donthaveaccountBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATEACCOUNT, sender: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let name = usernameTextfield.text, usernameTextfield.text != "" else {return}
        guard let pass = passwordTextField.text, passwordTextField.text != "" else {return}
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        AuthService.instance.loginUser(email: name, password: pass, completion: { bool in
            if bool {
                AuthService.instance.findUserByEmail(completion: { success in
                    if success {
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                    }
                })
            }
        })
    }
    
    func setUpView() {
        spinner.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        usernameTextfield.attributedPlaceholder = NSAttributedString(string: "username", attributes: [.foregroundColor: SMACK_PURPLE_PLACEHOLDER])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [.foregroundColor: SMACK_PURPLE_PLACEHOLDER])
    }
}

extension LoginVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextfield.resignFirstResponder()  //if desired
        return true
    }
    
}
