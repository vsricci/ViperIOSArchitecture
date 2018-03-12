//
//  PhotoSearchInteractor.swift
//  viperIOSExample
//
//  Created by Vinicius Ricci on 10/03/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation

protocol PhotoSearchInteractorInput: class {
    
    func fetchAllPhotosFromDataManager(_ searchTag: String, page: NSInteger)
}


protocol PhotoSearchInteractorOutput: class {
    
    func providedPhotos(_ photos : [FlickrPhotoModel], totalPages: NSInteger)
    func serviceError(_ error: NSError)
}
class PhotoSearchInteractor: PhotoSearchInteractorInput {
    
    weak var presenter : PhotoSearchInteractorOutput!
    var APIDataManager : FlickrPhotoSearchProtocol!
    
    func fetchAllPhotosFromDataManager(_ searchTag: String, page: NSInteger) {
        
        APIDataManager.fetchPhotosForSearchText(searchText: searchTag, page: page) { (error, totalPages, flickrPhotos) in
            
            if let photos = flickrPhotos {
                
                print("TESTANDO\(photos)")
                self.presenter.providedPhotos(photos, totalPages: totalPages)
                
            } else if let error = error {
                print(error)
                self.presenter.serviceError(error)
            }
        }
    }
}
