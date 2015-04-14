//
//  NewGalleryViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 4/12/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

@objc
protocol NewGalleryViewControllerDelegate {
    func pageDidChange(page: Int)
}

class NewGalleryViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var delegate: NewGalleryViewControllerDelegate!
    var pageViewController: UIPageViewController!
    var images: [UIImage] = []
    var imageScrollViewControllers: [ImageScrollViewController?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for _ in 0..<images.count {
            imageScrollViewControllers.append(nil)
        }
        
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: [UIPageViewControllerOptionInterPageSpacingKey: 20])
        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.view.backgroundColor = .blackColor()
        UIPageControl.appearance().backgroundColor = .blackColor()
        
        let startingViewController = viewControllerAtIndex(0)
        pageViewController.setViewControllers([startingViewController!], direction: .Forward, animated: false, completion: nil)
        
        addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
    }
        
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ImageScrollViewController).index
        index--
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! ImageScrollViewController).index
        index++
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        if (index < 0) || (index >= images.count) {
            return nil
        }
        
        if let imageScrollViewController = imageScrollViewControllers[index] {
            return imageScrollViewController
        } else {
            let newImageScrollViewController = ImageScrollViewController()
            newImageScrollViewController.image = images[index]
            newImageScrollViewController.index = index
            imageScrollViewControllers[index] = newImageScrollViewController
            return newImageScrollViewController
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return images.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        if completed {
            let previousViewController = previousViewControllers.first as! ImageScrollViewController
            previousViewController.resetScrollViewContents()
            let index = (pageViewController.viewControllers.first as! ImageScrollViewController).index
            delegate.pageDidChange(index)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
