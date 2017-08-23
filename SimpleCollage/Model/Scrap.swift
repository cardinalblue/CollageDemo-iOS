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
    @objc dynamic var transfrom: CGAffineTransform = .identity
    
    init(size: CGSize = .zero,
         center: CGPoint = .zero,
         transfrom: CGAffineTransform = .identity)
    {
        self.size = size
        self.center = center
        self.transfrom = transfrom
    }
}

class ImageScrap: Scrap {
    var image: UIImage
    
    init(size: CGSize = .zero,
         center: CGPoint = .zero,
         transfrom: CGAffineTransform = .identity,
         image: UIImage)
    {
        self.image = image
        super.init(size: size, center: center, transfrom: transfrom)
    }
    
}
