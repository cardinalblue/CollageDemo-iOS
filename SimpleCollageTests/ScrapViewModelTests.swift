//
//  ScrapViewModelTests.swift
//  SimpleCollageTests
//
//  Created by yyjim on 23/08/2017.
//  Copyright © 2017 yyjim. All rights reserved.
//

import XCTest
@testable import SimpleCollage

class TestScrap: Scrap {
    var size: CGSize
    var center: CGPoint
    var transform: CGAffineTransform
    
    init(size: CGSize = .zero, center: CGPoint = .zero, transform: CGAffineTransform = .identity) {
        self.size = size
        self.center = center
        self.transform = transform
    }
}

class ScrapViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTranslationGesture() {
        typealias Change = (state: State, x: CGFloat, y: CGFloat)
        
        let scrap = TestScrap(size: CGSize(width: 100, height: 100), center: CGPoint(x: 0, y: 0))
        let scrapViewModel = ScrapViewModel(scrap: scrap)
        var gestureInfo = TranslationGestureInfo(state: .changed, translation: .zero)
        let changes: [Change] = [(.began, 0, 0),
                                 (.changed, 10, 0),
                                 (.changed, 0, 10),
                                 (.changed, 10, 10),
                                 (.ended, 0, 0)]
        var expectedCenter = scrapViewModel.center
        for (state, tx, ty) in changes {
            expectedCenter = expectedCenter.applying(CGAffineTransform(translationX: tx, y: ty))
            
            gestureInfo.state = state
            gestureInfo.translation = CGPoint(x: tx, y: ty)
            scrapViewModel.handleGestureInfo(ofTranslation: gestureInfo)
            
            // Test ViewModel's center
            XCTAssertEqual(scrapViewModel.center, expectedCenter)
            
            // Test Model's center
            // The model should only be updated when gesture is ended
            if state == .ended {
                XCTAssertEqual(scrap.center, expectedCenter)
            } else {
                XCTAssertEqual(scrap.center, CGPoint(x: 0, y: 0))
            }
        }
    }
}
