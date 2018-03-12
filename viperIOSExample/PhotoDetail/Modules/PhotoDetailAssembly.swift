//
//  File.swift
//  viperIOSExample
//
//  Created by Vinicius Ricci on 10/03/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

class PhotoDetailAssembly {
    static let sharedInstance = PhotoDetailAssembly()
    
    func configure(_ viewController : PhotoDetailVC) {
        
        let APIDataManager: FlickrPhotoLoadImageProtocol = FlickrDataManager()
        let interactor = PhotoDetailInteractor()
        let presenter = PhotoDetailPresenter()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        presenter.interactor =  interactor
        interactor.imageDataManager = APIDataManager
    }
    
}
