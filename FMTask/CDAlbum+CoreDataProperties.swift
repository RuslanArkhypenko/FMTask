//
//  CDAlbum+CoreDataProperties.swift
//  FMTask
//
//  Created by Ruslan Arhypenko on 4/19/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//
//

import Foundation
import CoreData


extension CDAlbum {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAlbum> {
        return NSFetchRequest<CDAlbum>(entityName: "CDAlbum")
    }

    @NSManaged public var albumImage: NSData?
    @NSManaged public var albumName: String?
    @NSManaged public var artistImage: NSData?
    @NSManaged public var artistName: String?
    @NSManaged public var isStored: Bool
    @NSManaged public var isEditing: Bool
    @NSManaged public var mbid: String?
    @NSManaged public var track: NSSet?

}

// MARK: Generated accessors for track
extension CDAlbum {

    @objc(addTrackObject:)
    @NSManaged public func addToTrack(_ value: CDTrack)

    @objc(removeTrackObject:)
    @NSManaged public func removeFromTrack(_ value: CDTrack)

    @objc(addTrack:)
    @NSManaged public func addToTrack(_ values: NSSet)

    @objc(removeTrack:)
    @NSManaged public func removeFromTrack(_ values: NSSet)

}
