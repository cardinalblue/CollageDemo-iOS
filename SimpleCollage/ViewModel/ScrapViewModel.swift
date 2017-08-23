//
//  ScrapViewModel.swift
//  SimpleCollage
//
//  Created by yyjim on 18/08/2017.
//  Copyright © 2017 yyjim. All rights reserved.
//

import UIKit

class ScrapViewModel: NSObject {
    private var scrap: Scrap
    
    @objc dynamic var size: CGSize
    @objc dynamic var center: CGPoint
    @objc dynamic var transform: CGAffineTransform
    
    var frame: CGRect {
        return CGRect(x: center.x - size.width / 2,
                      y: center.y - size.height / 2,
                      width: size.width, height: size.height)
    }

    init(scrap: Scrap) {
        self.scrap = scrap
        
        size      = scrap.size
        center    = scrap.center
        transform = scrap.transform
    }
    }
}
