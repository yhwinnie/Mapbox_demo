//
//  ActivitiesViewController.swift
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

class ActivitiesViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    
    @IBOutlet weak var goButton: UIButton!
    var serviceManager = ServiceManager()
    let locationManager = CLLocationManager()
    let geocoder = Geocoder.sharedGeocoder
    
    //var searchBarText = NSUserDefaults.standardUserDefaults().objectForKey("searchBarText")
    
    
    var index: Int = 2
    
    @IBOutlet weak var mapView: MGLMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goButton.layer.cornerRadius = goButton.frame.width/2
        goButton.clipsToBounds = true
        goButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        
        //print (searchBarText)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.locationManager.startUpdatingLocation()
        //var searchBarText = NSUserDefaults.standardUserDefaults().objectForKey("searchBarText")
        
        callServiceManager(searchBarText14)
        
    }
    
    
    func callServiceManager(searchBarText: String) {
        serviceManager.requestActivitiesPlaces(String(searchBarText)) { (activitiesPlacesList, coordinates) in
            let center = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
            self.mapView.setCenterCoordinate(center, zoomLevel: 12, animated: true)
            
            //list = activitiesPlacesList
            
            for pin in activitiesPlacesList {
                self.dropPin(pin)
            }
        }
        self.mapView.reloadInputViews()
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        mapView.userTrackingMode = .Follow
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        
        mapView.setCenterCoordinate(center, zoomLevel: 12, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        let options = ReverseGeocodeOptions(coordinate: CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude))
        
        _ = geocoder.geocode(options: options) { (placemarks, attribution, error) in
            let placemark = placemarks![0]
            self.callServiceManager(placemark.postalAddress!.street)
        }
        
    }
    
    
    func  locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print ("Errors:" + error.localizedDescription)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HelpMe" {
            let viewController = segue.destinationViewController as! RandomPopViewController
            viewController.indexSelected = index
            
        }
    }
    
    func dropPin(pin: Pin) {
        
        let point = MGLPointAnnotation()
        point.coordinate = pin.coordinates
        point.title = pin.name
        point.subtitle = pin.address
        self.mapView.addAnnotation(point)
        self.mapView.reloadInputViews()
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
}
