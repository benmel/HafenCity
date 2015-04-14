//
//  ViewController.swift
//  ScrollViews
//

import UIKit

class ImageScrollViewController: UIViewController, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var image: UIImage!
    var imageView: UIImageView!
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.indicatorStyle = .White
        self.view.addSubview(scrollView)
        
        imageView = UIImageView(image: image)
        imageView.frame = CGRect(origin: CGPointMake(0.0, 0.0), size:image.size)
        scrollView.addSubview(imageView)
        
        var doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
    }
    
//    override func viewDidDisappear(animated: Bool) {
//        super.viewDidDisappear(animated)
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.frame = self.view.bounds
        scrollView.contentSize = image.size
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight);
        scrollView.minimumZoomScale = minScale;
        
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = minScale
        
        centerScrollViewContents()
    }
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        imageView.frame = contentsFrame
        
    }
    
    func resetScrollViewContents() {
        scrollView.zoomScale = scrollView.minimumZoomScale
        centerScrollViewContents()
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1
        let pointInView = recognizer.locationInView(imageView)
        
        // 2
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        // 3
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        centerScrollViewContents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

