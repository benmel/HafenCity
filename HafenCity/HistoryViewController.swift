//
//  HistoryViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 3/3/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, MWPhotoBrowserDelegate, UITabBarControllerDelegate {
    
    let directory = "history"
    let textDirectory = "history_text"
    var galleryImages: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
        
        let imageNames = MWHelper.getImageNames(directory)
        let images = MWHelper.getImages(directory, imageNames: imageNames)
        let textArray = MWHelper.getTextArray(textDirectory, imageNames: imageNames)
        galleryImages = MWHelper.getGalleryImages(images, textArray: textArray)
        let browser = BMPhotoBrowser(delegate: self)
        MWHelper.configureBrowser(browser)
        browser.alwaysShowControls = true
        
        self.navigationController?.pushViewController(browser, animated: false)
        self.tabBarController?.delegate = self
    }
 
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        // Prevent popping view controller
        if self.tabBarController?.selectedViewController == viewController && self.navigationController == viewController  {
            return false
        } else {
            return true
        }
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
