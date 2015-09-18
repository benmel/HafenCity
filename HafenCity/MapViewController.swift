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
    var centerButton: UIButton!
    var satelliteButton: UIButton!
    var locations:[Location] = []
    var mapLoaded = false
    var annotationsLoaded = false
    var galleryImages: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        setupNavBar()
        
        // set up map
        mapView = MKMapView()
        mapView.delegate = self
        mapView.showsPointsOfInterest = false
        setCenter(false)
        
        self.view.addSubview(mapView)
        
        // set up buttons
        centerButton = UIButton.buttonWithType(.Custom) as! UIButton
        centerButton.addTarget(self, action: "centerTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(centerButton)
        
        satelliteButton = UIButton.buttonWithType(.Custom) as! UIButton
        satelliteButton.addTarget(self, action: "satelliteTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(satelliteButton)
        
        // get managed context
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        // get locations
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName:"Location")
        if let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [Location] {
            locations = fetchedResults
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        // set up buttons
        let centerImage = UIImage(named: "Center")!
        let centerImageFocus = centerImage.imageWithRenderingMode(.AlwaysTemplate)
        let sizeCenter = centerImage.size
        let xCenter = self.view.frame.width - sizeCenter.width - 10
        let yCenter = self.view.frame.height - sizeCenter.height - 15
        let frameCenter = CGRectMake(xCenter, yCenter, sizeCenter.width, sizeCenter.height)
        centerButton.frame = frameCenter
        centerButton.setImage(centerImage, forState: .Normal)
        centerButton.setImage(centerImageFocus, forState: .Highlighted)

        let satelliteImage = UIImage(named: "Satellite")!
        let satelliteImageFocus = satelliteImage.imageWithRenderingMode(.AlwaysTemplate)
        let sizeSatellite = satelliteImage.size
        let xSatellite = xCenter
        let ySatellite = yCenter - sizeSatellite.height - 15
        let frameSatellite = CGRectMake(xSatellite, ySatellite, sizeSatellite.width, sizeSatellite.height)
        satelliteButton.frame = frameSatellite
        satelliteButton.setImage(satelliteImage, forState: .Normal)
        satelliteButton.setImage(satelliteImageFocus, forState: .Selected)
        satelliteButton.setImage(satelliteImageFocus, forState: .Highlighted)
        
        // set up map
        mapView.frame = self.view.frame
        if !mapLoaded {
            setCenter(true)
            mapLoaded = true
        }
    }
    
    func setupNavBar() {
        self.navigationController?.navigationBar.tintColor = .whiteColor()
        self.navigationController?.navigationBar.barStyle = .Black
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 0, blue: 0.4, alpha: 1)
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
    
    func satelliteTapped(sender: UIButton!) {
        if mapView.mapType == .Standard {
            mapView.mapType = .Satellite
            sender.selected = true
        } else {
            mapView.mapType = .Standard
            sender.selected = false
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
        galleryImages = MWHelper.getGalleryImages(images, text: annotation.text)
        let browser = MWPhotoBrowser(delegate: self)
        MWHelper.configureBrowser(browser)
        self.navigationController?.pushViewController(browser, animated: true)
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
}
