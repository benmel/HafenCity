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

class MapViewController: UIViewController, MKMapViewDelegate, MWPhotoBrowserDelegate {

    var mapView: MKMapView!
    var button: UIButton!
    var locations = [Location]()
    var mapLoaded = false
    var annotationsLoaded = false
    
    var galleryImages: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.edgesForExtendedLayout = .Top
        
        // set up map
        mapView = MKMapView()
        mapView.delegate = self
        mapView.showsPointsOfInterest = false
        self.view.addSubview(mapView)
        
        // set up button
        button = UIButton.buttonWithType(.Custom) as! UIButton
        button.addTarget(self, action: "centerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        // get managed context
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        // get locations
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName:"Location")
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as! [Location]?
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
            anView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView!.annotation = annotation
        }
        
        return anView
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        let annotation = view.annotation as! CustomAnnotation
        let imageNames = MWHelper.getImageNames(annotation.directory)
        let images = MWHelper.getImages(annotation.directory, imageNames: imageNames)
//      let textNames = MWHelper.getTextNames(annotation.directory, imageNames: imageNames)
        galleryImages = MWHelper.getGalleryImages(images)
        let browser = MWPhotoBrowser(delegate: self)
        MWHelper.configureBrowser(browser)
        self.navigationController?.pushViewController(browser, animated: true)
//        performSegueWithIdentifier("Location", sender: annotation)
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
    
    func numberOfPhotosInPhotoBrowser(photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(galleryImages.count)
    }
    
    func photoBrowser(photoBrowser: MWPhotoBrowser!, photoAtIndex index: UInt) -> MWPhotoProtocol! {
        if index < UInt(galleryImages.count) {
            return galleryImages.objectAtIndex(Int(index)) as! MWPhoto
        }
        
        return nil
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
        if segue.identifier == "Location" {
//            let controller = segue.destinationViewController as! LocationViewController
            let annotation = sender as! CustomAnnotation
//            controller.text = annotation.text
//            controller.directory = annotation.directory
//            controller.navigationItem.title = annotation.title
            
            let imageNames = MWHelper.getImageNames(annotation.directory)
            let images = MWHelper.getImages(annotation.directory, imageNames: imageNames)
//            let textNames = MWHelper.getTextNames(annotation.directory, imageNames: imageNames)
            galleryImages = MWHelper.getGalleryImages(images)
        }
    }
}
