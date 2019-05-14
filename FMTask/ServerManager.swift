//
//  ServerManager.swift
//  FMTask
//
//  Created by Ruslan Arhypenko on 4/12/19.
//  Copyright © 2019 Ruslan Arhypenko. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

class ServerManager: NSObject {
    
    static let sharedManager = ServerManager()
    
    func getArtistsFromAPI(artistName: String, onSuccess:@escaping (_ artists:[Artist]) -> (), onFailure: @escaping (_ error: Error) -> ()) {
        
        let incomingString = "https://ws.audioscrobbler.com/2.0/?method=artist.search&artist=\(artistName)&api_key=a39589d3029edd07e857ccf43e895569&format=json"
        
        let urlString = incomingString.replacingOccurrences(of: " ", with: "%20")
        
        let encodedString = String(utf8String: urlString.cString(using: String.Encoding.utf8)!)!
                
        Alamofire.request(encodedString).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let JSON = value as? [String : Any] else { return }
                guard let results = JSON["results"] as? [String : Any] else { return }
                guard let artistmatches = results["artistmatches"] as? [String : Any] else { return }
                guard let artists = artistmatches["artist"] as? [NSDictionary] else { return }
                
                var artistsArray = [Artist]()
                
                for obj in artists {
                    let artist = Mapper<Artist>().map(JSONObject: obj)
                    artistsArray.append(artist!)
                }
                
                onSuccess(artistsArray)
            case .failure(let error):
                onFailure(error)
            }
        }
    }
    
    func getArtistAlbumsFromAPI(artistName: String, onSuccess:@escaping (_ albums:[Album]) -> (), onFailure: @escaping (_ error: Error) -> ()) {
        
        let incomingString = "https://ws.audioscrobbler.com/2.0/?method=album.search&album=\(artistName)&api_key=a39589d3029edd07e857ccf43e895569&format=json"
        
        let urlString = incomingString.replacingOccurrences(of: " ", with: "%20")
        
        let encodedString = String(utf8String: urlString.cString(using: String.Encoding.utf8)!)!
        
        Alamofire.request(encodedString).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let JSON = value as? [String : Any] else { return }
                guard let results = JSON["results"] as? [String : Any] else { return }
                guard let albummatches = results["albummatches"] as? [String : Any] else { return }
                guard let albums = albummatches["album"] as? [NSDictionary] else { return }
                
                var albumsArray = [Album]()
                
                for obj in albums {
                    let album = Mapper<Album>().map(JSONObject: obj)
                    albumsArray.append(album!)
                }
                
                onSuccess(albumsArray)
            case .failure(let error):
                onFailure(error)
            }
        }
    }
    
    func getArtistTracksFromAPI(artistName: String, albumName: String, onSuccess:@escaping (_ tracks:[Track]) -> (), onFailure: @escaping (_ error: Error) -> ()) {
        
        let incomingString = "https://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=a39589d3029edd07e857ccf43e895569&artist=\(artistName)&album=\(albumName)&format=json"
        
        let urlString = incomingString.replacingOccurrences(of: " ", with: "%20")
        
        let encodedString = String(utf8String: urlString.cString(using: String.Encoding.utf8)!)!
        
        Alamofire.request(encodedString).responseJSON { response in
            switch response.result {
            case .success(let value):
                guard let JSON = value as? [String : Any] else { return }
                guard let album = JSON["album"] as? [String : Any] else { return }
                guard let tracks = album["tracks"] as? [String : Any] else { return }
                guard let track = tracks["track"] as? [NSDictionary] else { return }
                
                var tracksArray = [Track]()
                
                for obj in track {
                    let track = Mapper<Track>().map(JSONObject: obj)
                    tracksArray.append(track!)
                }
            
                onSuccess(tracksArray)
            case .failure(let error):
                onFailure(error)
            }
        }
    }
}
