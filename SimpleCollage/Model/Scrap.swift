//
//  Scrap.swift
//  SimpleCollage
//
//  Created by yyjim on 18/08/2017.
//  Copyright © 2017 yyjim. All rights reserved.
//

import UIKit
import Foundation

protocol Scrap {
    var size: CGSize                 { get set }
    var center: CGPoint              { get set }
    var transfrom: CGAffineTransform { get set }
}

struct ImageScrap: Scrap {
    var size: CGSize                 = .zero
    var center: CGPoint              = .zero
    var transfrom: CGAffineTransform = .identity
    var image: UIImage
    
    init(size: CGSize = .zero,
         center: CGPoint = .zero,
         transfrom: CGAffineTransform = .identity,
         image: UIImage)
    {
        self.size = size
        self.center = center
        self.transfrom = transfrom
        self.image = image
    }
    
}
