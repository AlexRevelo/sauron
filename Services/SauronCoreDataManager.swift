//
//  SauronCoreDataManager.swift
//  Pods-Sauron_Example
//
//  Created by Horacio Guzman on 12/4/18.
//
import Foundation
import CoreData

internal class SauronCoreDataManager{
    static let sharedManager = SauronCoreDataManager()
    private init(){}
    lazy var persistanceContainer: NSPersistentContainer = {
        //print("persistance container")
        let bundle = Bundle(for: Sauron.self)
        guard let mom = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            fatalError()
        }
        let container = NSPersistentContainer(name: "SauronDataModel", managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { (description, error) in
            if error != nil{
                //print("Error loading stores")
            }else{
                //print("loading stores complete")
            }
        })
        return container
    }()
    
    func saveContext(){
        let context = SauronCoreDataManager.sharedManager.persistanceContainer.viewContext
        if context.hasChanges{
            do{
                try context.save()
            }catch{
                //print("Error saving context \(error.localizedDescription)")
            }
        }
    }
}
///MARK: - GET VALUES
extension SauronCoreDataManager{
    func getStrings() throws -> [SendString]{
        let request: NSFetchRequest<SendString> = SendString.fetchRequest()
        return try SauronCoreDataManager.sharedManager.persistanceContainer.viewContext.fetch(request)
    }
    func getPhotos() throws -> [SendPhoto]{
        let request: NSFetchRequest<SendPhoto> = SendPhoto.fetchRequest()
        return try SauronCoreDataManager.sharedManager.persistanceContainer.viewContext.fetch(request)
    }
    func getAnalytics() throws -> [SendAnalytic]{
        let request: NSFetchRequest<SendAnalytic> = SendAnalytic.fetchRequest()
        return try SauronCoreDataManager.sharedManager.persistanceContainer.viewContext.fetch(request)
    }
}
