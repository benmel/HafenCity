//
//  LocationViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 2/5/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    var annotation: CustomAnnotation?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imagePathLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        titleLabel.text = annotation?.title
        imagePathLabel.text = annotation?.imagePath
        textLabel.text = annotation?.text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
