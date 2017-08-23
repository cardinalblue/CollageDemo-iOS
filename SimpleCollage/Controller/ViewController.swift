//
//  ViewController.swift
//  SimpleCollage
//
//  Created by yyjim on 18/08/2017.
//  Copyright © 2017 yyjim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Getters/Setters
    private var scrapViewControllers: [ScrapController] = []
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: Object lifecycle
    init(scraps: [Scrap]) {
        super.init(nibName: nil, bundle: nil)
        self.scrapViewControllers = scraps.map { (scrap) -> ScrapController in
            return self.createScrapController(scrap: scrap)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.red
        for sc in scrapViewControllers {
            self.view.addSubview(sc.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createScrapController(scrap: Scrap) -> ScrapController {
        let scrapViewModel = ScrapViewModel(scrap: scrap)
        if let imageScrap = scrap as? ImageScrap {
            return ImageScrapController(scrapVM: scrapViewModel, image: imageScrap.image)
        }
        return ScrapController(scrapVM: scrapViewModel)
    }
}

