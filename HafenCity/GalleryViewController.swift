//
//  GalleryViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 4/1/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    var pageImages: [UIImage] = []
//    var pageViews: [UIImageView?] = []
    var pageViews: [ImageScrollViewController?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize scroll view
        self.automaticallyAdjustsScrollViewInsets = false
        scrollView = UIScrollView(frame: self.view.frame)
        self.view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.pagingEnabled = true
        scrollView.backgroundColor = .blackColor()
        
        // Initialize page control
        let pageControlHeight = CGFloat(50)
        pageControl = UIPageControl(frame: CGRectMake(0, self.view.frame.size.height-pageControlHeight, self.view.frame.size.width, pageControlHeight))
        self.view.addSubview(pageControl)
        UIPageControl.appearance().backgroundColor = .blackColor()
        
        // 1
        pageImages = [UIImage(named:"1.png")!,
            UIImage(named:"2.png")!,
            UIImage(named:"3.png")!,
            UIImage(named:"4.png")!,
            UIImage(named:"5.png")!]
        
        let pageCount = pageImages.count
        
        // 2
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 4
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), pagesScrollViewSize.height)
        
        // 5
        loadVisiblePages()
    }
    
    func loadPage(page: Int) {
        
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // 1
        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            // 2
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            // 3
//            let newPageView = UIImageView(image: pageImages[page])
//            newPageView.contentMode = .ScaleAspectFit
//            newPageView.frame = frame
//            scrollView.addSubview(newPageView)
            let newPageView = ImageScrollViewController()
            newPageView.image = pageImages[page]
            self.addChildViewController(newPageView)
            newPageView.view.frame = frame
            self.scrollView.addSubview(newPageView.view)
            newPageView.didMoveToParentViewController(self)
            
            // 4
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
//            pageView.removeFromSuperview()
//            pageView.view.removeFromSuperview()
            pageView.willMoveToParentViewController(nil)
            pageView.view.removeFromSuperview()
            pageView.removeFromParentViewController()
            pageViews[page] = nil
        }
        
    }
    
    func loadVisiblePages() {
        
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
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
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // Load the pages that are now on screen
        loadVisiblePages()
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
