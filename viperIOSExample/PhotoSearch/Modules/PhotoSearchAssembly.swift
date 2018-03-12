//
//  PhotoSearchAssembly.swift
//  viperIOSExample
//
//  Created by Vinicius Ricci on 10/03/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation
class PhotoSearchAssembly {
    
    static let shredInstance = PhotoSearchAssembly()
    
    func configure(_ viewController: PhotoViewVC) {
        
        let APIDataManager = FlickrDataManager()
        let interactor = PhotoSearchInteractor()
        let presenter = PhotoSearchPresenter()
        let router = PhotoSearchRouting()
        router.viewController = viewController
        presenter.router = router
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        presenter.interactor = interactor
        interactor.APIDataManager = APIDataManager
    }
}
