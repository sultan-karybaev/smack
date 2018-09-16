//
//  CreateChannelVC.swift
//  smack
//
//  Created by Sultan Karybaev on 9/15/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

class CreateChannelVC: UIViewController {

    @IBOutlet weak var channelNameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        guard let name = channelNameTextField.text, channelNameTextField.text != "" else {return}
        guard let desc = descriptionTextField.text, descriptionTextField.text != "" else {return}
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        SocketService.instance.addChannel(channelName: name, channelDescription: desc, completion: { response in
            if response {
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                self.dismiss(animated: true, completion: nil)
                //NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }

        })
    }
    
    func setUpView() {
        spinner.isHidden = true
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(closeVC))
        bgView.addGestureRecognizer(closeTouch)
        channelNameTextField.attributedPlaceholder = NSAttributedString(string: "channelname", attributes: [.foregroundColor: SMACK_PURPLE_PLACEHOLDER])
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "description", attributes: [.foregroundColor: SMACK_PURPLE_PLACEHOLDER])
    }
    
    @objc func closeVC() {
        dismiss(animated: true, completion: nil)
    }
}
