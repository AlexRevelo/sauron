//
//  SauronUserDefaultsHelper.swift
//  Sauron
//
//  Created by Horacio Guzman on 11/20/18.
//

import Foundation


internal class SauronUserDefaults {
    
    private let defaults = UserDefaults.standard
    
    public init(){ }
    
    public func getStringToSend() throws -> String {
        var string = "<"
        
        let arre = try getPhoneInformation() + getLocationInformation() + getUserInformation() + gettimeStamp()
        string += arre.joined(separator: ";")
        
        string += ">"
        return string
    }
    
    public func getUsername()->String{
        return defaults.string(forKey: "username") ?? "Guest"
    }
    
    public func getAllowSendPhotos() -> Bool{
        return defaults.bool(forKey: "allowSendPhotos")
    }
}


//MARK: - String to send
extension SauronUserDefaults{
    
    private func getPhoneInformation() throws -> [String]{
        guard let udid = defaults.string(forKey: "DeviceId") else {
            throw SauronError(description: "Something goes wrong whit the IMEI/UDID please contact to admin of Sauron")
        }
        
        let username = self.getUsername()
        let country = defaults.string(forKey: "country") ?? ""
        let language = Locale.preferredLanguages[0]
        UIDevice.current.isBatteryMonitoringEnabled = true
        let battery = "\(UIDevice.current.batteryLevel * 100)"
        
        let keys = [
            udid,
            username,
            country,
            language,
            battery
        ]
        return keys
    }
    
    private func getLocationInformation() throws -> [String]{
        guard let location = LocationService.shared.lastLocation else {
            throw SauronError(description: "Something goes wrong whit the User Location please contact to admin of Sauron")
        }
        
        let latitude = "\(location.coordinate.latitude)"
        let longitude = "\(location.coordinate.longitude)"
        let accuracy = "\(location.horizontalAccuracy)"
        let speed = "\(location.speed)"
        
        let keys = [
            latitude,
            longitude,
            accuracy,
            speed
        ]
        return keys
    }
    
    private func getUserInformation() -> [String]{
        let userEmail = defaults.string(forKey: "userEmail") ?? ""
        let userAge = defaults.string(forKey: "userAge") ?? ""
        let userGender = defaults.string(forKey: "userGender") ?? ""
        let userFirstName = defaults.string(forKey: "userFirstName") ?? ""
        let userLastName = defaults.string(forKey: "userLastName") ?? ""
        let userSocialNetwork = defaults.string(forKey: "userSocialNetwork") ?? ""
        let userPicture = defaults.string(forKey: "userPicture") ?? ""
        
        let keys = [
            userEmail,
            userAge,
            userGender,
            userFirstName,
            userLastName,
            userSocialNetwork,
            userPicture
        ]
        
        return keys
    }
    
    private func gettimeStamp()->[String]{
        let timeStamp = "\(Date().timeIntervalSince1970 * 1000)"
        let keys = [
            timeStamp
        ]
        return keys
    }
    
}

///MARK: - timer
extension SauronUserDefaults{
   static func getTimerOfUser()->Double{
        let data = UserDefaults.standard.double(forKey: "timeInterval")
        if data <= 0 {
            return 60.0
        }else{
            return data
        }
    }
}
