//
//  FickrDataManager.swift
//  viperIOSExample
//
//  Created by Vinicius Ricci on 10/03/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation
import SDWebImage

protocol FlickrPhotoSearchProtocol: class {
    
    func fetchPhotosForSearchText(searchText: String, page: NSInteger,m clousure: @escaping (NSError?, NSInteger, [FlickrPhotoModel]?) -> Void) -> Void 
}

protocol FlickrPhotoLoadImageProtocol: class {
    
    func loadImageFromUrl(_ url: NSURL, clousure: @escaping (UIImage?, NSError?) -> Void)
}

class FlickrDataManager : FlickrPhotoSearchProtocol, FlickrPhotoLoadImageProtocol {
    static let sharedInstance = FlickrDataManager()
    
    struct  Errors {
        
        static let invalidAccessErrorCode = 100
    }
    
    struct FlickrAPIMetadataKeys {
        static let failureStatusCode = "code"
    }
    
    struct FlicrAPI  {
        
        static let APIkey = "a7776f4bda469ee8a4b87c657d7ff350"
        static let tagSearchFormat = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&page=%i&format=json&nojsoncallback=1"
      //  https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=280b854b7038db502ece2cfaa255d7e0&tags=Party&format=json&nojsoncallback=1
    }
    
    func fetchPhotosForSearchText(searchText: String, page: NSInteger,m clousure: @escaping (NSError?, NSInteger, [FlickrPhotoModel]?) -> Void) -> Void {
        
        let escapedSearchText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        let format = FlicrAPI.tagSearchFormat
        let arguments: [CVarArg] = [FlicrAPI.APIkey, escapedSearchText!, page]
        
        let photosURL = String(format: format, arguments: arguments)
        
        let url = NSURL(string: photosURL)!
        let request = URLRequest(url: url as URL)
        let searchTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                print("Error fetching photos : \(error)")
                clousure(error as NSError?, 0, nil)
                
            }
            
            do {
                
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                
                guard let results = resultsDictionary else {return}
                
                if let statusCode = results[FlickrAPIMetadataKeys.failureStatusCode] as? Int {
                    
                    if statusCode == Errors.invalidAccessErrorCode {
                        
                        let invalidAccessError = NSError(domain: "FlickrAPIDomain", code: statusCode, userInfo: nil)
                        clousure(invalidAccessError, 0, nil)
                        return
                    }
                    
                }
                
                guard let photosContainer = resultsDictionary!["photos"] as? NSDictionary else {return}
                guard let totalPageCountString = photosContainer["total"] as? String else {return}
                guard let totalPageCount = NSInteger(totalPageCountString as String) else {return}
                
                guard let photosArray = photosContainer["photo"] as? [NSDictionary] else {return}
                
                let flickrPhotos : [FlickrPhotoModel] = photosArray.map({ (photoDictionary) -> FlickrPhotoModel in
                    
                    let photoId = photoDictionary["id"] as? String ?? ""
                    let farm = photoDictionary["farm"] as? Int ?? 0
                    let secret = photoDictionary["secret"] as? String ?? ""
                    let server = photoDictionary["server"] as? String ?? ""
                    let title = photoDictionary["title"] as? String ?? ""
                    
                    
                    let flickrPhoto = FlickrPhotoModel(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
                    
                    return flickrPhoto
                    
                })
                
                clousure(nil, totalPageCount, flickrPhotos)
                
            } catch let error as NSError {
                print("Error parsing JSON : \(error)")
                clousure(error, 0, nil)
                return
            }
        }
        searchTask.resume()
        
    }
    
    // Memory cache Photo services
    
    func loadImageFromUrl(_ url: NSURL, clousure: @escaping (UIImage?, NSError?) -> Void) {
        
        
        SDWebImageManager.shared().imageDownloader?.downloadImage(with: url as URL, options: .continueInBackground, progress: nil, completed: { (image, data, error, finished) in

            if ((image != nil) && finished) {
                clousure(image, error as? NSError)

            }

        })
//        SDWebImageManager.shared().loadImage(with: url as URL, options: .cacheMemoryOnly, progress: nil, completed: { (image, data, error, cache, finished, withUrl) in
//
//            if ((image != nil) && finished) {
//                clousure(image, error as? NSError)
//
//            }
//
//        })
    }
}
