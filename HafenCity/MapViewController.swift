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
    optional func toggleLeftPanel() -> Bool
}

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locations = [Location]()
    var navigationBarHidden = false
    var delegate: MapViewControllerDelegate?
    var locationDelegate: LocationViewControllerDelegate?
    var mapEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
//    @IBAction func didTap(sender: UITapGestureRecognizer) {
//        if (showingLeft == true) {
//            showingLeft = delegate?.toggleLeftPanel?()
//            enableMap()
//        }
//    }
    
    func toggleMap() {
        if (mapEnabled) {
            disableMap()
        } else {
            enableMap()
        }
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
    
    func enableMap() {
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        mapView.userInteractionEnabled = true
        mapEnabled = true
    }
    
    func disableMap() {
        mapView.zoomEnabled = false
        mapView.scrollEnabled = false
        mapView.userInteractionEnabled = false
        mapEnabled = false
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "DetailsLocation" {
            let nav = segue.destinationViewController as UINavigationController
            let controller = nav.topViewController as LocationViewController
            controller.delegate = self.locationDelegate
            let annotation = sender as CustomAnnotation
            controller.annotation = annotation
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
