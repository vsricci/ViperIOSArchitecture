//
//  PhotoSearchPresenter.swift
//  viperIOSExample
//
//  Created by Vinicius Ricci on 10/03/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation
import  UIKit
protocol PhotoSearchPresenterInput : PhotoViewControllerOutput, PhotoSearchInteractorOutput {

}

class PhotoSearchPresenter : PhotoSearchPresenterInput{
    
    var view: PhotoViewControllerInput!
    var interactor: PhotoSearchInteractorInput!
    var router : PhotoSearchRouterInput!
    
    func fetchPhotos(_ searchTag: String, page: NSInteger) {
        
        if view.getTotalPhotoCount() == 0 {
            
            view.showWaitingView()
        }
        interactor.fetchAllPhotosFromDataManager(searchTag, page: page)
        
    }
    
    // Servicce return photod and interactor passes all data to presenter witch make view display them
    
    func providedPhotos(_ photos : [FlickrPhotoModel], totalPages: NSInteger){
        self.view.hideWatingView()
        self.view.displayFetchedPhotos(photos, totalPages: totalPages)
        
    }
    
    //Show error message from service
    
    func serviceError(_ error: NSError){
        self.view.displayErrorView(defaultErrorMessage)
    }
    
    func goToPhotoDetailScreen() {
        
        self.router.navigationToPhotoDetail()
    }
    
    func passDataToNextScene(_ segue: UIStoryboardSegue) {
        
        self.router.passDataToNextScene(segue)
    }
}
