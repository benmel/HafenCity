//
//  PageItemController.swift
//  HafenCity
//
//  Created by Ben Meline on 2/21/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

class PageItemController: UIViewController {

    // MARK: - Variables
    var itemIndex: Int = 0 // ***

    var image: UIImage? {
        didSet {
            self.view.clipsToBounds = true
            let newImageView = UIImageView(image: image)
            if (image?.size.height > image?.size.width) {
                newImageView.contentMode = .ScaleAspectFill
            } else {
                newImageView.contentMode = .ScaleAspectFit
            }
            var frame = self.view.frame
            newImageView.frame = frame
            self.view.addSubview(newImageView)
        }
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blackColor()
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
