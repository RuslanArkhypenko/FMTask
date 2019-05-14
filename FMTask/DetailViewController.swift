//
//  DetailViewController.swift
//  FMTask
//
//  Created by Ruslan Arhypenko on 4/12/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var album: Album!
    var artist: Artist!
    var tracks: [Track]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        fillAlbumInfo()
        addRightBarButtonItem()
    }
    
    func fillAlbumInfo() {
        self.artistNameLabel.text = self.album.artist
        self.albumNameLabel.text = "Album: \(self.album.name!)"
        self.artistImageView.image = self.artist.image
        self.artistImageView.layer.cornerRadius = self.artistImageView.frame.height / 2
        
        if self.tracks.isEmpty {
            if let albumName = self.album.name {
                getArtistTracksFromAPI(albumName: albumName)
            }
        }
    }
    
    func addRightBarButtonItem() {
        
        if !self.album.isStored {
            let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemTapped(_:)))
            addBarButtonItem.accessibilityIdentifier = "add"
            self.navigationItem.rightBarButtonItem = addBarButtonItem
        } else {
            let deleteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(addBarButtonItemTapped(_:)))
            deleteBarButtonItem.accessibilityIdentifier = "delete"
            self.navigationItem.rightBarButtonItem = deleteBarButtonItem
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        let track = self.tracks[indexPath.row]
        cell.nameLabel.text = track.name
        cell.objectImageView.image = self.album.image
        cell.objectImageView.layer.cornerRadius = cell.objectImageView.frame.height / 2
        return cell
    }
    
    //MARK: - Actions
    
    @objc func addBarButtonItemTapped(_ sender: UIBarButtonItem) {
        
        switch sender.accessibilityIdentifier {
        case "add":
            self.album.isStored = true
            CoreDataManager.sharedManager.storeAlbum(storeAlbum: self.album, storeArtist: self.artist)
        case "delete":
            self.album.isStored = false
            if let albumName = self.album.name {
                CoreDataManager.sharedManager.deleteAlbum(albumName: albumName)
            }
        default: return
        }
        addRightBarButtonItem()
    }

    //MARK: - API
    
    func getArtistTracksFromAPI(albumName: String) {
        
        if let artistName = self.artist.name {
            ServerManager.sharedManager.getArtistTracksFromAPI(artistName: artistName, albumName: albumName, onSuccess: { (tracks) in
            
                for (index, track) in tracks.enumerated() {
                    self.tracks.append(track)
                    self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .top)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
}
