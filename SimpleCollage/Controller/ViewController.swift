//
//  ViewController.swift
//  SimpleCollage
//
//  Created by yyjim on 18/08/2017.
//  Copyright © 2017 yyjim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var scrapViewControllers: [ScrapController]
    init(scraps: [Scrap]) {
        self.scrapViewControllers = scraps.map { (scrap) -> ScrapController in
            let scrapViewModel = ScrapViewModel(scrap: scrap)
            return ScrapController(scrapVM: scrapViewModel)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        for sc in scrapViewControllers {
            self.view.addSubview(sc.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createScrapController(forScrap scrap: Scrap) {
    }
    
}

