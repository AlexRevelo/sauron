//
//  SenderObjects.swift
//  Sauron
//
//  Created by Horacio Guzman on 11/21/18.
//

import Foundation

internal struct Analytic2Send: Encodable{
    var DeviceId: String
    var UserName: String
    var Section: String
    init(analytic: String){
        self.Section = analytic
        self.DeviceId = DeviceIdService.shared.DeviceId
        let defaults = SauronUserDefaults()
        self.UserName = defaults.getUsername()
    }
}

internal struct SendImages: Encodable{
    var DeviceId: String
    var Images: [String]
    init(images: [String]) {
        self.DeviceId = DeviceIdService.shared.DeviceId
        self.Images = images
    }
}
