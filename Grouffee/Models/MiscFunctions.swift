//
//  MiscFunctions.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 29/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit

extension UIAlertController
{
    static func createOkayPopup(title: String, message: String, handler: ((UIAlertAction) -> Void)?) -> UIAlertController
    {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let popupOk = UIAlertAction(title: "Okay", style: .default, handler: handler)
        popup.addAction(popupOk)
        return popup
    }
    
    static func createAcceptDeclinePopup(title: String, message: String, handlerAccept: ((UIAlertAction) -> Void)?, handlerDecline: ((UIAlertAction) -> Void)?) -> UIAlertController
     {
        let popup = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let popupYes = UIAlertAction(title: "Accept", style: .default, handler: handlerAccept)
        let popupNo = UIAlertAction(title: "Decline", style: .destructive, handler: handlerDecline)
        
        popup.addAction(popupYes)
        popup.addAction(popupNo)
        return popup
    }
    
    func presentExclusively(view: UIViewController)
    {
        if UIApplication.topViewController()?.classForCoder == UIAlertController.classForCoder()
        {
            UIApplication.topViewController()!.dismiss(animated: false, completion: nil)
        }
        view.present(self, animated: true, completion: nil)
    }
}

class LoadingIndicator {
    let view: UIView!
    let activityIndicator: UIActivityIndicatorView!
    
    init(view: UIView) {
        self.view = view
        activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        self.view.addSubview(activityIndicator)
    }
    
    func startLoading() {
        UIApplication.shared.beginIgnoringInteractionEvents() //buat bikin apps ignore interaksi apapun
        activityIndicator.startAnimating()
    }
    
    func stopLoading()
    {
        UIApplication.shared.endIgnoringInteractionEvents()
        activityIndicator.stopAnimating()
    }
}

extension UIViewController
{
    /**
     Auto adjust the view's position when keyboard appear
     */
    func addKeyboardViewAdjustment()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
}

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

