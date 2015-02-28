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
    optional func toggleLeftPanel() -> Bool
    optional func collapseSidePanels()
}

class CenterViewController: UIViewController, SidePanelViewControllerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate, LocationViewControllerDelegate {
        
    var delegate: CenterViewControllerDelegate?
    var showingLeft: Bool?
    var navigationBarHidden = false
    var mapViewController: MapViewController!
    var listViewController: ListViewController!
    var tourViewController = UIViewController()
    var creditsViewController = UIViewController()
    
    // MARK: Button actions
    
    @IBAction func menuTapped(sender: AnyObject) {
        showingLeft = delegate?.toggleLeftPanel?()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mapViewController = self.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as MapViewController
        mapViewController.locationDelegate = self
        addViewController(mapViewController)
        
        listViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ListViewController") as ListViewController
        listViewController.view.frame.origin.y = 64
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.25, animations: {
            self.navigationController?.navigationBar.alpha = 1
            return
            }, completion: { _ in
                self.navigationBarHidden = false
            }
        )
    }
    
    func toggleNavBar() {
        if (!navigationBarHidden) {
            UIView.animateWithDuration(0.25, animations: {
                self.navigationController?.navigationBar.alpha = 0
                return
                }, completion: { _ in
                    self.navigationBarHidden = true
                }
            )
        } else {
            UIView.animateWithDuration(0.25, animations: {
                self.navigationController?.navigationBar.alpha = 1
                return
                }, completion: { _ in
                    self.navigationBarHidden = false
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
        showingLeft = delegate?.toggleLeftPanel?()
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
    
    func toggleMap() {
        
    }
            
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}