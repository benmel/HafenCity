//
//  HistoryViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 3/3/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, MWPhotoBrowserDelegate {
    
//    var locationViewController: LocationViewController!
    var galleryImages: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        self.edgesForExtendedLayout = .Top
        
//        locationViewController = LocationViewController()
//        locationViewController.directory = "history"
//        locationViewController.textDirectory = "history_text"
        
//        self.addChildViewController(locationViewController)
//        self.view.addSubview(locationViewController.view)
//        locationViewController.didMoveToParentViewController(self)
        
        let directory = "history"
        let textDirectory = "history_text"
        
        let imageNames = MWHelper.getImageNames(directory)
        let images = MWHelper.getImages(directory, imageNames: imageNames)
        //      let textNames = MWHelper.getTextNames(annotation.directory, imageNames: imageNames)
        galleryImages = MWHelper.getGalleryImages(images)
        let browser = BMPhotoBrowser(delegate: self)
        MWHelper.configureBrowser(browser)
        
        self.navigationController?.pushViewController(browser, animated: false)
    }
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(galleryImages.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if index < UInt(galleryImages.count) {
            return galleryImages.objectAtIndex(Int(index)) as! MWPhoto
        }
        
        return nil
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
