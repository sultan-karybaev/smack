//
//  CreateAccountVC.swift
//  smack
//
//  Created by Sultan Karybaev on 8/31/18.
//  Copyright © 2018 Sultan Karybaev. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNELVC, sender: nil)
    }
}
