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
    private let scrapVM: ScrapViewModelProtocol
    
    lazy var view: UIImageView = {
        let v = UIImageView()
        v.isUserInteractionEnabled = true
        return v
    }()
    
    init(scrapVM: ScrapViewModelProtocol) {
        self.scrapVM = scrapVM
        super.init()
        self.scrapVM.transfrom.bindAndFire { [unowned self] (transfrom) in
            self.view.transform = transfrom
        }
        self.scrapVM.size.bindAndFire { [unowned self] (size) in
            var rect = self.view.frame
            rect.size = size
            self.view.frame = rect
        }
        self.scrapVM.center.bindAndFire { [unowned self] (point) in
            self.view.center = point
        }
        self.scrapVM.image.bindAndFire { [unowned self] (size) in
            self.view.image = scrapVM.image.value
        }
        
        setupGestures()
    }
    
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
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view.superview)
        var center = self.scrapVM.center.value
        center = center.applying(CGAffineTransform(translationX: translation.x, y: translation.y))
        scrapVM.center.value = center
        
        // Reset translation
        recognizer.setTranslation(.zero, in: view)
    }
    
    @objc private func handleRotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        let rotation = recognizer.rotation
        var transform = self.scrapVM.transfrom.value
        transform = transform.rotated(by: rotation)
        scrapVM.transfrom.value = transform
        
        // Reset rotation
        recognizer.rotation = 0
    }
    
    @objc private func handlePinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        let scale = recognizer.scale
        print(scale)
        var transform = self.scrapVM.transfrom.value
        transform = transform.scaledBy(x: scale, y: scale)
        scrapVM.transfrom.value = transform
        
        // Reset scale
        recognizer.scale = 1
    }
}

extension ScrapController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
