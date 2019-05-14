//
//  Album.swift
//  FMTask
//
//  Created by Ruslan Arhypenko on 4/13/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

import UIKit
import ObjectMapper

class Album: Mappable {

    var name: String?
    var artist: String?
    var imageURL: [ImageURL]?
    var mbid: String?
    var image: UIImage!
    var isStored: Bool!
    var isEditing = false
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.name <- map["name"]
        self.artist <- map["artist"]
        self.mbid <- map["mbid"]
        self.imageURL <- map["image"]
    }
    
    init(coreDataModel: CDAlbum) {
        self.name = coreDataModel.albumName!
        self.artist = coreDataModel.artistName!
        self.mbid = coreDataModel.mbid!
        self.image = UIImage(data: coreDataModel.albumImage! as Data)
        self.isStored = coreDataModel.isStored
    }
}
