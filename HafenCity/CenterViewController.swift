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
    optional func toggleLeftPanel()
    optional func toggleRightPanel()
    optional func collapseSidePanels()
}

class CenterViewController: UIViewController, SidePanelViewControllerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var creatorLabel: UILabel!
    
    var delegate: CenterViewControllerDelegate?
    
    func animalSelected(animal: Animal) {
        imageView.image = animal.image
        titleLabel.text = animal.title
        creatorLabel.text = animal.creator
        
        delegate?.collapseSidePanels?()
    }

    // MARK: Button actions
    
    @IBAction func kittiesTapped(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    @IBAction func puppiesTapped(sender: AnyObject) {
        delegate?.toggleRightPanel?()
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let location = CLLocationCoordinate2D(
            latitude: 53.541776,
            longitude: 9.993810
        )
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
}