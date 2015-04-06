//
//  HistoryViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 3/3/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit

@objc
protocol HistoryViewControllerDelegate {
    func shouldCollapseMenu()
}

class HistoryViewController: UIViewController {
    
    var delegate: HistoryViewControllerDelegate!
    var locationViewController: LocationViewController!
    
    var tapRecognizerMenu: UITapGestureRecognizer!
    var swipeRecognizer: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // set up tap gestures
        tapRecognizerMenu = UITapGestureRecognizer(target: self, action: "collapseMenu")
        tapRecognizerMenu.enabled = false
        self.view.addGestureRecognizer(tapRecognizerMenu)

        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: "collapseMenu")
        swipeRecognizer.direction = .Left
        swipeRecognizer.enabled = false
        self.view.addGestureRecognizer(swipeRecognizer)
        
        // set up interaction notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "disableView", name:"disableInteraction", object: self.parentViewController)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enableView", name:"enableInteraction", object: self.parentViewController)
        
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
    
    func collapseMenu() {
        delegate.shouldCollapseMenu()
    }
    
    func enableView() {
        locationViewController.view.userInteractionEnabled = true
        tapRecognizerMenu.enabled = false
        swipeRecognizer.enabled = false
    }

    func disableView() {
        locationViewController.view.userInteractionEnabled = false
        tapRecognizerMenu.enabled = true
        swipeRecognizer.enabled = true
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
