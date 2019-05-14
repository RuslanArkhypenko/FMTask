//
//  CDTrack+CoreDataProperties.swift
//  FMTask
//
//  Created by Ruslan Arhypenko on 4/19/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//
//

import Foundation
import CoreData


extension CDTrack {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTrack> {
        return NSFetchRequest<CDTrack>(entityName: "CDTrack")
    }

    @NSManaged public var image: NSData?
    @NSManaged public var name: String?
    @NSManaged public var owner: CDAlbum?

}
