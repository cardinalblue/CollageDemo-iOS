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
    let scrapVM: ScrapViewModel
    var view: UIView = UIView()
    
    init(scrapVM: ScrapViewModel) {
        self.scrapVM = scrapVM
        super.init()
        
        scrapVM.addObserver(self, forKeyPath: #keyPath(ScrapViewModel.size),      options: [.new], context: nil)
        scrapVM.addObserver(self, forKeyPath: #keyPath(ScrapViewModel.center),    options: [.new], context: nil)
        scrapVM.addObserver(self, forKeyPath: #keyPath(ScrapViewModel.transfrom), options: [.new], context: nil)
        
        setupGestures()
    }
    
    deinit {
        scrapVM.removeObserver(self, forKeyPath: #keyPath(ScrapViewModel.size))
        scrapVM.removeObserver(self, forKeyPath: #keyPath(ScrapViewModel.center))
        scrapVM.removeObserver(self, forKeyPath: #keyPath(ScrapViewModel.transfrom))
    }
    
    //MARK: KVO
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(ScrapViewModel.size) {
            var rect = self.view.frame
            rect.size = scrapVM.size
            self.view.frame = rect
        } else if keyPath == #keyPath(ScrapViewModel.center) {
            self.view.center = scrapVM.center
        } else if keyPath == #keyPath(ScrapViewModel.transfrom) {
           self.view.transform = scrapVM.transfrom
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
    
    //MARK: Gesture handlers
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view.superview)
        var center = self.scrapVM.center
        center = center.applying(CGAffineTransform(translationX: translation.x, y: translation.y))
        scrapVM.center = center

        // Reset translation
        recognizer.setTranslation(.zero, in: view)
    }

    @objc private func handleRotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        let rotation = recognizer.rotation
        var transform = self.scrapVM.transfrom
        transform = transform.rotated(by: rotation)
        scrapVM.transfrom = transform

        // Reset rotation
        recognizer.rotation = 0
    }

    @objc private func handlePinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        let scale = recognizer.scale
        print(scale)
        var transform = self.scrapVM.transfrom
        transform = transform.scaledBy(x: scale, y: scale)
        scrapVM.transfrom = transform

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
    
    lazy override var view: UIView = {
        let v = UIImageView()
        v.image = self.image
        v.isUserInteractionEnabled = true
        v.frame     = self.scrapVM.frame
        v.transform = self.scrapVM.transfrom
        return v
    }()
    
    init(scrapVM: ScrapViewModel, image: UIImage) {
        self.image = image
        super.init(scrapVM: scrapVM)
    }
}
