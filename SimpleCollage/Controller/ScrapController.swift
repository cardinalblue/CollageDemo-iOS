//
//  ScrapController.swift
//  SimpleCollage
//
//  Created by yyjim on 18/08/2017.
//  Copyright © 2017 yyjim. All rights reserved.
//

import UIKit
import Foundation

// =============================================================================

extension UIView
{
    func updateAnchorPoint(forTouchPoints points: (CGPoint, CGPoint)) {
        let (p1, p2) = points
        let centerPoint = CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
        let newAnchorPoint = CGPoint(x: centerPoint.x / bounds.width,
                                     y: centerPoint.y / bounds.height)
        updateAnchorPoint(newAnchorPoint)
    }

    func updateAnchorPoint(_ newAnchorPoint: CGPoint) {
        let oldAnchorPoint = layer.anchorPoint
        let offsetX = bounds.width * (newAnchorPoint.x - oldAnchorPoint.x)
        let offsetY = bounds.height * (newAnchorPoint.y - oldAnchorPoint.y)
        transform = transform.concatenating(CGAffineTransform(translationX: offsetX, y: offsetY))
        layer.anchorPoint = newAnchorPoint
    }
}

// =============================================================================

class ScrapController: NSObject
{
    let scrap: Scrap
    lazy var view: UIView = {
        return self.createView()
    }()

    internal func createView() -> UIView {
        let v = UIView()
        return v
    }
    
    init(scrap: Scrap) {
        self.scrap = scrap
        super.init()
        setupGestures()
    }

    //MARK: Subviews
    private func setupGestures() {
        // Drag
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)

        // Zoom in/out
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGesture.delegate = self
        view.addGestureRecognizer(pinchGesture)

        // Rotate
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture(_:)))
        rotateGesture.delegate = self
        view.addGestureRecognizer(rotateGesture)
    }

    //MARK: Gesture handlers

    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: recognizer.view?.superview)
        view.center = view.center.applying(CGAffineTransform(translationX: translation.x, y: translation.y))
        recognizer.setTranslation(.zero, in: recognizer.view?.superview)
    }

    @objc private func handlePinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began {
            let p1 = recognizer.location(ofTouch: 0, in: recognizer.view)
            let p2 = recognizer.location(ofTouch: 1, in: recognizer.view)
            view.updateAnchorPoint(forTouchPoints: (p1, p2))
        }
        let scale = recognizer.scale
        view.transform = view.transform.scaledBy(x: scale, y: scale)
        recognizer.scale = 1
    }

    @objc private func handleRotateGesture(_ recognizer: UIRotationGestureRecognizer) {
        if recognizer.state == .began {
            let p1 = recognizer.location(ofTouch: 0, in: recognizer.view)
            let p2 = recognizer.location(ofTouch: 1, in: recognizer.view)
            view.updateAnchorPoint(forTouchPoints: (p1, p2))
        }
        let rotation = recognizer.rotation
        view.transform = view.transform.rotated(by: rotation)
        recognizer.rotation = 0
    }
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
