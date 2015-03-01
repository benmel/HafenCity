//
//  LocationViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 2/5/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

@objc
protocol LocationViewControllerDelegate {
    func didTapView()
}

class LocationViewController: UIViewController, UIPageViewControllerDataSource {
    
    var delegate: LocationViewControllerDelegate?
//    var annotation: CustomAnnotation?
    var text: String?
    private var pageViewController: UIPageViewController?
    private var textView: UITextView?
    
    // Initialize it right away here
    private let contentImages = [
        "DSC_0257_s",
        "DSC_0258_s",
        "DSC_0259_s",
        "DSC_0260_s",
        "DSC_0261_s",
        "DSC_0262_s",
        "DSC_0263_s",
        "DSC_0264_s",
        "DSC_0265_s",
        "DSC_0266_s",
        "DSC_0267_s"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createPageViewController()
        setupPageControl()
        setupTextView()
        setupHideNavBarAndTextView()
    }
    
    private func createPageViewController() {
        
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as UIPageViewController
        pageController.dataSource = self
        pageController.view.frame = self.view.frame
        
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.darkGrayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.blackColor()
    }
    
    private func setupTextView() {
        // set frame
        let frame = self.view.frame
        let x: CGFloat = 10
        let width = frame.size.width - frame.origin.x - 2*x
        let height: CGFloat = 150
        let y = frame.size.height - frame.origin.y - height - 46
        let frameText = CGRectMake(x, y, width, height)
        textView = UITextView(frame: frameText)
//        textView!.frame = frameText
        
        // attributes
//        textView!.text = annotation?.text
        textView!.text = text
        textView!.font = UIFont.systemFontOfSize(18)
        textView!.textColor = UIColor.whiteColor()
        textView!.selectable = false
        textView!.editable = false
        
        // background
        textView!.backgroundColor = UIColor(white: 0, alpha: 0.5)
        textView!.layer.cornerRadius = 5
        textView!.clipsToBounds = true
        
        self.view.addSubview(textView!)
    }
    
    private func setupHideNavBarAndTextView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped")
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func viewTapped() {
        if (self.textView?.alpha == 1) {
            UIView.animateWithDuration(0.25, animations: {
                    self.textView?.alpha = 0
                    return
                }
            )
        } else {
            UIView.animateWithDuration(0.25, animations: {
                    self.textView?.alpha = 1
                    return
                }
            )
        }
        delegate?.didTapView()
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as PageItemController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as PageItemController
        
        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> PageItemController? {
        
        if itemIndex < contentImages.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("ItemController") as PageItemController
            pageItemController.itemIndex = itemIndex
            
            let imageName = contentImages[itemIndex]
            let path = NSBundle.mainBundle().pathForResource(imageName, ofType: ".JPG")
            let image = UIImage(contentsOfFile: path!)
            pageItemController.image = image
            
            return pageItemController
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
