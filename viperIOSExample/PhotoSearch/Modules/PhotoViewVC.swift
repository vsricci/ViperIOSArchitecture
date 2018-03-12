//
//  PhotoViewVC.swift
//  viperIOSExample
//
//  Created by Vinicius Ricci on 10/03/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

protocol PhotoViewControllerOutput {
    
    func fetchPhotos(_ searchTag: String, page: NSInteger)
    func goToPhotoDetailScreen()
    func passDataToNextScene(_ segue: UIStoryboardSegue)
    
}

protocol PhotoViewControllerInput {
    
    func displayFetchedPhotos(_ photos : [FlickrPhotoModel], totalPages: NSInteger)
    func displayErrorView(_ errorMessage: String)
    func showWaitingView()
    func hideWatingView()
    func getTotalPhotoCount() -> NSInteger
}

class PhotoViewVC: UIViewController, PhotoViewControllerInput {
    
    @IBOutlet weak var photoCollectionView : UICollectionView!

    var presenter: PhotoViewControllerOutput!
    var photos: [FlickrPhotoModel] = []
    var currentPage = 1
    var totalPages = 1
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        PhotoSearchAssembly.shredInstance.configure(self)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = photoSearchKey
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        FlickrDataManager.sharedInstance.fetchPhotosForSearchText(searchText: photoSearchKey, page: 1) { (error, page, photos) in
//
//
//            print(error)
//            print(page)
//            print(photos)
//        }
        
        performSearchWith(photoSearchKey)
        
    }
    
    
    //Request photo service result from Presenter
    func performSearchWith(_ searcText: String){
        
        presenter.fetchPhotos(searcText, page: currentPage)
    }
    
    //Presenter return us with photo results
    func displayFetchedPhotos(_ photos : [FlickrPhotoModel], totalPages: NSInteger){
        
        self.photos.append(contentsOf: photos)
        self.totalPages = totalPages
        
        DispatchQueue.main.async {
            
            self.photoCollectionView.reloadData()
        }
        
    }
    
    //Show Error
    
    func displayErrorView(_ errorMessage: String) {
        
        let refreshAlert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        refreshAlert.addAction(UIAlertAction(title: okKey, style: .default, handler: { (action) in
            
            refreshAlert.dismiss(animated: true, completion: nil)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    // ActivityView
    
    func showWaitingView(){
        
        let alert = UIAlertController(title: nil, message: waitingKey, preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = .gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        self.navigationController?.present(alert, animated: true, completion: nil)
    }
    
    func hideWatingView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func getTotalPhotoCount() -> NSInteger {
        
        return self.photos.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        presenter.passDataToNextScene(segue)
    }
}

extension PhotoViewVC : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentPage < totalPages {
            
            return photos.count + 1
        }
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < photos.count {
            
            return photoItemCell(collectionView, cellForItemAt: indexPath as NSIndexPath )
            
        }else {
            
            currentPage += 1
            performSearchWith(photoSearchKey)
             return photoLoadingCell(collectionView, cellForItemAt: indexPath as NSIndexPath)
        }
        
    }
    
    func photoItemCell(_ collectionView: UICollectionView, cellForItemAt indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoItemCell.defaultReuseIdentifier, for: indexPath as IndexPath) as! PhotoItemCell
        
        let flickrPhoto = self.photos[indexPath.row]
        
        cell.photoImageView.alpha = 0
        cell.photoImageView.sd_setImage(with: flickrPhoto.photoUrl as URL) { (image, error, cache, url) in
            
            cell.photoImageView.image = image
            
            UIView.animate(withDuration: 0.2, animations: {
                
                cell.photoImageView.alpha = 1.0
            })
        }
        
        return cell
    }
    
    func photoLoadingCell(_ collectionView: UICollectionView, cellForItemAt indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoLoadingCell.defaultReuseIdentifier, for: indexPath as IndexPath) as! PhotoLoadingCell
        
        return cell
    }
}


extension PhotoViewVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.presenter.goToPhotoDetailScreen()
    }
}

extension PhotoViewVC: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var itemSize : CGSize
        let lenght = (UIScreen.main.bounds.width) / 3 - 1
        
        if indexPath.row < photos.count {
            
            itemSize = CGSize(width: lenght, height: lenght)
        }
        else {
            
            itemSize = CGSize(width: photoCollectionView.bounds.width, height: 50.0)
        }
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0.5
    }
}


