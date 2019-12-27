
import Foundation

open class Sauron: NSObject{
    @objc public static let shared = Sauron()
    private var timerForeground: Timer?
    private var timerBackground: Timer?
    
    public override init() {
        super.init()
        //print("Hello Sauron")
        let _ = DeviceIdService.shared.DeviceId
        ////print("DeviceID: \(pru)")
        PersistanceService.shared.start()
        startForeGroundTimer()
        
        NetworkManager.shared.sendStringsOnline = { [weak self] in
            self?.sendStrings()
        }
        NetworkManager.shared.sendPhotosOnline = { [weak self] in
            self?.sendPhotos()
        }
        NetworkManager.shared.sendAnalitycsOnline = { [weak self] in
            self?.sendAnalytics()
        }
        
        let observable = SauronTimerObserver()
        observable.timerDidChange = { [weak self] in
            self?.timerDidChange()
        }
        
    }
    @objc public func requestForLocation(){
        ////print("Request for Location")
        LocationService.shared.configureLocationService()
    }
}

//MARK: - TIMERS
extension Sauron{
    
    private func timerDidChange(){
        //print("El timer ha cambiado")
        if UIApplication.shared.applicationState == .active{
            self.startForeGroundTimer()
        }else if UIApplication.shared.applicationState == .background{
            self.startBackGroundTimer()
        }
    }
    
    private func startForeGroundTimer(){
        self.invalidateTimers()
        //print("Configure timer foreground with \(SauronUserDefaults.getTimerOfUser())")
        self.timerForeground = Timer.scheduledTimer(timeInterval: SauronUserDefaults.getTimerOfUser(),
                                                    target: self,
                                                    selector: #selector(self.timerForegroundTarget(_:)),
                                                    userInfo: nil,
                                                    repeats:   true)
        
    }
    private func startBackGroundTimer(){
        self.invalidateTimers()
        //print("Configure timer background with \(SauronUserDefaults.getTimerOfUser())")
        self.timerBackground = Timer.scheduledTimer(timeInterval: SauronUserDefaults.getTimerOfUser(),
                                                    target: self,
                                                    selector: #selector(self.timerBackgroundTarget(_:)),
                                                    userInfo: nil,
                                                    repeats:   true)
    }
    private func invalidateTimers(){
        if self.timerBackground != nil && (self.timerBackground?.isValid)!{
            self.timerBackground?.invalidate()
        }
        if self.timerForeground != nil && (self.timerForeground?.isValid)!{
            self.timerForeground?.invalidate()
        }
    }
}
//MARK: - Temporizador Background
extension Sauron{
    @objc public func DidEnterBackground(){
        ////print("Sauron didEnterBackGround")
        self.startBackGroundTimer()
    }
    @objc public func WillEnterForeground(){
        ////print("Sauron didEnterForeGround")
        self.startForeGroundTimer()
        if NetworkManager.canSendString(){
            self.sendStrings()
        }
        if NetworkManager.canSendPhoto(){
            self.sendPhotos()
        }
        if NetworkManager.canSendAnalytic(){
            self.sendAnalytics()
        }
    }
}


//MARK: - timers targets
extension Sauron{
    
    @objc private func timerForegroundTarget(_ timer: Timer){
        //////print("Timer foreground fired at \(Date().HourAsString(includeSeconds: true)) sending Location at: \(LocationService.shared.lastLocation?.timestamp.HourAsString(includeSeconds: true) ?? "Default")")
        //print("timerForeground")
        self.processString()
    }
    
    @objc private func timerBackgroundTarget(_ timer: Timer){
        //////print("Timer background fired at \(Date().HourAsString(includeSeconds: true))")
        //print("Timerback")
        self.processString()
    }
    
    private func processString(){
        do{
            let str = try SauronUserDefaults().getStringToSend()
            ////print(str)
            if NetworkManager.canSendString() {
                NetworkService.sendString(string: str.toBase64()!) { (error) in
                    if error != nil{
                        ////print("Error guardando cadena \(error?.localizedDescription ?? "Error guardando cadena")")
                        PersistanceService.shared.saveString(string: str.toBase64()!)
                    }else{
                        ////print("Cadena Enviada")
                    }
                }
            }else{
                PersistanceService.shared.saveString(string: str.toBase64()!)
            }
            
        }catch{
            ////print("Error obteniendo cadena")
            ////print(error)
        }
    }
}
///MARK: - did change network status
extension Sauron {
    func sendStrings()->Void{
        ////print("Send strings SAURON ¡¡¡¡")
        do{
            let strings = try PersistanceService.shared.getStringsToSend()
            //print("Send strings \(strings.count)")
            for sendstring in strings{
                NetworkService.sendString(string: sendstring.string!) { (error) in
                    if error == nil{
                        PersistanceService.shared.removeString(item: sendstring)
                    }
                }
            }
        } catch{
            //print("Error obteniendo strings")
        }
    }
    func sendPhotos()->Void{
        do{
            let photosArray = try PersistanceService.shared.getPhotosToSend().chuncked(into: 3)
            //print("Send photos \(photosArray.count)")
            for photos in photosArray{
                let strings = photos.map { (sendPhoto) -> String in
                    return sendPhoto.photo!
                }
                NetworkService.sendImages(images: strings) { (error) in
                    if error == nil{
                        //print("\(photosArray.count) images sended")
                        PersistanceService.shared.removePhotos(items: photos)
                    }
                }
            }
        } catch{
            //print("Error obteniendo photos")
        }
    }
    func sendAnalytics()->Void{
        do{
            let analytics = try PersistanceService.shared.getAnalyticsToSend()
            let analytics2Send = analytics.map { (analytic) -> Analytic2Send in
                return Analytic2Send(analytic: analytic.analytic!)
            }
            //print("Send analytics \(analytics2Send.count)")
            if analytics2Send.count > 0{
                NetworkService.sendAnalytic(analytics: analytics2Send) { (error) in
                    if error == nil{
                        PersistanceService.shared.removeAnalytics(items: analytics)
                    }
                }
            }
        } catch{
            //print("Error obteniendo analytics")
        }
    }
}
