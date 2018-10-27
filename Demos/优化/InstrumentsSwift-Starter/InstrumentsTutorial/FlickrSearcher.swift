//
//  FlickrSearcher.swift
//  flickrSearch
//
//  Created by Richard Turton on 31/07/2014.
//  Copyright (c) 2014 Razeware. All rights reserved.
//

import Foundation
import UIKit

let apiKey = "1faa01db93db5707a93fa40e6bd604cd"

struct FlickrSearchResults {
  let searchTerm : String
  let searchResults : [FlickrPhoto]
}

class FlickrPhoto : Equatable {
  let photoID : String
  let title: String
  fileprivate let farm : Int
  fileprivate let server : String
  fileprivate let secret : String
  
  typealias ImageLoadCompletion = (_ image: UIImage?, _ error: NSError?) -> Void
  
  init (photoID:String, title:String, farm:Int, server:String, secret:String) {
    self.photoID = photoID
    self.title = title
    self.farm = farm
    self.server = server
    self.secret = secret
  }
  
  func flickrImageURL(_ size: String = "m") -> URL {
    return URL(string: "http://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg")!
  }
  
    func loadThumbnail(_ completion: @escaping ImageLoadCompletion) {
        if let image = ImageCache.sharedCache.imageForKey(photoID) {
            completion(image, nil)
        } else {
            loadImageFromURL(flickrImageURL("m")) { image, error in
                if let image = image {
                    ImageCache.sharedCache.setImage(image, forKey: self.photoID)
                }
                completion(image, error)
            }
        }
    }

  func loadLargeImage(_ completion: @escaping ImageLoadCompletion) {
    loadImageFromURL(flickrImageURL("b"), completion: completion)
  }
  
  func loadImageFromURL(_ URL: Foundation.URL, completion: @escaping ImageLoadCompletion) {
    let loadRequest = URLRequest(url: URL)
    NSURLConnection.sendAsynchronousRequest(loadRequest,
      queue: OperationQueue.main) {
        response, data, error in
        
        if error != nil {
          completion(nil, error as NSError?)
          return
        }
        
        if let data = data {
          completion(UIImage(data: data), nil)
          return
        }
        
        completion(nil, nil)
    }
  }
}


extension FlickrPhoto {
  var isFavourite: Bool {
    get {
      return UserDefaults.standard.bool(forKey: photoID)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: photoID)
    }
  }
}

func == (lhs: FlickrPhoto, rhs: FlickrPhoto) -> Bool {
  return lhs.photoID == rhs.photoID
}

class Flickr {
  
  let processingQueue = OperationQueue()
  
  func searchFlickrForTerm(_ searchTerm: String, completion : @escaping (_ results: FlickrSearchResults?, _ error : NSError?) -> Void){
    
    let searchURL = flickrSearchURLForSearchTerm(searchTerm)
    let searchRequest = URLRequest(url: searchURL)
    
    NSURLConnection.sendAsynchronousRequest(searchRequest, queue: processingQueue) {response, data, error in
      if error != nil {
        completion(nil,error as NSError?)
        return
      }
      
        var resultsDictionary: [String: AnyObject] = [:]
        do {
            try resultsDictionary = JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as! [String : AnyObject]
        } catch let error as NSError {
            completion(nil, error)
            return
        }
      
      switch (resultsDictionary["stat"] as! String) {
      case "ok":
        print("Results processed OK")
      case "fail":
        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:resultsDictionary["message"]!])
        completion(nil, APIError)
        return
      default:
        let APIError = NSError(domain: "FlickrSearch", code: 0, userInfo: [NSLocalizedFailureReasonErrorKey:"Unknown API response"])
        completion(nil, APIError)
        return
      }

      let photosContainer = resultsDictionary["photos"] as! NSDictionary
      let photosReceived = photosContainer["photo"] as! [NSDictionary]

      let flickrPhotos : [FlickrPhoto] = photosReceived.map {
        photoDictionary in
        
        let photoID = photoDictionary["id"] as? String ?? ""
        let title = photoDictionary["title"] as? String ?? ""
        let farm = photoDictionary["farm"] as? Int ?? 0
        let server = photoDictionary["server"] as? String ?? ""
        let secret = photoDictionary["secret"] as? String ?? ""
        
        let flickrPhoto = FlickrPhoto(photoID: photoID, title: title, farm: farm, server: server, secret: secret)

        return flickrPhoto
      }

      DispatchQueue.main.async(execute: {
        completion(FlickrSearchResults(searchTerm: searchTerm, searchResults: flickrPhotos), nil)
      })
    }
  }
  
  fileprivate func flickrSearchURLForSearchTerm(_ searchTerm: String) -> URL {
    let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=30&format=json&nojsoncallback=1"
    return URL(string: URLString)!
  }
  
  
}
