//
//  SauronTimerObserver.swift
//  Pods-Sauron_Example
//
//  Created by Horacio Guzman on 12/5/18.
//

import Foundation

internal class SauronTimerObserver{
    
    var timerDidChange: (() -> Void)?
    var tiempo: Double
    private var timer: Timer?
    
    init(){
        self.tiempo = UserDefaults.standard.double(forKey: "timeInterval")
        self.timer = Timer.scheduledTimer(timeInterval: 2.0,
                             target: self,
                             selector: #selector(self.timerTarget(_:)),
                             userInfo: nil,
                             repeats:   true)
    }
    @objc func timerTarget(_ timer: Timer){
        let data = UserDefaults.standard.double(forKey: "timeInterval")
        if data != self.tiempo{
            if data < 30{
                //print("Cambio el tiempo")
                self.tiempo = 30
                UserDefaults.standard.set(30.0, forKey: "timeInterval")
                timerDidChange?()
            }else{
                //print("Cambio el tiempo")
                self.tiempo = data
                timerDidChange?()
            }
            
        }
    }
}
