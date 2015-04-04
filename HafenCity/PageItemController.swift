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
    var imageView: UIImageView!
    var textView: UITextView!
    
    var image: UIImage? {
        didSet {
            self.view.clipsToBounds = true
            imageView = UIImageView(image: image)
            if (image!.size.height > image!.size.width) {
                imageView.contentMode = .ScaleAspectFill
            } else {
                imageView.contentMode = .ScaleAspectFit
            }
            imageView.frame = self.view.frame
            self.view.addSubview(imageView)
        }
    }
    
    var text: String? {
        didSet {
            // set frame
            let frame = self.view.frame
            let x: CGFloat = 10
            let width = frame.size.width - frame.origin.x - 2*x
            let height: CGFloat = 125
            let y = frame.size.height - frame.origin.y - height - 46
            let frameText = CGRectMake(x, y, width, height)
            textView = UITextView(frame: frameText)
            
            // attributes
            textView!.text = text
            textView!.font = UIFont.systemFontOfSize(18)
            textView!.textColor = UIColor.whiteColor()
            textView!.selectable = false
            textView!.editable = false
            
            // background
            textView!.backgroundColor = UIColor(white: 0, alpha: 0.5)
            textView!.layer.cornerRadius = 5
            textView!.clipsToBounds = true
            
            self.view.addSubview(textView!)
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
