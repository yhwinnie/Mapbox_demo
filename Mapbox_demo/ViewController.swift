//
//  ViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/12/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import Mapbox
import MapboxGeocoder
import MapboxDirections
import Contacts

class ViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    let geocoder = Geocoder.sharedGeocoder
    let directions = Directions.sharedDirections
    
    var searchBarText1 = SearchText()

    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var mapView: MGLMapView!
    
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
        UIChanges()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.text = searchBarText1.searchBarText
        self.locationManager.startUpdatingLocation()
    }
    
    func dropPin() {
        //        let point = MGLPointAnnotation()
        //        point.coordinate = CLLocationCoordinate2D(latitude: 45.52258, longitude: -122.6732)
        //        point.title = "Voodoo Doughnut"
        //        point.subtitle = "22 SW 3rd Avenue Portland Oregon, U.S.A."
        //        self.mapView.addAnnotation(point)
    }
    
    func UIChanges() {
        
        segmentedControl.layer.borderColor = UIColor(red:0.20, green:0.60, blue:0.80, alpha:1.0).CGColor
        segmentedControl.layer.cornerRadius = 0.0
        segmentedControl.layer.borderWidth = 1.5
        
        goButton.layer.cornerRadius = goButton.frame.width/2
        goButton.clipsToBounds = true
        goButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        searchBar.barTintColor = UIColor.whiteColor()
        searchBar.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
        
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goSegue" {
            self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext

        }
    }
    
    

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        mapView.userTrackingMode = .Follow
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
    
        
        mapView.setCenterCoordinate(center, zoomLevel: 14, animated: true)
        self.locationManager.stopUpdatingLocation()
        
        
        let options = ReverseGeocodeOptions(coordinate: CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude))
        
        let task = geocoder.geocode(options: options) { (placemarks, attribution, error) in
            let placemark = placemarks![0]
            self.searchBar.text = placemark.name
        }
    }
    
    
    func  locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print ("Errors:" + error.localizedDescription)
    }
    

    
    func polyRoute() {
        var pointw = MGLPointAnnotation()
        pointw.coordinate = CLLocationCoordinate2D(latitude: 38.9131752, longitude: -77.0324047)
        //point1.title = "Voodoo Doughnut"
        //point1.subtitle = "22 SW 3rd Avenue Portland Oregon, U.S.A."
        self.mapView.addAnnotation(pointw)
        
        var point2 = MGLPointAnnotation()
        point2.coordinate = CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365)
        //point2.title = "Voodoo Doughnut"
        //point2.subtitle = "22 SW 3rd Avenue Portland Oregon, U.S.A."
        self.mapView.addAnnotation(point2)
        
        var point3 = MGLPointAnnotation()
        point3.coordinate = CLLocationCoordinate2D(latitude: 34.742133, longitude: -77.0367)
        self.mapView.addAnnotation(point3)
        let waypoints = [

            Waypoint(
                coordinate: CLLocationCoordinate2D(latitude: 38.9131752, longitude: -77.0324047),
                name: "Mapbox"),
            Waypoint(
                coordinate: CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365),
                name: "White House"),
            Waypoint(
                coordinate: CLLocationCoordinate2D(latitude: 34.742133, longitude: -77.0367),
                name: "White House")
            ]
        let options = RouteOptions(
            waypoints: waypoints,
            profileIdentifier: MBDirectionsProfileIdentifierAutomobile)
        options.includesSteps = true
        
        let task = directions.calculateDirections(options: options) { (waypoints, routes, error) in
            guard error == nil else {
                //print("Error calculating directions: \(error!)")
                return
            }
            
            if let route = routes?.first, leg = route.legs.first {
                //print("Route via \(leg):")
                
                let distanceFormatter = NSLengthFormatter()
                let formattedDistance = distanceFormatter.stringFromMeters(route.distance)
                
                let travelTimeFormatter = NSDateComponentsFormatter()
                travelTimeFormatter.unitsStyle = .Short
                let formattedTravelTime = travelTimeFormatter.stringFromTimeInterval(route.expectedTravelTime)
                
                //print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")
                
                for step in leg.steps {
                    //print("\(step.instructions)")
                    let formattedDistance = distanceFormatter.stringFromMeters(step.distance)
                    //print("— \(formattedDistance) —")
                }
                
                if route.coordinateCount > 0 {
                    // Convert the route’s coordinates into a polyline.
                    var routeCoordinates = route.coordinates!
                    let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                    
                    // Add the polyline to the map and fit the viewport to the polyline.
                    self.mapView.addAnnotation(routeLine)
                    self.mapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: UIEdgeInsetsZero, animated: true)
                }
            }
        }
    }
    
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        //let sourceController = segue.sourceViewController as! EnterAddressesViewController
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        let searchController = storyboard!.instantiateViewControllerWithIdentifier("Search") as! SearchAutoCompleteTableViewController
        
        self.presentViewController(searchController, animated: true, completion: nil)
    }
}

