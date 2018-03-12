//
//  PhotoDetailPresenter.swift
//  viperIOSExample
//
//  Created by Vinicius Ricci on 10/03/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

protocol PhotoDetailPresenterInput : PhotoDetailInteractorOutput, PhotoDetailVCOutput {
    
    
}

class PhotoDetailPresenter: PhotoDetailPresenterInput {
    
    weak var view: PhotoDetailVCInput!
    var interactor: PhotoDetailInteractorInput!
    
    // Pass data from PhotoSearch Module Router
    
    func saveSelectedPhotoModel(_ photoModel: FlickrPhotoModel){
        
        self.interactor.configurePhotoModel(photoModel: photoModel)
    }
    
    func loadLargePhotoImage(){
        
        self.interactor.loadUIImageUrl()
    }
    
    // result comes from Interactor
    
    func sendLoadedPhotoImage(_ image: UIImage) {
        
        self.view.addLargeLoadedPhoto(image)
    }
    
    func getPhotoImageTitle(){
        
        let imageTitle = self.interactor.getPhotoImageTitle()
        self.view.addPhotoImageTitle(imageTitle)
    }
}
