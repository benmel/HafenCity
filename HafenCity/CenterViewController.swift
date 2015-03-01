//
//  CenterViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit
import MapKit
import CoreData

@objc
protocol CenterViewControllerDelegate {
    func toggleLeftPanel() -> Bool
    func collapseSidePanels() -> Bool
}

class CenterViewController: UIViewController, SidePanelViewControllerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate, MapViewControllerDelegate, ListViewControllerDelegate, LocationViewControllerDelegate {
        
    var delegate: CenterViewControllerDelegate?
    var showingLeft: Bool?
    
    var mapViewController: MapViewController!
    var listViewController: ListViewController!
    var tourViewController = UIViewController()
    var creditsViewController = UIViewController()
    
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
        mapViewController.locationDelegate = self
        addViewController(mapViewController)
        
        self.automaticallyAdjustsScrollViewInsets = false
        listViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ListViewController") as ListViewController
        listViewController.delegate = self
        listViewController.locationDelegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (self.navigationController?.navigationBar.alpha == 0) {
            UIView.animateWithDuration(0.25, animations: {
                    self.navigationController?.navigationBar.alpha = 1
                    return
                }
            )
        }
    }
    
    func viewSelected(view: String) {
        let oldvc = self.childViewControllers.last as UIViewController
        if view == "Map" {
            cycleViewControllers(mapViewController)
        } else if view == "Locations" {
            cycleViewControllers(listViewController)
        } else if view == "Tour" {
            cycleViewControllers(tourViewController)
        } else if view == "Credits" {
            cycleViewControllers(creditsViewController)
        }
        showingLeft = delegate?.toggleLeftPanel()
        updateChildInteraction()
    }
    
    func addViewController(viewController: UIViewController) {
        self.addChildViewController(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
    }
    
    func removeViewController(viewController: UIViewController) {
        viewController.willMoveToParentViewController(nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
        
    func cycleViewControllers(viewController: UIViewController) {
        let oldViewController = self.childViewControllers.last as UIViewController
        removeViewController(oldViewController)
        addViewController(viewController)
    }
    
    func didTapView() {
        if (self.navigationController?.navigationBar.alpha == 1) {
            UIView.animateWithDuration(0.25, animations: {
                self.navigationController?.navigationBar.alpha = 0
                return
                }
            )
        } else {
            UIView.animateWithDuration(0.25, animations: {
                self.navigationController?.navigationBar.alpha = 1
                return
                }
            )
        }
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