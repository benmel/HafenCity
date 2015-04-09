//
//  LocationViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 4/4/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, GalleryViewControllerDelegate {

    var galleryViewController: GalleryViewController!
    var textViewController: TextViewController!
    var text: String?
    var directory: String?
    var textDirectory: String?
    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = .Top
        
        galleryViewController = GalleryViewController()
        let imageNames = getImageNames()
        let images = getImages(imageNames)
        
        galleryViewController.pageImages = images
        galleryViewController.delegate = self
        
        textViewController = TextViewController()
        if textDirectory != nil {
            let textList = getTextNames(imageNames)
            textViewController.textList = textList
        } else {
            textViewController.text = text
        }
        
        self.addChildViewController(galleryViewController)
        textViewController.view.frame = self.view.frame
        self.view.addSubview(galleryViewController.view)
        galleryViewController.didMoveToParentViewController(self)
        
        textViewController.view.userInteractionEnabled = false
        self.addChildViewController(textViewController)
        self.view.addSubview(textViewController.view)
        textViewController.didMoveToParentViewController(self)
                
        button = UIButton.buttonWithType(.InfoLight) as UIButton
        button.tintColor = .whiteColor()
        button.alpha = 0.8
        button.addTarget(self, action: "infoButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        galleryViewController.view.frame = self.view.frame
        textViewController.view.frame = self.view.frame
        
        let buttonSize: CGFloat = 44
        let frameButton = CGRectMake(self.view.frame.size.width - buttonSize, self.view.frame.size.height - buttonSize - 4, buttonSize, buttonSize + 4)
        button.frame = frameButton
    }
    
    func getImageNames() -> [String] {
        var imageNames = [String]()
        let imageFullDirectory = "Images/" + directory!
        let path = NSBundle.mainBundle().pathForResource(imageFullDirectory, ofType: nil)
        var error: NSError? = nil
        let directoryContents = NSFileManager.defaultManager().contentsOfDirectoryAtPath(path!, error: &error)
        let list = directoryContents as [String]
        imageNames += list
        return imageNames
    }
    
    func getImages(imageNames: [String]) -> [UIImage] {
        var images = [UIImage]()
        let imageFullDirectory = "Images/" + directory!
        for name in imageNames {
            let path = NSBundle.mainBundle().pathForResource(name, ofType: nil, inDirectory: imageFullDirectory)
            let image = UIImage(contentsOfFile: path!)
            images.append(image!)
        }
        return images
    }
    
    func getTextNames(imageNames: [String]) -> [String?] {
        var textList = [String?]()
        let textFullDirectory = "Images/" + textDirectory!
        for name in imageNames {
            let filename = name.stringByDeletingPathExtension
            let textPath = NSBundle.mainBundle().pathForResource(filename, ofType: "txt", inDirectory: textFullDirectory)
            let text = String(contentsOfFile: textPath!, encoding: NSUTF8StringEncoding, error: nil)!
            textList.append(text)
        }
        return textList
    }
    
    func pageDidChange(page: Int) {
        if textDirectory != nil {
            textViewController.changeTextFromList(page)
        }
    }
    
    func infoButtonTapped(sender: UIButton!) {
        textViewController.toggleTextView()
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
