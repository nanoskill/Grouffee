//
//  RoomListController.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import Dispatch

class RoomListController: UIViewController {

    @IBOutlet weak var theTable: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var connectingPeer : MCPeerID?
    override func viewDidLoad() {
        super.viewDidLoad()
        theTable.dataSource = self
        theTable.delegate = self
        appDelegate.connection?.delegate = self
    }
}

extension RoomListController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (appDelegate.connection?.foundPeers.count)!
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = theTable.dequeueReusableCell(withIdentifier: "RoomListCell")
        cell!.textLabel!.text = appDelegate.connection?.foundPeers[indexPath.row].displayName
        return cell!
    }
}

extension RoomListController : ConnectionModelDelegate
{
    func foundPeer(peer: MCPeerID)
    {
        
        theTable.reloadData()
    }
    func lostPeer(peer: MCPeerID)
    {
        theTable.reloadData()
        if peer == connectingPeer
        {
            let popup = UIAlertController.createOkayPopup(title: "Disconnected", message: "Connection lost with \(peer.displayName)", handler: nil)
            DispatchQueue.main.async {
                popup.presentExclusively(view: self)
            }
        }
    }
    func connectedWithPeer(peerID: MCPeerID, state: MCSessionState)
    {
        if state == .connected
        {
            let popup = UIAlertController.createOkayPopup(title: "Connected", message: "You are now connected with \(peerID.displayName)", handler: {
                (_) in
                self.appDelegate.room = Room(name: "Not Sync Yet", leader: self.appDelegate.user, duration: 3600)
                self.performSegue(withIdentifier: "enterBoardSegue", sender: nil)
            })
            DispatchQueue.main.async {
                popup.presentExclusively(view: self)
            }
            connectingPeer = nil
            self.appDelegate.connection?.serviceBrowser.stopBrowsingForPeers()
        }
        if state == .notConnected
        {
            var t = "Disconnected"
            var m = "Connection lost with \(peerID.displayName)"
            if connectingPeer == peerID
            {
                t = "Declined"
                m = "\(peerID.displayName) has declined your request to join"
            }
            let popup = UIAlertController.createOkayPopup(title: t, message: m, handler: nil)
            DispatchQueue.main.async {
                popup.presentExclusively(view: self)
            }
            connectingPeer = nil
        }
    }
}

extension RoomListController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedPeer = (appDelegate.connection?.foundPeers[indexPath.row])!
        appDelegate.connection?.serviceBrowser.invitePeer(selectedPeer, to: (appDelegate.connection?.session)!, withContext: nil, timeout: 10) //need guard
        
        let popup = UIAlertController(title: selectedPeer.displayName, message: "Waiting for response", preferredStyle: .alert)
        connectingPeer = selectedPeer
        /*
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        popup.view.addSubview(indicator)
        indicator.center = popup.view.center
 
        let views = ["pending" : popup.view!, "indicator" : indicator]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[indicator]-(-20)-|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|[indicator]|", options: [], metrics: nil, views: views)
        popup.view.addConstraints(constraints)
 
        popup.setValue(indicator, forKey: "accessoryView")
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        */
        DispatchQueue.main.async {
            popup.presentExclusively(view: self)
        }
        
    }
}
