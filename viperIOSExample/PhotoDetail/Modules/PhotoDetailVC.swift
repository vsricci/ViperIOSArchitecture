//
//  PhotoDetailVC.swift
//  viperIOSExample
//
//  Created by Vinicius Ricci on 10/03/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

protocol PhotoDetailVCInput: class {
    func addLargeLoadedPhoto(_ photo: UIImage)
    func addPhotoImageTitle(_ title: String)
}

protocol PhotoDetailVCOutput: class {
    func saveSelectedPhotoModel(_ photoModel: FlickrPhotoModel)
    func loadLargePhotoImage()
    func getPhotoImageTitle()
}

class PhotoDetailVC: UIViewController, PhotoDetailVCInput {
    
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!

    var presenter : PhotoDetailVCOutput!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        PhotoDetailAssembly.sharedInstance.configure(self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.presenter.getPhotoImageTitle()
        self.presenter.loadLargePhotoImage()
    }
    
    //result comes presenter
    
    func addLargeLoadedPhoto(_ photo: UIImage) {
        self.photoImageView.image = photo
    }
    
    func addPhotoImageTitle(_ title: String) {
        self.photoTitleLabel.text = title
    }

   

}



