//
//  ConnectionModel.swift
//  Grouffee
//
//  Created by Christhopher Ravian Hartono on 28/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import Foundation
import MultipeerConnectivity


import Foundation
import MultipeerConnectivity

public protocol ConnectionModelDelegate {
    func foundPeer()
    func lostPeer()
    func invitationWasReceived(fromPeer: String)
    func connectedWithPeer(peerID: MCPeerID, state: MCSessionState)
}

class ConnectionModel : NSObject
{
    let connIdentifier = "grouffee-conn"
    
    let myPeerId : MCPeerID!
    
    let serviceAdvertiser : MCNearbyServiceAdvertiser
    let serviceBrowser : MCNearbyServiceBrowser
    
    var session: MCSession!
    
    var foundPeers = [MCPeerID]()
    
    var delegate: ConnectionModelDelegate?
    
    var invitationHandler: ((Bool, MCSession?)->Void)!
    
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
        delegate?.invitationWasReceived(fromPeer: peerID.displayName)
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
        delegate?.lostPeer()
    }
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        foundPeers.append(peerID)
        
        print("Peer found \(peerID.displayName)")
        print(foundPeers)
        delegate?.foundPeer()
    }
}

extension ConnectionModel: MCSessionDelegate
{
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        delegate?.connectedWithPeer(peerID: peerID, state: state)
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
}
