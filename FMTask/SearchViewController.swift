//
//  SearchViewController.swift
//  FMTask
//
//  Created by Ruslan Arhypenko on 4/13/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var artists = [Artist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
    }
    
    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        
        let artist = self.artists[indexPath.row]
        cell.nameLabel.text = artist.name
        cell.objectImageView.image = UIImage(named: "defaultSearchArtistImage")
        cell.objectImageView.layer.cornerRadius = cell.objectImageView.frame.height / 2
        
        if artist.image != nil {
            cell.objectImageView.image = artist.image
        } else if let imageURL = artist.imageURL {
            for image in imageURL {
                if image.size == "large" {
                    if let url = image.text {
                        Alamofire.request(url).responseImage { response in
                            if let image = response.result.value {
                                artist.image = image
                                DispatchQueue.main.async() {
                                    cell.objectImageView.image = image
                                }
                            }
                        }
                    }
                }
            }
        }
        artist.image = cell.objectImageView.image
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "AlbumsOverviewViewController", sender: indexPath.row)
    }
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchAction(textField)
        return true
    }

    // MARK: - Actions
  
    @IBAction func searchAction(_ sender: Any) {
        
        self.searchTextField.resignFirstResponder()
        
        if !self.searchTextField.text!.isEmpty {
            
            for (index, _) in self.artists.enumerated().reversed() {
                self.artists.remove(at: index)
                self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .right)
            }
            
            ServerManager.sharedManager.getArtistsFromAPI(artistName: self.searchTextField.text!, onSuccess: { (artists) in
                
                for (index, artist) in artists.enumerated() {
                    self.artists.append(artist)
                    self.tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .top)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            let albumOverviewViewController = segue.destination as! AlbumsOverviewViewController
            albumOverviewViewController.artist = self.artists[sender as! Int]
    }
}
