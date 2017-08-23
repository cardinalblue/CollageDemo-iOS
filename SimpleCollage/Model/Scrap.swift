//
//  Scrap.swift
//  SimpleCollage
//
//  Created by yyjim on 18/08/2017.
//  Copyright © 2017 yyjim. All rights reserved.
//

import UIKit
import Foundation

class Scrap: NSObject {
    @objc dynamic var size: CGSize = .zero
    @objc dynamic var center: CGPoint = .zero
    @objc dynamic var transform: CGAffineTransform = .identity
    
    init(size: CGSize = .zero,
         center: CGPoint = .zero,
         transform: CGAffineTransform = .identity)
    {
        self.size = size
        self.center = center
        self.transform = transform
    }
}

class ImageScrap: Scrap {
    var image: UIImage
    
    init(size: CGSize = .zero,
         center: CGPoint = .zero,
         transform: CGAffineTransform = .identity,
         image: UIImage)
    {
        self.image = image
        super.init(size: size, center: center, transform: transform)
    }
    
}
