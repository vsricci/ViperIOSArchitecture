//
//  PhotoItemCell.swift
//  viperIOSExample
//
//  Created by Vinicius Ricci on 11/03/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

class PhotoItemCell: UICollectionViewCell, ReuseIdentifierProtocol {
    
    
    
    @IBOutlet weak var photoImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
    }
}
