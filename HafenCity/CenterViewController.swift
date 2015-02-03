//
//  CenterViewController.swift
//  SlideOutNavigation
//
//  Created by James Frost on 03/08/2014.
//  Copyright (c) 2014 James Frost. All rights reserved.
//

import UIKit
import MapKit

@objc
protocol CenterViewControllerDelegate {
    optional func toggleLeftPanel() -> Bool
    optional func collapseSidePanels()
}

class CenterViewController: UIViewController, SidePanelViewControllerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {
        
    var delegate: CenterViewControllerDelegate?
    var showingLeft: Bool?
    
    // MARK: Button actions
    
    @IBAction func menuTapped(sender: AnyObject) {
        showingLeft = delegate?.toggleLeftPanel?()
        if (showingLeft == true) {
            disableMap()
        } else {
            enableMap()
        }
    }
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        if (showingLeft == true) {
            showingLeft = delegate?.toggleLeftPanel?()
            enableMap()
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let location = CLLocationCoordinate2D(
            latitude: 53.541,
            longitude: 9.992
        )
        
        let span = MKCoordinateSpanMake(0.022, 0.022)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsPointsOfInterest = false
    }
    
    func enableMap() {
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        mapView.userInteractionEnabled = true
    }
    
    func disableMap() {
        mapView.zoomEnabled = false
        mapView.scrollEnabled = false
        mapView.userInteractionEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}