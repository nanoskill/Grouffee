//
//  ConnectionModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import Foundation
import MultipeerConnectivity

@objc public protocol ConnectionModelDelegate {
    @objc optional func foundPeer(peer: MCPeerID)
    @objc optional func lostPeer(peer: MCPeerID)
    @objc optional func invitationWasReceived(fromPeer: MCPeerID)
    @objc optional func connectedWithPeer(peerID: MCPeerID, state: MCSessionState)
}

class ConnectionModel : NSObject
{
    let connIdentifier = "grouffee-conn"
    
    let myPeerId : MCPeerID!
    
    let serviceAdvertiser : MCNearbyServiceAdvertiser
    let serviceBrowser : MCNearbyServiceBrowser
    
    var session: MCSession
    
    var foundPeers = [MCPeerID]()
    
    var delegate: ConnectionModelDelegate?
    
    var invitationHandler: ((Bool, MCSession?)->Void)!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    init(peerId : MCPeerID) {
        myPeerId = peerId
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: connIdentifier)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: connIdentifier)
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .optional)
        
        super.init()
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
        session.delegate = self
    }
    
    func terminateBroadcast()
    {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
        foundPeers.removeAll()
    }
    
    deinit {
        terminateBroadcast()
    }
}

extension ConnectionModel : MCNearbyServiceAdvertiserDelegate
{
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        self.invitationHandler = invitationHandler
        
        delegate?.invitationWasReceived?(fromPeer: peerID)
    }
}

extension ConnectionModel : MCNearbyServiceBrowserDelegate
{
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        for (index,aPeer) in foundPeers.enumerated(){
            if aPeer == peerID {
                foundPeers.remove(at: index)
                break
            }
        }
        print("Peer lost \(peerID.displayName)")
        print(foundPeers)
        delegate?.lostPeer?(peer: peerID)
    }
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        foundPeers.append(peerID)
        
        print("Peer found \(peerID.displayName)")
        print(foundPeers)
        delegate?.foundPeer?(peer: peerID)
    }
}/*

extension ConnectionModel: MCSessionDelegate
{
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        delegate?.connectedWithPeer?(peerID: peerID, state: state)
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
    {
        
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {
        
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress)
    {
        
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?)
    {
        
    }
}*/

extension ConnectionModel : MCSessionDelegate
{
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        print("connectedWithPeer")
        appDelegate.connection?.delegate?.connectedWithPeer!(peerID: peerID, state: state)
        if state == .connected
        {
            if appDelegate.user.type == .leader
            {
                appDelegate.broadcastRoom()
            }
            /*
             var theData = Data()
             let enc = JSONEncoder()
             do
             {
             theData = try enc.encode(self.appDelegate.room)
             
             var tempArray = [MCPeerID]()
             tempArray.append(peerID)
             try self.appDelegate.connection?.session.send(theData, toPeers: tempArray, with: MCSessionSendDataMode.reliable)
             }
             catch let error
             {
             print(error)
             }
             */
        }
    }
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
    {
        var theArray : [String:Any]?
        let decoder = JSONDecoder()
        do
        {
            theArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
            let dataType =  (theArray!["data_type"] as! String)
            print("incoming data \(dataType)\n\(theArray!)")
            if appDelegate.user.type == .member
            {
                if dataType == "init_data"{
                    let decodedData = try decoder.decode(InitialData.self, from: data)
                    appDelegate.room = decodedData.room
                }
            }
            else
            {
                if dataType == "join_data"
                {
                    let decodedData = try decoder.decode(JoinData.self, from: data)
                    decodedData.targetBoard.joinBoard(user: decodedData.user) //need verification
                }
                if dataType == "exit_data"
                {
                    let decodedData = try decoder.decode(ExitData.self, from: data)
                    decodedData.fromBoard.exitBoard(user: decodedData.user)
                }
                if dataType == "request_data"
                {
                    appDelegate.broadcastRoom()
                }
            }
        }
        catch let error
        {
            print(error)
        }
    }
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {
        
    }
    
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress)
    {
        
    }
    
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?)
    {
        
    }
}
