//
//  SauronAnalytics.swift
//  Sauron
//
//  Created by Horacio Guzman on 11/21/18.
//

import Foundation

open class SauronAnalytics: NSObject{
    @objc public static func registerClick(Section: String){
        print("SauronAnalytics registerSection: \(Section).")
        if NetworkManager.canSendAnalytic() {
            NetworkService.sendAnalytic(analytics: [Analytic2Send(analytic: Section)], completion: { error in
                if error != nil{
                    print("SauronAnalytics section \(Section) error \(error?.localizedDescription ?? "").")
                    PersistanceService.shared.saveAnalytic(string: Section)
                }else{
                    print("SauronAnalytics section \(Section) uploaded.")
                }
            })
        }else{
            PersistanceService.shared.saveAnalytic(string: Section)
        }
    }
    @objc public static func AllowSendPhotos()->Bool{
        return SauronUserDefaults().getAllowSendPhotos()
    }
}
