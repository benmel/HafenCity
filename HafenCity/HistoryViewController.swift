//
//  HistoryViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 3/3/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var locationViewController: LocationViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.edgesForExtendedLayout = .Top
        
        locationViewController = LocationViewController()
        locationViewController.directory = "history"
        locationViewController.textDirectory = "history_text"
        
        self.addChildViewController(locationViewController)
        self.view.addSubview(locationViewController.view)
        locationViewController.didMoveToParentViewController(self)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        locationViewController.view.frame = self.view.frame
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
