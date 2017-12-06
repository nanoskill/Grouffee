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
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            print(granted)
        }
        return true
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
    }
    
    func broadcastRoom()
    {
        var theData = Data()
        let enc = JSONEncoder()
        do
        {
            theData = try enc.encode(room)
            try connection?.session.send(theData, toPeers: (connection?.session.connectedPeers)!, with: MCSessionSendDataMode.reliable)
        }
        catch let error
        {
            print(error)
        }
    }
    /*
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocalData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()*/

}

