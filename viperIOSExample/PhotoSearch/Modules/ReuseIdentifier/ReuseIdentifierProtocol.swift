//
//  ReuseIdentifierProtocol.swift
//  viperIOSExample
//
//  Created by Vinicius Ricci on 11/03/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

public protocol ReuseIdentifierProtocol: class {
    
    //get identifier
    
    static var defaultReuseIdentifier: String { get }
}

public extension ReuseIdentifierProtocol where Self: UIView {
    
    static var defaultReuseIdentifier: String {
        
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
