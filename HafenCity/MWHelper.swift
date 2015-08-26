//
//  MWHelper.swift
//  HafenCity
//
//  Created by Ben Meline on 8/25/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

class MWHelper {
        
    static func getGalleryImages(images: [UIImage]) -> NSMutableArray {
        let array: NSMutableArray = []
        for image in images {
            array.addObject(MWPhoto(image: image))
        }
        return array
    }
    
    static func configureBrowser(browser: MWPhotoBrowser) {
        browser.hidesBottomBarWhenPushed = false
        browser.displayActionButton = false
        browser.enableGrid = false
        browser.enableSwipeToDismiss = false
        browser.zoomPhotosToFill = false
        browser.edgesForExtendedLayout = .Top
    }
    
    static func getImageNames(directory: String) -> [String] {
        var imageNames = [String]()
        let imageFullDirectory = "Images/" + directory
        let path = NSBundle.mainBundle().pathForResource(imageFullDirectory, ofType: nil)
        var error: NSError? = nil
        let directoryContents = NSFileManager.defaultManager().contentsOfDirectoryAtPath(path!, error: &error)
        let list = directoryContents as! [String]
        imageNames += list
        return imageNames
    }
    
    static func getImages(directory: String, imageNames: [String]) -> [UIImage] {
        var images = [UIImage]()
        let imageFullDirectory = "Images/" + directory
        for name in imageNames {
            let path = NSBundle.mainBundle().pathForResource(name, ofType: nil, inDirectory: imageFullDirectory)
            let image = UIImage(contentsOfFile: path!)
            images.append(image!)
        }
        return images
    }
    
    static func getTextNames(directory: String, imageNames: [String]) -> [String?] {
        var textList = [String?]()
        let textFullDirectory = "Images/" + directory
        for name in imageNames {
            let filename = name.stringByDeletingPathExtension
            let textPath = NSBundle.mainBundle().pathForResource(filename, ofType: "txt", inDirectory: textFullDirectory)
            let text = String(contentsOfFile: textPath!, encoding: NSUTF8StringEncoding, error: nil)!
            textList.append(text)
        }
        return textList
    }
    
}
