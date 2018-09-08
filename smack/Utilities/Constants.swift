//
//  Constants.swift
//  smack
//
//  Created by Sultan Karybaev on 8/30/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

//URL Constants
let BASE_URL = "https://smack-server-sultankarybaev.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"

//Segues
let TO_LOGIN = "toLogin"
let TO_CREATEACCOUNT = "toCreateAccount"
let UNWIND_TO_CHANNELVC = "unwindToChannelVC"

//User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
