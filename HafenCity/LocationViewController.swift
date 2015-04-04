//
//  LocationViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 4/4/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {

    var galleryViewController: GalleryViewController!
    var text: String?
    var directory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        galleryViewController = GalleryViewController()
        let imageNames = getImageNames()
        let images = getImages(imageNames)
        galleryViewController.pageImages = images
    }
    
    override func viewWillLayoutSubviews() {
        self.addChildViewController(galleryViewController)
        galleryViewController.view.frame = self.view.frame
        self.view.addSubview(galleryViewController.view)
        galleryViewController.didMoveToParentViewController(self)        
    }
    
    func getImageNames() -> [String] {
        var imageNames = [String]()
        let imageDirectory = "Images/" + directory!
        let path = NSBundle.mainBundle().pathForResource(imageDirectory, ofType: nil)
        var error: NSError? = nil
        let directoryContents = NSFileManager.defaultManager().contentsOfDirectoryAtPath(path!, error: &error)
        let list = directoryContents as [String]
        imageNames += list
        return imageNames
    }
    
    func getImages(imageNames: [String]) -> [UIImage] {
        var images = [UIImage]()
        let imageDirectory = "Images/" + directory!
        for name in imageNames {
            let path = NSBundle.mainBundle().pathForResource(name, ofType: nil, inDirectory: imageDirectory)
            let image = UIImage(contentsOfFile: path!)
            images.append(image!)
        }
        return images
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
