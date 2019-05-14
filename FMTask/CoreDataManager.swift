//
//  CoreDataManager.swift
//  FMTask
//
//  Created by Ruslan Arhypenko on 4/16/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    
    static let sharedManager = CoreDataManager()
    
    // MARK: - Core Data store functions
    
    func storeAlbum(storeAlbum: Album, storeArtist: Artist) {
        
        let album = NSEntityDescription.insertNewObject(forEntityName: "CDAlbum", into: self.persistentContainer.viewContext) as! CDAlbum
        
        album.artistName = storeArtist.name
        album.albumName = storeAlbum.name
        album.albumImage = storeAlbum.image?.pngData() as NSData?
        album.artistImage = storeArtist.image?.pngData() as NSData?
        album.isStored = storeAlbum.isStored
        album.mbid = storeAlbum.mbid
        
        try! album.managedObjectContext?.save()
    }
    
    func storeTracks(storeTracks: [Track], albumImage: UIImage) {
        
        let track = NSEntityDescription.insertNewObject(forEntityName: "CDTrack", into: self.persistentContainer.viewContext) as! CDTrack
        
        for obj in storeTracks {
            track.name = obj.name
            track.image = albumImage.pngData() as NSData?
            try! track.managedObjectContext?.save()
        }
    }
    
    // MARK: - Core Data fetch functions
    
    func fetchAlbumWithName(albumName: String, complition:@escaping (_ isStored: Bool, _ albums: [CDAlbum]) -> ()) {
        
        let fetchRequest = NSFetchRequest<CDAlbum>(entityName: "CDAlbum")
        let predicate = NSPredicate(format: "albumName = %@", albumName)
        fetchRequest.predicate = predicate
        
        let result = try! self.persistentContainer.viewContext.fetch(fetchRequest)
        
        if result.isEmpty {
            complition(false, result)
        } else {
            complition(true, result)
        }
    }
    
    // MARK: - Core Data delete functions
    
    func deleteAlbum(albumName: String) {
        
        let fetchRequest = NSFetchRequest<CDAlbum>(entityName: "CDAlbum")
        let predicate = NSPredicate(format: "albumName = %@", albumName)
        fetchRequest.predicate = predicate

        let result = try! self.persistentContainer.viewContext.fetch(fetchRequest)
        
        for album in result {
            self.persistentContainer.viewContext.delete(album)
        }
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "FMTask")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
