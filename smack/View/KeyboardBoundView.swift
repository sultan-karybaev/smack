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
        print("keyboardWillChange")
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = targetFrame.origin.y - curFrame.origin.y
        if let superV = self.superview {
            let consArray = superV.constraints.filter { (constraint) -> Bool in
                if constraint.secondItem as? UIView == self && constraint.secondAttribute.rawValue == 4 {
                    return true
                }
                return false
            }
            if consArray.count > 0 {
                UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
                    print(consArray[0].constant)
                    
                    self.frame.origin.y += deltaY
                    consArray[0].constant -= deltaY

                },completion: {(true) in
                    self.layoutIfNeeded()
                })
            }
        }
        
    }
}
