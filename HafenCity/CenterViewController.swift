//
//  CenterViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit

@objc
protocol CenterViewControllerDelegate {
    func toggleLeftPanel() -> Bool
    func collapseSidePanels() -> Bool
}

class CenterViewController: UIViewController, SidePanelViewControllerDelegate, MapViewControllerDelegate, ListViewControllerDelegate, HistoryViewControllerDelegate {
        
    var delegate: CenterViewControllerDelegate?
    var showingLeft: Bool?
    
    var mapViewController: MapViewController!
    var listViewController: ListViewController!
    var historyViewController: HistoryViewController!
    var creditsViewController: CreditsViewController!
    
    var mapViewControllerLoaded = false
    
    // MARK: Button actions
    
    @IBAction func menuTapped(sender: AnyObject) {
        showingLeft = delegate?.toggleLeftPanel()
        //disable interaction with child view controller
        updateChildInteraction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as MapViewController
        mapViewController.delegate = self
        
        listViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ListViewController") as ListViewController
        listViewController.delegate = self
        addViewController(listViewController)
        
        historyViewController = self.storyboard!.instantiateViewControllerWithIdentifier("HistoryViewController") as HistoryViewController
        historyViewController.delegate = self
        
        creditsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("CreditsViewController") as CreditsViewController
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if !mapViewControllerLoaded {
            addViewController(mapViewController)
            mapViewControllerLoaded = true
        }
    }
    
    func viewSelected(view: String) {
        let oldvc = self.childViewControllers.last as UIViewController
        if view == "Map" {
            cycleViewControllers(mapViewController)
        } else if view == "Locations" {
            cycleViewControllers(listViewController)
        } else if view == "History" {
            cycleViewControllers(historyViewController)
        } else if view == "Credits" {
            cycleViewControllers(creditsViewController)
        }
        showingLeft = delegate?.toggleLeftPanel()
        updateChildInteraction()
    }
    
    func addViewController(viewController: UIViewController) {
        self.addChildViewController(viewController)
        viewController.view.frame = self.view.frame
        self.view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
    
    func removeViewController(viewController: UIViewController) {
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
        
    func cycleViewControllers(viewController: UIViewController) {
        let temp = self.childViewControllers
        let oldViewController = self.childViewControllers.last as UIViewController
        removeViewController(oldViewController)
        addViewController(viewController)
    }
    
    func shouldCollapseMenu() {
        showingLeft = delegate?.collapseSidePanels()
        updateChildInteraction()
    }
    
    func updateChildInteraction() {
        if (showingLeft == true) {
            disableChildInteraction()
        } else {
            enableChildInteraction()
        }
    }
    
    func disableChildInteraction() {
        NSNotificationCenter.defaultCenter().postNotificationName("disableInteraction", object: self)
    }
    
    func enableChildInteraction() {
        NSNotificationCenter.defaultCenter().postNotificationName("enableInteraction", object: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}