//
//  ScrapViewModel.swift
//  SimpleCollage
//
//  Created by yyjim on 18/08/2017.
//  Copyright © 2017 yyjim. All rights reserved.
//

import UIKit

protocol ScrapViewModelProtocol {
    var size: Dynamic<CGSize> { get set }
    var center: Dynamic<CGPoint> { get set }
    var transfrom: Dynamic<CGAffineTransform> { get set }
    var image: Dynamic<UIImage?> { get set }
}

class ScrapViewModel : ScrapViewModelProtocol {
    
    var scrap: Scrap
    var size: Dynamic<CGSize>
    var center: Dynamic<CGPoint>
    var transfrom: Dynamic<CGAffineTransform>
    var image: Dynamic<UIImage?>

    init(scrap: Scrap) {
        self.scrap = scrap
        
        size = Dynamic(scrap.size)
        center = Dynamic(scrap.center)
        transfrom = Dynamic(scrap.transfrom)
        image = Dynamic(scrap.image)
    }
}
