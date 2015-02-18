//
//  LocationViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 2/5/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    var testString: String?
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        testLabel.text = testString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
