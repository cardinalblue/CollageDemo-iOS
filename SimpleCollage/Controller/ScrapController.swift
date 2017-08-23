//
//  ScrapController.swift
//  SimpleCollage
//
//  Created by yyjim on 18/08/2017.
//  Copyright © 2017 yyjim. All rights reserved.
//

import UIKit
import Foundation

class ScrapController: NSObject
{
    let scrap: Scrap
    lazy var view: UIView = {
        return self.createView()
    }()
    
    init(scrap: Scrap) {
        self.scrap = scrap
        super.init()
        
        // TODO: Binding View - Model by KVO
        setupGestures()
    }
    
    deinit {
    }
    
    //MARK: KVO
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
    }
    
    //MARK: Subviews
    private func setupGestures() {
        // TODO: Add Pan, Rotation, Scale gestures
    }
    
    internal func createView() -> UIView {
        let v = UIView()
        return v
    }
    
    //MARK: Gesture handlers
}

// =============================================================================

extension ScrapController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// =============================================================================

class ImageScrapController: ScrapController {
    var image: UIImage
    
    init(scrap: Scrap, image: UIImage) {
        self.image = image
        super.init(scrap: scrap)
    }
    
    internal override func createView() -> UIView {
        let v = UIImageView()
        v.image = self.image
        v.isUserInteractionEnabled = true
        let size = self.scrap.size
        v.frame = CGRect(x: self.scrap.center.x - size.width / 2,
                         y: self.scrap.center.y - size.height / 2,
                         width: size.width,
                         height: size.height)
        v.transform = self.scrap.transform
        return v
    }

}
