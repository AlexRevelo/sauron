//
//  DateExtensions.swift
//  Pods-Sauron_Example
//
//  Created by Horacio Guzman on 11/16/18.
//

import Foundation


extension Date{
    func HourAsString(includeSeconds: Bool)->String{
        let formater = DateFormatter()
        if includeSeconds == true{
            formater.dateFormat = "hh:mm:ss a"
        }else{
            formater.dateFormat = "hh:mm a"
        }
        formater.timeZone = TimeZone.current
        return formater.string(from: self)
    }
    func toMillis() -> Int64!{
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
