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
        
        scrap.addObserver(self, forKeyPath: #keyPath(Scrap.size),      options: [.new], context: nil)
        scrap.addObserver(self, forKeyPath: #keyPath(Scrap.center),    options: [.new], context: nil)
        scrap.addObserver(self, forKeyPath: #keyPath(Scrap.transform), options: [.new], context: nil)
        
        setupGestures()
    }
    
    deinit {
        scrap.removeObserver(self, forKeyPath: #keyPath(Scrap.size))
        scrap.removeObserver(self, forKeyPath: #keyPath(Scrap.center))
        scrap.removeObserver(self, forKeyPath: #keyPath(Scrap.transform))
    }
    
    //MARK: KVO
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(Scrap.size) {
            var rect = self.view.frame
            rect.size = scrap.size
            self.view.frame = rect
        } else if keyPath == #keyPath(Scrap.center) {
            self.view.center = scrap.center
        } else if keyPath == #keyPath(Scrap.transform) {
           self.view.transform = scrap.transform
        }
    }
    
    //MARK: Subviews
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
        rotationGesture.delegate = self
        view.addGestureRecognizer(rotationGesture)
        
        let scaleGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        scaleGesture.delegate = self
        view.addGestureRecognizer(scaleGesture)
    }
    
    internal func createView() -> UIView {
        let v = UIView()
        return v
    }
    
    //MARK: Gesture handlers
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view.superview)
        var center = self.scrap.center
        center = center.applying(CGAffineTransform(translationX: translation.x, y: translation.y))
        scrap.center = center

        // Reset translation
        recognizer.setTranslation(.zero, in: view)
    }

    @objc private func handleRotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        let rotation = recognizer.rotation
        var transform = self.scrap.transform
        transform = transform.rotated(by: rotation)
        scrap.transform = transform

        // Reset rotation
        recognizer.rotation = 0
    }

    @objc private func handlePinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        let scale = recognizer.scale
        print(scale)
        var transform = self.scrap.transform
        transform = transform.scaledBy(x: scale, y: scale)
        scrap.transform = transform

        // Reset scale
        recognizer.scale = 1
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
