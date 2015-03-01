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
//    optional func toggleLeftPanel() -> Bool
//    func shouldHideNavBar()
    func shouldCollapseMenu()
}

class MapViewController: UIViewController, MKMapViewDelegate/*, LocationViewControllerDelegate*/ {

    @IBOutlet weak var mapView: MKMapView!
    var locations = [Location]()
    var delegate: MapViewControllerDelegate?
    var locationDelegate: LocationViewControllerDelegate?
    var tapRecognizer: UITapGestureRecognizer?
    var swipeRecognizer: UISwipeGestureRecognizer?
    var edgeRecognizer: UIScreenEdgePanGestureRecognizer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set up interaction notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "disableMap", name:"disableInteraction", object: self.parentViewController)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enableMap", name:"enableInteraction", object: self.parentViewController)
        
        // set up tap gestures
        tapRecognizer = UITapGestureRecognizer(target: self, action: "collapseMenu")
        tapRecognizer?.enabled = false
        self.view.addGestureRecognizer(tapRecognizer!)
        
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: "collapseMenu")
        swipeRecognizer?.direction = .Left
        swipeRecognizer?.enabled = false
        self.view.addGestureRecognizer(swipeRecognizer!)
        
//        edgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: "openMenu")
//        edgeRecognizer?.edges = .Left
//        edgeRecognizer?.enabled = true
//        self.view.addGestureRecognizer(edgeRecognizer!)
        
        // set up map
        mapView.delegate = self
        setCenter()
        
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

        setAnnotations()
    }

    @IBAction func centerTapped(sender: AnyObject) {
        setCenter()
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
        performSegueWithIdentifier("DetailsLocation", sender: annotation)
    }
    
    func setCenter() {
        let location = CLLocationCoordinate2D(
            latitude: 53.541,
            longitude: 9.992
        )
        let span = MKCoordinateSpanMake(0.022, 0.022)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func collapseMenu() {
        delegate?.shouldCollapseMenu()
    }
    
    func enableMap() {
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        mapView.userInteractionEnabled = true
        tapRecognizer?.enabled = false
        swipeRecognizer?.enabled = false
    }
    
    func disableMap() {
        mapView.zoomEnabled = false
        mapView.scrollEnabled = false
        mapView.userInteractionEnabled = false
        tapRecognizer?.enabled = true
        swipeRecognizer?.enabled = true
    }
    
    func setAnnotations() {
        for location in locations {
            let coordinate = CLLocationCoordinate2D(
                latitude: location.coordY as CLLocationDegrees,
                longitude: location.coordX as CLLocationDegrees
            )
            
            let annotation = CustomAnnotation(location: coordinate)
            annotation.title = location.name
            annotation.imagePath = location.imagePath
            annotation.text = location.text
            mapView.addAnnotation(annotation)
        }
    }
    
//    func didTapView() {
//        delegate?.shouldHideNavBar()
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailsLocation" {
            let nav = segue.destinationViewController as UINavigationController
            let controller = nav.topViewController as LocationViewController
//            controller.delegate = self
            controller.delegate = locationDelegate
            let annotation = sender as CustomAnnotation
//            controller.annotation = annotation
            controller.text = annotation.text
            nav.navigationBar.topItem?.title = annotation.title
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
