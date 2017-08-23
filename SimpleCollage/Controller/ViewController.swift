//
//  ViewController.swift
//  SimpleCollage
//
//  Created by yyjim on 18/08/2017.
//  Copyright © 2017 yyjim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let addButton = UIButton(type: .custom)
    
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
        view.backgroundColor = UIColor.white
        
        // Add button
        view.addSubview(addButton)
        addButton.setTitle("+", for: .normal)
        addButton.setTitleColor(.black, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 49)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        addButton.addTarget(self, action: #selector(handleAddButtonPressed(_:)), for: .touchUpInside)
        
        // Setup scrapControllers
        for sc in scrapViewControllers {
            setupScrapController(sc)
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
    
    func setupScrapController(_ scrapController: ScrapController) {
        view.addSubview(scrapController.view)
    }
    
    @objc private func handleAddButtonPressed(_ sender: UIButton) {
        let named = "im_\(arc4random_uniform(4) + 1)"
        guard let image = UIImage(named: named) else {
            return
        }
        let scrap = ImageScrap(size: image.size, center: view.center, image: image)
        let scrapController = createScrapController(scrap: scrap)
        setupScrapController(scrapController)
        self.scrapViewControllers.append(scrapController)
    }
}

