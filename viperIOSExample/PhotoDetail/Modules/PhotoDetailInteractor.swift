//
//  PhotoDetailInteractor.swift
//  viperIOSExample
//
//  Created by Vinicius Ricci on 10/03/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

protocol PhotoDetailInteractorOutput: class {
    
    func sendLoadedPhotoImage(_ image: UIImage)
}

protocol PhotoDetailInteractorInput: class {

    func configurePhotoModel(photoModel: FlickrPhotoModel)
    func loadUIImageUrl()
    func getPhotoImageTitle() -> String
    
    
}

class PhotoDetailInteractor: PhotoDetailInteractorInput {
    
    weak var presenter: PhotoDetailInteractorOutput!
    var photoModel : FlickrPhotoModel?
    var imageDataManager : FlickrPhotoLoadImageProtocol!
    
    func configurePhotoModel(photoModel: FlickrPhotoModel){
        
        self.photoModel = photoModel
    }
    
    func loadUIImageUrl(){
        imageDataManager.loadImageFromUrl((self.photoModel?.largePhotoURL)!) { (image, error) in
            
            if let image = image {
                self.presenter.sendLoadedPhotoImage(image)
            }
        }
    }
    
    func getPhotoImageTitle() -> String {
        
        if let title = self.photoModel?.title {
            return title
        }
        
        return ""
    }
}
