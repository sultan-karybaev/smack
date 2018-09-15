//
//  MessageService.swift
//  smack
//
//  Created by Sultan Karybaev on 9/15/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()

    var channels = [Channel]()
    
    func findAllChannel(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON(completionHandler: { response in
            if response.result.error == nil {
                guard let data = response.data else {return}
                
//                do {
//                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
//                } catch let error {
//                    debugPrint(error as Any)
//                }
                
                if let json = try! JSON(data: data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
                        self.channels.append(channel)
                    }
                    completion(true)
                }
                
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        })
    }
    
//    func createChannel(name: String, desc: String, completion: @escaping CompletionHandler) {
//        let lowerCaseName = name.lowercased()
//        let body: [String: Any] = [
//            "name" : lowerCaseName,
//            "desc" : desc
//        ]
//        
//        Alamofire.request(URL_CREATE_CHANNEL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON(completionHandler: { response in
//            if response.result.error == nil {
//                guard let data = response.data else {return}
//                
//                if let json = try? JSON(data: data) {
//                    let name = json["name"].stringValue
//                    let channelDescription = json["description"].stringValue
//                    let id = json["_id"].stringValue
//                    let channel = Channel(channelTitle: name, channelDescription: channelDescription, id: id)
//                    self.channels.append(channel)
//
//                    completion(true)
//                }
//
//                
//                
//            } else {
//                completion(false)
//                debugPrint(response.result.error as Any)
//            }
//        })
//    }
    
}
