//
//  SocketService.swift
//  smack
//
//  Created by Sultan Karybaev on 9/15/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    override init() {
        super.init()
    }
    
    let manager = SocketManager(socketURL: URL(string: BASE_URL)!)
    lazy var socket : SocketIOClient = manager.defaultSocket
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDesc = dataArray[1] as? String else {return}
            guard let channelID = dataArray[2] as? String else {return}
            
            let channel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelID)
            MessageService.instance.channels.append(channel)
            
            completion(true)
        }
    }
    
    func sendMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let userName = UserDataService.instance.name
        let userAvatar = UserDataService.instance.avatarName
        let userAvatarColor = UserDataService.instance.avatarColor
        socket.emit("newMessage", messageBody, userId, channelId, userName, userAvatar, userAvatarColor)
        completion(true)
    }
    
    func getMessage(completion: @escaping CompletionHandler) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard let messageBody = dataArray[0] as? String else {return}
            //guard let userId = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let messageId = dataArray[6] as? String else {return}
            guard let temiStamp = dataArray[7] as? String else {return}
            
            let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: messageId, timeStamp: temiStamp)
            MessageService.instance.messages.append(message)
            
            completion(true)
        }
    }
    
    
}
