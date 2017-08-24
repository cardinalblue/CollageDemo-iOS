//
//  ViewController.swift
//  SimpleCollage
//
//  Created by yyjim on 18/08/2017.
//  Copyright © 2017 yyjim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate let addButton = UIButton(type: .custom)
    
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
        addButton.tag = 2007
        
        // Setup scrapControllers
        for sc in scrapViewControllers {
            setupScrapController(sc)
        }
        
        if #available(iOS 11.0, *) {
            view.addInteraction(UIDropInteraction(delegate: self))
            view.addInteraction(UIDragInteraction(delegate: self))
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
    
    fileprivate func addScrap(image: UIImage, size:CGSize, center:CGPoint) {
        let transform = CGAffineTransform(rotationAngle: CGFloat(arc4random_uniform(181)) * .pi / 180) // random rotation
        let scrap = ImageScrap(size: size, center: center, transform: transform, image: image)
        let scrapController = createScrapController(scrap: scrap)
        setupScrapController(scrapController)
        self.scrapViewControllers.append(scrapController)
    }
    
    @objc private func handleAddButtonPressed(_ sender: UIButton) {
        let named = "im_\(arc4random_uniform(4) + 1)"
        guard let image = UIImage(named: named) else {
            return
        }
        addScrap(image: image, size: image.size, center: view.center)
    }
}

@available (iOS 11, *)
extension ViewController : UIDropInteractionDelegate {
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        let dropLocation = session.location(in: view)
        
        session.loadObjects(ofClass: UIImage.self) { objects in
            guard let images = objects as? [UIImage] else {
                return
            }
            
            images.forEach { image in
                let maxDimension = CGFloat(200)
                let imageSize = image.size
                let scale = min(maxDimension/imageSize.width, maxDimension/imageSize.height)
                let scaledSize = CGSize(width: imageSize.width * scale, height: imageSize.height * scale)
                
                DispatchQueue.main.async {
                    self.addScrap(image: image, size: scaledSize, center: dropLocation)
                }
            }
        }
    }
}

@available(iOS 11.0, *)
extension ViewController: UIDragInteractionDelegate {
    func snapshotImageWithoutPlusButton() -> UIImage? {
        
        addButton.isHidden = true
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 1)
        let context = UIGraphicsGetCurrentContext()!
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        addButton.isHidden = false

        return image
    }
    
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        
        guard let image = snapshotImageWithoutPlusButton() else { return nil }
        
        let dragLocation = session.location(in: view)

        // Create a new view to display the image as a drag preview.
        let previewImageView = UIImageView(image: image)
        previewImageView.contentMode = .scaleAspectFit
        let size = image.size.scaleToFitDimension(dimension: 200)
        previewImageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        previewImageView.layer.borderWidth = 5
        previewImageView.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        
        // Provide a custom targeted drag preview.
        let target = UIDragPreviewTarget(container: view, center: dragLocation)
        
        return UITargetedDragPreview(view: previewImageView, parameters: UIDragPreviewParameters(), target: target)

    }
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        if let image = snapshotImageWithoutPlusButton() {
            let itemProvider = NSItemProvider(object: image)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            return [dragItem]
        }
        
        return []
    }
}

extension CGSize {
    func scaleToFitDimension(dimension:CGFloat) -> CGSize {
        let scale = min(dimension/width, dimension/height)
        return CGSize(width: width * scale, height: height * scale)
    }
}
