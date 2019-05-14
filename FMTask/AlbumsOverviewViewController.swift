//
//  AlbumsOverviewViewController.swift
//  FMTask
//
//  Created by Ruslan Arhypenko on 4/13/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

class AlbumsOverviewViewController: CollectionViewFlowLayout, UICollectionViewDataSource, AlbumCollectionViewCellDelegate {
        
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var artist: Artist!
    var albums = [Album]()
    var tracks = [Track]()
    var isViewDidAppear = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName:"AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCell")
        self.navigationItem.rightBarButtonItem = editButtonItem

        fillArtistInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.isViewDidAppear {
            let indexPath = self.collectionView.indexPathsForVisibleItems
            self.collectionView.reloadItems(at: indexPath)
        }
        self.isViewDidAppear = true
    }
    
    func fillArtistInfo() {
        self.artistNameLabel.text = self.artist.name
        self.artistImageView.image = self.artist.image
        self.artistImageView.layer.cornerRadius = self.artistImageView.frame.height / 2
        
        if let artistName = self.artist.name {
            getArtistAlbumFromAPI(artistName: artistName)
        }
    }
    
    //MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCollectionViewCell
        cell.delegate = self

        let album = self.albums[indexPath.row]
        cell.nameLabel.text = album.name
        cell.isStored = album.isStored
        cell.isEditing = album.isEditing
        cell.albumImage.image = UIImage(named: "defaultAlbumIcon")
        
        if album.image != nil {
            cell.albumImage.image = album.image
        } else if let imageURL = album.imageURL {
            for image in imageURL {
                if image.size == "large" {
                    if let url = image.text {
                        Alamofire.request(url).responseImage { response in
                            if let image = response.result.value {
                                album.image = image
                                DispatchQueue.main.async() {
                                    cell.albumImage.image = image
                                }
                            }
                        }
                    }
                }
            }
        }
        album.image = cell.albumImage.image
        return cell
    }

    //MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailViewController", sender: indexPath.row)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        for album in self.albums {
            album.isEditing = editing
        }
        
        let indexPath = self.collectionView.indexPathsForVisibleItems
        self.collectionView.reloadItems(at: indexPath)
    }
    
    //MARK: - AlbumCollectionViewCellDelegate
    
    func deliteItem(cell: AlbumCollectionViewCell) {
        if let indexPath = self.collectionView.indexPath(for: cell) {
            self.albums[indexPath.row].isStored = false
            self.albums[indexPath.row].isEditing = true
            self.collectionView.reloadItems(at: [indexPath])
            CoreDataManager.sharedManager.deleteAlbum(albumName: cell.nameLabel.text!)
        }
    }
    
    func storeItem(cell: AlbumCollectionViewCell) {
        if let indexPath = self.collectionView.indexPath(for: cell) {
            self.albums[indexPath.row].isStored = true
            CoreDataManager.sharedManager.storeAlbum(storeAlbum: self.albums[indexPath.row], storeArtist: self.artist)
            self.collectionView.reloadItems(at: [indexPath])
        
            getArtistTracksFromAPI(albumName: cell.nameLabel.text!) { (tracks) in
        
                self.tracks = tracks
                CoreDataManager.sharedManager.storeTracks(storeTracks: self.tracks, albumImage: self.albums[indexPath.row].image)
            }
        }
    }
 
    //MARK: - API
    
    func getArtistAlbumFromAPI(artistName: String) {
        
        ServerManager.sharedManager.getArtistAlbumsFromAPI(artistName: artistName, onSuccess: { (albums) in
    
            for (index, album) in albums.enumerated() {
                
                if let albumName = album.name {
                    CoreDataManager.sharedManager.fetchAlbumWithName(albumName: albumName, complition: { (isStored, albums) in
                        album.isStored = isStored
                        self.albums.append(album)
                        self.collectionView.insertItems(at: [IndexPath(row: index, section: 0)])
                    })
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getArtistTracksFromAPI(albumName: String, complition:@escaping (_ tracks:[Track]) -> ()) {
        
        if let artistName = self.artist.name {
        
            ServerManager.sharedManager.getArtistTracksFromAPI(artistName: artistName, albumName: albumName, onSuccess: { (tracks) in
                complition(tracks)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.album = self.albums[sender as! Int]
        detailViewController.artist = self.artist
        detailViewController.tracks = self.tracks
    }
}
