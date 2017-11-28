//
//  RoomListController.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class RoomListController: UIViewController {

    @IBOutlet weak var theTable: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        theTable.dataSource = self
        appDelegate.connection?.delegate = self
        // Do any additional setup after loading the view.
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
    func foundPeer()
    {
        theTable.reloadData()
    }
    func lostPeer()
    {
        theTable.reloadData()
    }
    func invitationWasReceived(fromPeer: String)
    {
        
    }
    func connectedWithPeer(peerID: MCPeerID, state: MCSessionState)
    {
        
    }
}
