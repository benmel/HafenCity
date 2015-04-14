//
//  GalleryViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 4/1/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

@objc
protocol GalleryViewControllerDelegate {
    func pageDidChange(page: Int)
}

class GalleryViewController: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var delegate: GalleryViewControllerDelegate!
    
    var pageImages: [UIImage] = []
    var pageControllers: [ImageScrollViewController?] = []
    let pageSpacing:CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize page control
        pageControl = UIPageControl()
        UIPageControl.appearance().backgroundColor = .blackColor()
        pageControl.addTarget(self, action: "pageControlTapped:", forControlEvents: .ValueChanged)
        pageControl.defersCurrentPageDisplay = true
        self.view.addSubview(pageControl)
        
        // Initialize scroll view
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .blackColor()
        self.view.addSubview(scrollView)
                
        let pageCount = pageImages.count
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        for _ in 0..<pageCount {
            pageControllers.append(nil)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let pageControlHeight = CGFloat(50)
        pageControl.frame = CGRectMake(0, self.view.frame.size.height-pageControlHeight, self.view.frame.size.width, pageControlHeight)
        
        var frame = self.view.frame
        frame.origin.x -= pageSpacing
        frame.size.width += 2 * pageSpacing
        frame.size.height -= pageControlHeight
        scrollView.frame = frame
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), pagesScrollViewSize.height)
        
        loadVisiblePages()
    }
    
    func loadPage(page: Int) {
        
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // 1
        if let pageController = pageControllers[page] {
            // Do nothing. The view is already loaded.
        } else {
            // 2
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page) + pageSpacing
            frame.origin.y = 0.0
            frame.size.width -= 2 * pageSpacing
            
            // 3
            let newPageController = ImageScrollViewController()
            newPageController.image = pageImages[page]
            self.addChildViewController(newPageController)
            newPageController.view.frame = frame
            scrollView.addSubview(newPageController.view)
            newPageController.didMoveToParentViewController(self)
            
            // 4
            pageControllers[page] = newPageController
        }
    }
    
    func purgePage(page: Int) {
        
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageController = pageControllers[page] {
            pageController.willMoveToParentViewController(nil)
            pageController.view.removeFromSuperview()
            pageController.removeFromParentViewController()
            pageControllers[page] = nil
        }
        
    }
    
    func resetPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        if let pageController = pageControllers[page] {
            pageController.resetScrollViewContents()
        }
    }
    
    func resetHiddenPages() {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        let firstPage = page - 1
        let lastPage = page + 1
        
        resetPage(firstPage)
        resetPage(lastPage)
    }
    
    func loadVisiblePages() {
        
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    func pageControlTapped(control: UIPageControl) {
        // Change scroll view to this page
        let page = control.currentPage
        var frame = scrollView.bounds
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0.0
        scrollView.scrollRectToVisible(frame, animated: true)
        resetHiddenPages()
    }
    
    func updatePage() {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        delegate.pageDidChange(page)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
        updatePage()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        resetHiddenPages()
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
