//
//  BobaMapViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/18/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import Mapbox
import MapboxGeocoder
import MapboxDirections
import Contacts
import CoreLocation


class BobaMapViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    @IBOutlet weak var goButton: UIButton!
    var serviceManager = ServiceManager()
    let locationManager = CLLocationManager()
    let geocoder = Geocoder.sharedGeocoder
    
    
    //var searchBarText = NSUserDefaults.standardUserDefaults().objectForKey("searchBarText")

    var index: Int = 1

    @IBOutlet weak var mapView: MGLMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIChanges()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    
    func UIChanges() {
        goButton.layer.cornerRadius = goButton.frame.width/2
        goButton.clipsToBounds = true
        goButton.layer.borderColor = UIColor.whiteColor().CGColor
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        print(searchBarText14)
        callServiceManager(searchBarText14)
    }
    
    func callServiceManager(searchBarText: String) {
        serviceManager.requestBobaPlaces(String(searchBarText)) { (bobaPlacesList, coordinates) in
            let center = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
            self.mapView.setCenterCoordinate(center, zoomLevel: 12, animated: true)
            list = bobaPlacesList
            for pin in bobaPlacesList {
                self.dropPin(pin)
            }
        }
        self.mapView.reloadInputViews()
        
    }
    
    
    func dropPin(pin:Pin) {
        let point = MGLPointAnnotation()
        point.coordinate = pin.coordinates
        
        point.title = pin.name
        point.subtitle = pin.address
        self.mapView.addAnnotation(point)
    }
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Try to reuse the existing ‘pisa’ annotation image, if it exists.
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("point")
        
        if annotationImage == nil {
            // Leaning Tower of Pisa by Stefan Spieler from the Noun Project.
            var image = UIImage(named: "drink-1")!
            
            // The anchor point of an annotation is currently always the center. To
            // shift the anchor point to the bottom of the annotation, the image
            // asset includes transparent bottom padding equal to the original image
            // height.
            //
            // To make this padding non-interactive, we create another image object
            // with a custom alignment rect that excludes the padding.
            image = image.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, image.size.height/2, 0))
            
            // Initialize the ‘pisa’ annotation image with the UIImage we just loaded.
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: "point")
        }
        
        return annotationImage
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        mapView.userTrackingMode = .Follow
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        //NSUserDefaults.standardUserDefaults().setObject(location!, forKey: "currentLocation")
        
        mapView.setCenterCoordinate(center, zoomLevel: 12, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        let options = ReverseGeocodeOptions(coordinate: CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude))
        
        let task = geocoder.geocode(options: options) { (placemarks, attribution, error) in
            let placemark = placemarks![0]
            print(placemark.postalAddress!.street)
            self.callServiceManager(placemark.postalAddress!.street)
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HelpMe" {
            let viewController = segue.destinationViewController as! RandomPopViewController
            viewController.indexSelected = index
 
        }
    }
    
    
    func  locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print ("Errors:" + error.localizedDescription)
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    

}
