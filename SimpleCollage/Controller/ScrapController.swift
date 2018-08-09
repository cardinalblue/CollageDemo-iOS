//
//  ScrapController.swift
//  SimpleCollage
//
//  Created by yyjim on 18/08/2017.
//  Copyright © 2017 yyjim. All rights reserved.
//

import UIKit
import Foundation

extension UIView
{
    func updateAnchorPoint(forTouchPoints points: (CGPoint, CGPoint)) {
        let (p1, p2) = points
        let centerPoint = CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
        let newAnchorPoint = CGPoint(x: centerPoint.x / bounds.width,
                                     y: centerPoint.y / bounds.height)
        let oldAnchorPoint = layer.anchorPoint
        layer.anchorPoint = newAnchorPoint
        let offsetX = bounds.width * (newAnchorPoint.x - oldAnchorPoint.x)
        let offsetY = bounds.height * (newAnchorPoint.y - oldAnchorPoint.y)
        transform = transform.concatenating(CGAffineTransform(translationX: offsetX, y: offsetY))
    }
}

class ScrapController: NSObject
{
    let scrap: Scrap
    lazy var view: UIView = {
        return self.createView()
    }()
    
    init(scrap: Scrap) {
        self.scrap = scrap
        super.init()
        setupGestures()
    }

    //MARK: Subviews
    private func setupGestures() {
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
