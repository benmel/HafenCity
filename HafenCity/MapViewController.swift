//
//  MapViewController.swift
//  HafenCity
//
//  Created by Ben Meline on 2/26/15.
//  Copyright (c) 2015 Ben Meline. All rights reserved.
//

import UIKit
import MapKit
import CoreData

@objc
protocol MapViewControllerDelegate {
    func shouldCollapseMenu()
}

class MapViewController: UIViewController, MKMapViewDelegate {

    var mapView: MKMapView!
    var button: UIButton!
    var locations = [Location]()
    var delegate: MapViewControllerDelegate!
    var tapRecognizer: UITapGestureRecognizer!
    var swipeRecognizer: UISwipeGestureRecognizer!
//    var edgeRecognizer: UIScreenEdgePanGestureRecognizer!
    var mapLoaded = false
    var annotationsLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set up interaction notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "disableMap", name:"disableInteraction", object: self.parentViewController)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enableMap", name:"enableInteraction", object: self.parentViewController)
        
        // set up tap gestures
        tapRecognizer = UITapGestureRecognizer(target: self, action: "collapseMenu")
        tapRecognizer.enabled = false
        self.view.addGestureRecognizer(tapRecognizer)
        
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: "collapseMenu")
        swipeRecognizer.direction = .Left
        swipeRecognizer.enabled = false
        self.view.addGestureRecognizer(swipeRecognizer)
        
//        edgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "openMenu")
//        edgeRecognizer.edges = .Left
//        edgeRecognizer.enabled = true
//        self.view.addGestureRecognizer(edgeRecognizer)
        
        // set up map
        mapView = MKMapView()
        mapView.delegate = self
        mapView.showsPointsOfInterest = false
        self.view.addSubview(mapView)
        
        // set up button
        button = UIButton.buttonWithType(.Custom) as UIButton
        button.addTarget(self, action: "centerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        // get managed context
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        // get locations
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName:"Location")
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [Location]?
        if let results = fetchedResults {
            locations = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // set up button
        let centerImage = UIImage(named: "map")
        let size = centerImage?.size
        let x = self.view.frame.width - size!.width - 10
        let y = self.view.frame.height - size!.height - 10
        let frame = CGRectMake(x, y, size!.width, size!.height)
        button.frame = frame
        button.setBackgroundImage(centerImage, forState: .Normal)
        
        // set up map
        mapView.frame = self.view.frame
        if !mapLoaded {
            setCenter(false)
            mapLoaded = true
        }
    }
        
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
        if !annotationsLoaded {
            setAnnotations()
            annotationsLoaded = true
        }
    }
    
    func centerTapped(sender: UIButton!) {
        setCenter(true)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if anView == nil {
            anView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
            anView!.animatesDrop = true
            anView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as UIButton
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView!.annotation = annotation
        }
        
        return anView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let annotation = view.annotation as CustomAnnotation
        performSegueWithIdentifier("Gallery", sender: annotation)
    }
    
    func setCenter(animated: Bool) {
        let location = CLLocationCoordinate2D(
            latitude: 53.541,
            longitude: 9.992
        )
        let span = MKCoordinateSpanMake(0.022, 0.022)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: animated)
    }
    
    func collapseMenu() {
        delegate.shouldCollapseMenu()
    }
    
    func enableMap() {
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        mapView.userInteractionEnabled = true
        tapRecognizer.enabled = false
        swipeRecognizer.enabled = false
    }
    
    func disableMap() {
        mapView.zoomEnabled = false
        mapView.scrollEnabled = false
        mapView.userInteractionEnabled = false
        tapRecognizer.enabled = true
        swipeRecognizer.enabled = true
    }
    
    func setAnnotations() {
        for location in locations {
            let coordinate = CLLocationCoordinate2D(
                latitude: location.coordY as CLLocationDegrees,
                longitude: location.coordX as CLLocationDegrees
            )
            
            let annotation = CustomAnnotation(location: coordinate)
            annotation.title = location.name
            annotation.directory = location.directory
            annotation.text = location.text
            mapView.addAnnotation(annotation)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Gallery" {
            let nav = segue.destinationViewController as UINavigationController
            let controller = nav.topViewController as GalleryViewController
            let annotation = sender as CustomAnnotation
            controller.text = annotation.text
            controller.directory = annotation.directory
            nav.navigationBar.topItem?.title = annotation.title
        }
    }
}
