//
//  ChatVC.swift
//  smack
//
//  Created by Sultan Karybaev on 8/25/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var channelNameLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var messageTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.revealViewController().delegate = self
        
        messageTableview.delegate = self
        messageTableview.dataSource = self
        messageTableview.estimatedRowHeight = 72
        messageTableview.rowHeight = UITableViewAutomaticDimension
        print("height \(messageTableview.frame.height)")
        print("height \(messageTableview.contentSize.height)")
        
        textView.bindToKeyboard()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.findUserByEmail(completion: { success in
                if success {
                    print("ChatVC")
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            })
        }
        
        SocketService.instance.getMessage(completion: { success in
            if success {
                self.messageTableview.reloadData()
                DispatchQueue.main.async(execute: {
                    if MessageService.instance.messages.count > 0 {
                       self.messageTableview.scrollToRow(at: [0, MessageService.instance.messages.count - 1], at: .bottom, animated: false)
                    }
                })
            }
        })
    }
    
    @IBAction func sendPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let messageBody = messageTextField.text, messageTextField.text != "" else {return}
            guard let channelId = MessageService.instance.selectedChannel?.id else {return}
            let userId = UserDataService.instance.id
            SocketService.instance.sendMessage(messageBody: messageBody, userId: userId, channelId: channelId, completion: { success in
                if success {
                    self.messageTextField.text = ""
                    self.messageTextField.resignFirstResponder()
                }
            })
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelNameLabel.text = "Please Log In"
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLabel.text = "#\(channelName)"
        getMessages()
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannel(completion: { success in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.channelNameLabel.text = "No channels let"
                }
            }
        })
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        MessageService.instance.findAllMessagesForChannel(channelId: channelId, completion: { success in
            if success {
                self.messageTableview.reloadData()
                DispatchQueue.main.async(execute: {
                    //print("height \(self.messageTableview.frame.height)")
                    //print("height \(self.messageTableview.contentSize.height)")
                    //self.messageTableview.scrollToNearestSelectedRow(at: .bottom, animated: false)
                    if MessageService.instance.messages.count > 0 {
                        self.messageTableview.scrollToRow(at: [0, MessageService.instance.messages.count - 1], at: .bottom, animated: false)
                    }
                })
            }
        })
    }
    
    
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = messageTableview.dequeueReusableCell(withIdentifier: MESSAGE_CELL, for: indexPath) as? MessageCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return MessageCell()
        }
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 72
//    }
    
    
}








