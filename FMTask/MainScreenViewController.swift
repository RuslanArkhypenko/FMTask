//
//  MainScreenViewController.swift
//  FMTask
//
//  Created by Ruslan Arhypenko on 4/12/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

import UIKit
import CoreData

class MainScreenViewController: CollectionViewFlowLayout, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        self.collectionView.register(UINib(nibName:"AlbumCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AlbumCell")
    }
    
    //MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCollectionViewCell
        let album = fetchedResultsController.object(at: indexPath)
        
        configureCell(cell, withAlbum: album)
        return cell
    }
    
    //MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = self.collectionView.cellForItem(at: indexPath) as? AlbumCollectionViewCell {
            self.performSegue(withIdentifier: "DetailViewController", sender: cell.nameLabel.text)
        }
    }
    
    func configureCell(_ cell: AlbumCollectionViewCell, withAlbum album: CDAlbum) {
        cell.nameLabel.text = album.albumName
        cell.albumImage.image = UIImage(data: album.albumImage! as Data)
        cell.stateButton.isEnabled = false
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DetailViewController" {
            CoreDataManager.sharedManager.fetchAlbumWithName(albumName: sender as! String) { (isStored, albums) in
                for obj in albums {
                    
                    var tracks = [Track]()
                    let album = Album.init(coreDataModel: obj)
                    let artist = Artist.init(coreDataModel: obj)
                    
                    for obj in obj.track! {
                        let track = Track.init(coreDataModel: obj as! CDTrack)
                        tracks.append(track)
                    }
                    
                    let detailViewController = segue.destination as! DetailViewController
                    detailViewController.album = album
                    detailViewController.artist = artist
                    detailViewController.tracks = tracks
                }
            }
        }
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<CDAlbum> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<CDAlbum> = CDAlbum.fetchRequest()
        
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = NSSortDescriptor(key: "albumName", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.sharedManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<CDAlbum>? = nil
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView.reloadData()
    }
}
