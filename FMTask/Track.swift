//
//  Track.swift
//  FMTask
//
//  Created by Ruslan Arhypenko on 4/15/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

import UIKit
import ObjectMapper

class Track: Mappable {
    
    var name: String?
    var image: UIImage!
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        self.name <- map["name"]
    }
    
    init(coreDataModel: CDTrack) {
        self.name = coreDataModel.name!
        self.image = UIImage(data: coreDataModel.image! as Data)
    }
}
