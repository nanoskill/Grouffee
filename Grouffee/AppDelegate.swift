//
//  AppDelegate.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 24/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var connection : ConnectionModel?
    //var myPeerId: MCPeerID!
    var user : User!
    var room : Room!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        UNUserNotificationCenter.current().requestAuthorization(options: UNAuthorizationOptions.alert) { (granted, error) in
            print(granted)
        }
        checkNow()
        NotificationCenter.default.addObserver(self, selector: #selector(checkNow), name: NSNotification.Name.UIAccessibilityGuidedAccessStatusDidChange, object: nil)
        
        return true
    }
    
    @objc func checkNow()
    {
        if UIAccessibilityIsGuidedAccessEnabled() == false
        {
            let popup = UIAlertController(title: "Guided Access Disabled", message: "Please enable the Guided Access to by triple-clicking your home button\n If it is doesn't work, please enable the Guided Access in the\nSettings > General > Accessibility > Guided Access", preferredStyle: .alert)
            let openSetting = UIAlertAction(title: "Open Settings", style: .cancel, handler: { (_) in
                let urlStr = "App-prefs:root=General&path=ACCESSIBILITY"
                UIApplication.shared.open(URL(string:urlStr)!, options: [:], completionHandler: nil)
            })
            let okay = UIAlertAction(title: "Okay", style: .default, handler: {
                [weak self](_) in
                self!.checkNow()
            })
            popup.addAction(openSetting)
            popup.addAction(okay)
            DispatchQueue.main.async {
                popup.presentExclusively(view: UIApplication.topViewController()!)
            }
        }
        else
        {
            UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        if UIAccessibilityIsGuidedAccessEnabled()
        {
            print("Screen locked or interupted")
            // 30 minutes notif to check for update
        }
        else
        {
            print("Application Minimized")
            let content = UNMutableNotificationContent()
            content.body = "Be back!"
            content.title = "You have been gone for 5 minutes"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
            let req = UNNotificationRequest(identifier: "Grouffee", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
            // every 5 minutes notif to get back to work
            // tell host that this person is now idle
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        // dont forget to clear any pending notif from the apps!
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        do
        {
            let theData = try JSONEncoder().encode(QuitData(user: self.user.name))
            try connection?.session.send(theData, toPeers: (connection?.session.connectedPeers)!, with: .reliable)
        }
        catch let error
        {
            print("quit data send error: \(error)")
        }
        
    }
    
    func broadcastRoom()
    {
        DispatchQueue.main.async {
            [weak self] in
            do
            {
                let theData = try JSONEncoder().encode(InitialData(room: (self?.room)!))
                try self?.connection?.session.send(theData, toPeers: (self?.connection?.session.connectedPeers)!, with: .reliable)
            }
            catch let error
            {
                print("broadcast room error: \(error)")
            }
        }
    }

}

