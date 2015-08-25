//
//  ImageViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 4/12/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image: UIImage!
    var imageView: UIImageView!
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView = UIImageView(image: image)
        self.view.addSubview(imageView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.frame = self.view.frame
        imageView.contentMode = .ScaleAspectFit
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

