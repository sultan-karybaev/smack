//
//  KeyboardBoundView.swift
//  SmackAlpha
//
//  Created by Jonny B on 7/11/17.
//  Copyright © 2017 Jonny B. All rights reserved.
//

import UIKit

extension UIView {
    
    func bindToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        if let superView = self.superview {
            var table: UITableView?
            let consArray = superView.constraints.filter { (constraint) -> Bool in
                if constraint.secondItem as? UIView == self && constraint.secondAttribute.rawValue == 4 {
                    return true
                }
                if let t = constraint.secondItem as? UITableView {
                    //print("UITableView")
                    table = t
                }
                return false
            }
            if consArray.count > 0 && table != nil {
                consArray[0].constant -= deltaY
                UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
                    table?.contentOffset.y -= deltaY
                    self.frame.origin.y += deltaY
                    self.superview?.layoutIfNeeded()
                },completion: {(true) in
                    print("height \(table!.frame.height)")
                    print("height \(table!.contentSize.height)")
                    //table?.scrollToRow(at: [0, MessageService.instance.messages.count - 1], at: .bottom, animated: false)
                    //self.layoutIfNeeded()
                })
            }
        }
        
    }
}
