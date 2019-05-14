//
//  AlbumCollectionViewCell.swift
//  FMTask
//
//  Created by Ruslan Arhypenko on 4/14/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

import UIKit

protocol AlbumCollectionViewCellDelegate: class {
    
    func deliteItem(cell: AlbumCollectionViewCell)
    func storeItem(cell: AlbumCollectionViewCell)
}

class AlbumCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: AlbumCollectionViewCellDelegate?
    
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var actionBackgroundView: UIView!
    @IBOutlet weak var buttonImageView: UIImageView!
    @IBOutlet weak var stateButton: UIButton!
    
    var isStored: Bool! {
        didSet {
            if self.isStored {
                self.buttonImageView.image = UIImage(named: "StoredCellAction")
            } else {
                self.stateButton.isEnabled = false
                self.buttonImageView.image = nil
            }
        }
    }
    
    var isEditing: Bool! {
        didSet {
            if self.isEditing {
                self.stateButton.isEnabled = true
                if self.isStored {
                    self.buttonImageView.image = UIImage(named: "DeleteCellAction")
                } else {
                    self.buttonImageView.image = UIImage(named: "AddCellAction")
                }
            } else {
                if self.isStored {
                    self.buttonImageView.image = UIImage(named: "StoredCellAction")
                } else {
                    self.stateButton.isEnabled = false
                    self.buttonImageView.image = nil
                }
            }
        }
    }
    
    @IBAction func cellAction(_ sender: UIButton) {
        if self.isEditing {
            if self.isStored {
                delegate?.deliteItem(cell: self)
            } else {
                delegate?.storeItem(cell: self)
            }
        }
    }
}
