//
//  DeviceIdService.swift
//  Sauron
//
//  Created by Horacio Guzman on 11/21/18.
//

import Foundation


internal class DeviceIdService{
    
    static let shared = DeviceIdService()
    
    private(set) var DeviceId: String
    
    private init(){
        if let di = UserDefaults.standard.string(forKey: "DeviceId"){
            self.DeviceId = di
        }else{
            self.DeviceId = UUID().description
            UserDefaults.standard.set(self.DeviceId, forKey: "DeviceId")
        }
    }
    
}
