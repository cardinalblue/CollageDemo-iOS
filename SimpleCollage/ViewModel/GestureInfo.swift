//
//  GestureInfo.swift
//  SimpleCollage
//
//  Created by yyjim on 23/08/2017.
//  Copyright © 2017 yyjim. All rights reserved.
//

import UIKit

enum State : Int {
    case began
    case changed
    case ended
    case cancelled
    case unknown
}

protocol GestureInfo {
    var state: State { get set }
}

extension UIGestureRecognizerState {
    var gestureInfoState: State {
        switch self {
        case .began:
            return .began
        case .changed:
            return .changed
        case .ended:
            return .ended
        case .cancelled:
            return .cancelled
        default:
            return .unknown
        }
    }
}

struct TransformGestureInfo: GestureInfo {
    var state: State
    var transform: CGAffineTransform
}

struct TranslationGestureInfo: GestureInfo {
    var state: State
    var translation: CGPoint
}
