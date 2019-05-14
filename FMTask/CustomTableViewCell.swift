//
//  CustomTableViewCell.swift
//  FMTask
//
//  Created by Ruslan Arhypenko on 4/15/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var objectImageView: UIImageView! 
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let customColorView = UIView()
        customColorView.backgroundColor = UIColor(red: 218/255.0, green: 34/255.0, blue: 68/255.0, alpha: 0.75)
        customColorView.layer.cornerRadius = 8
        self.selectedBackgroundView =  customColorView
    }
}
