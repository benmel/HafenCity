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
    
    var text: String?
    var directory: String?
    private var pageViewController: UIPageViewController?
    private var textView: UITextView?
    
    // Initialize it right away here
    private var contentImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getImagePaths()
        createPageViewController()
        setupPageControl()
        setupTextView()
        setupHideNavBarAndTextView()
    }
    
    private func getImagePaths() {
        let imageDirectory = "Images/" + directory!
        let path = NSBundle.mainBundle().pathForResource(imageDirectory, ofType: nil)
        var error: NSError? = nil
        let directoryContents = NSFileManager.defaultManager().contentsOfDirectoryAtPath(path!, error: &error)
        let imageList = directoryContents as [String]
        contentImages += imageList
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
        let height: CGFloat = 170
        let y = frame.size.height - frame.origin.y - height - 46
        let frameText = CGRectMake(x, y, width, height)
        textView = UITextView(frame: frameText)
        
        // attributes
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
            let imageDirectory = "Images/" + directory!
            let path = NSBundle.mainBundle().pathForResource(imageName, ofType: nil, inDirectory: imageDirectory)
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
