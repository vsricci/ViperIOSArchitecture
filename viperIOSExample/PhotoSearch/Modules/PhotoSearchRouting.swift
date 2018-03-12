//
//  PhotoSearchRouting.swift
//  viperIOSExample
//
//  Created by Vinicius Ricci on 10/03/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import Foundation
import  UIKit

protocol PhotoSearchRouterInput : class {
    func navigationToPhotoDetail()
    func passDataToNextScene(_ segue: UIStoryboardSegue)
}

class PhotoSearchRouting: PhotoSearchRouterInput {
    
    weak var viewController : PhotoViewVC!
    
    
    //Navigation
    func navigationToPhotoDetail() {
        viewController.performSegue(withIdentifier: "ShowPhotoDetail", sender: nil)
        
    }
    
    func passDataToNextScene(_ segue: UIStoryboardSegue) {
        
        if segue.identifier == "ShowPhotoDetail" {
            passDataToShowPhotoDetailScene(segue)
        }
    }
    
    // navigate to another module
    func passDataToShowPhotoDetailScene(_ segue: UIStoryboardSegue) {
        
        if let selectedIndexPath = viewController.photoCollectionView.indexPathsForSelectedItems?.first {
            let selectedPhotoModel = viewController.photos[selectedIndexPath.row]
            let showDetailVC = segue.destination as! PhotoDetailVC
            
            showDetailVC.presenter.saveSelectedPhotoModel(selectedPhotoModel)
        }
    }
}
