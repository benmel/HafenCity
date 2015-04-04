//
//  HistoryViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 3/3/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

@objc
protocol HistoryViewControllerDelegate {
    func shouldCollapseMenu()
}

class HistoryViewController: UIViewController, UIPageViewControllerDataSource {
    
    var delegate: HistoryViewControllerDelegate!
    var directory = "history"
    var tDirectory = "history_text"
    private var pageViewController: UIPageViewController?
    private var textView: UITextView!
    
    var tapRecognizerMenu: UITapGestureRecognizer!
    var swipeRecognizer: UISwipeGestureRecognizer!
    
    // Initialize it right away here
    private var contentImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .blackColor()
        // set up tap gestures
        tapRecognizerMenu = UITapGestureRecognizer(target: self, action: "collapseMenu")
        tapRecognizerMenu.enabled = false
        self.view.addGestureRecognizer(tapRecognizerMenu)

        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: "collapseMenu")
        swipeRecognizer.direction = .Left
        swipeRecognizer.enabled = false
        self.view.addGestureRecognizer(swipeRecognizer)
        
        // set up interaction notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "disableView", name:"disableInteraction", object: self.parentViewController)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enableView", name:"enableInteraction", object: self.parentViewController)

        getImagePaths()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        createPageViewController()
        setupPageControl()
    }
    
    private func getImagePaths() {
        let imageDirectory = "Images/" + directory
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
    
    func collapseMenu() {
        delegate.shouldCollapseMenu()
    }
    
    func enableView() {
        pageViewController?.view.userInteractionEnabled = true
        tapRecognizerMenu.enabled = false
        swipeRecognizer.enabled = false
    }

    func disableView() {
        pageViewController?.view.userInteractionEnabled = false
        tapRecognizerMenu.enabled = true
        swipeRecognizer.enabled = true
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
            let imageDirectory = "Images/" + directory
            let path = NSBundle.mainBundle().pathForResource(imageName, ofType: nil, inDirectory: imageDirectory)
            let image = UIImage(contentsOfFile: path!)
            
            let textDirectory = "Images/" + tDirectory
            let filename = imageName.stringByDeletingPathExtension
            let pathText = NSBundle.mainBundle().pathForResource(filename, ofType: "txt", inDirectory: textDirectory)
            let text = String(contentsOfFile: pathText!, encoding: NSUTF8StringEncoding, error: nil)!
            pageItemController.image = image
            pageItemController.text = text
            
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

//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
