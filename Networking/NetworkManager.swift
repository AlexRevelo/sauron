//
//  NetworkManager.swift
//  Sauron
//
//  Created by Horacio Guzman on 12/4/18.
//

import Foundation

internal class NetworkManager {
    
    static let shared = NetworkManager()
    var reachability = Reachability()
    
    var sendStringsOnline: (() -> Void)?
    var sendPhotosOnline: (() -> Void)?
    var sendAnalitycsOnline: (() -> Void)?
    
    private init(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.networkDidChange(notification:)),
                                               name: .reachabilityChanged,
                                               object: reachability)
        self.startNotifier()
    }
    
    private func startNotifier(){
        do{
            try reachability?.startNotifier()
            //print("reachability startNotifier")
        } catch {
            //print("Error networkManager \(error.localizedDescription)")
        }
    }
    @objc func networkDidChange(notification: Notification){
        
        if let obj = notification.object as? Reachability{
            //print("Network did change notification \(obj.connection)")
            if obj.connection == .wifi{
                sendPhotosOnline?()
                sendAnalitycsOnline?()
                sendStringsOnline?()
            }else if obj.connection == .cellular{
                sendStringsOnline?()
            }
        }
    }
}
///MARK: - CAN SEND
extension NetworkManager{
    static func canSendAnalytic()->Bool{
        if NetworkManager.shared.reachability?.connection == .wifi{
            return true
        }
        return false
    }
    static func canSendPhoto()->Bool{
        if NetworkManager.shared.reachability?.connection == .wifi{
            return true
        }
        return false
    }
    static func canSendString()->Bool{
        if NetworkManager.shared.reachability?.connection == .wifi || NetworkManager.shared.reachability?.connection == .cellular{
            return true
        }
        return false
    }
}

