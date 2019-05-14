//
//  Artist.swift
//  FMTask
//
//  Created by Ruslan Arhypenko on 4/13/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

import UIKit
import ObjectMapper

class Artist: Mappable {
    
    var name: String?
    var listeners: String?
    var imageURL: [ImageURL]?
    var mbid: String?
    var image: UIImage!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.name <- map["name"]
        self.listeners <- map["listeners"]
        self.mbid <- map["mbid"]
        self.imageURL <- map["image"]
    }
    
    init(coreDataModel: CDAlbum) {
        self.name = coreDataModel.artistName!
        self.image = UIImage(data: coreDataModel.artistImage! as Data)
    }
}

struct ImageURL: Mappable {
    
    var text: String?
    var size: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        self.text <- map["#text"]
        self.size <- map["size"]
    }
}
