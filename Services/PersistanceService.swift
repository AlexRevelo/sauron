//
//  PersistanceService.swift
//  Sauron
//
//  Created by Horacio Guzman on 11/26/18.
//

import Foundation

internal class PersistanceService{
    
    public static let shared = PersistanceService()
    private init(){
    }
    public func start(){
        //print("Started")
        let _ = SauronCoreDataManager.sharedManager.persistanceContainer
    }
    
    private var SauronCoreDataQueue = DispatchQueue(label: "SauronCoreDataQueue")
    
}

//MARK: - SAVE DATA
extension PersistanceService{
    public func saveString(string: String){
        SauronCoreDataQueue.sync {
            let item = SendString(context: SauronCoreDataManager.sharedManager.persistanceContainer.viewContext)
            item.date = Date().toMillis()
            item.string = string
            SauronCoreDataManager.sharedManager.saveContext()
        }
    }
    public func savePhoto(string: String){
        SauronCoreDataQueue.sync {
            let item = SendPhoto(context: SauronCoreDataManager.sharedManager.persistanceContainer.viewContext)
            item.date = Date().toMillis()
            item.photo = string
            SauronCoreDataManager.sharedManager.saveContext()
        }
    }
    public func saveAnalytic(string: String){
        SauronCoreDataQueue.sync {
            let item = SendAnalytic(context: SauronCoreDataManager.sharedManager.persistanceContainer.viewContext)
            item.date = Date().toMillis()
            item.analytic = string
            SauronCoreDataManager.sharedManager.saveContext()
        }
    }
}
///MARK: - GET DATA TO SEND
extension PersistanceService{
    func getStringsToSend() throws -> [SendString]{
        return try SauronCoreDataManager.sharedManager.getStrings()
    }
    func getPhotosToSend() throws -> [SendPhoto]{
        return try SauronCoreDataManager.sharedManager.getPhotos()
    }
    func getAnalyticsToSend() throws -> [SendAnalytic]{
        return try SauronCoreDataManager.sharedManager.getAnalytics()
    }
}

///MARK: - Eliminar Items
extension PersistanceService{
    func removeString(item: SendString){
        SauronCoreDataManager.sharedManager.persistanceContainer.viewContext.delete(item)
        SauronCoreDataManager.sharedManager.saveContext()
    }
    func removePhotos(items: [SendPhoto]){
        for photo in items{
            SauronCoreDataManager.sharedManager.persistanceContainer.viewContext.delete(photo)
        }
        SauronCoreDataManager.sharedManager.saveContext()
    }
    func removeAnalytics(items: [SendAnalytic]){
        for analytic in items{
            SauronCoreDataManager.sharedManager.persistanceContainer.viewContext.delete(analytic)
        }
        SauronCoreDataManager.sharedManager.saveContext()
    }
}
