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
import CoreLocation
import Firebase
import FirebaseDatabase
import FirebaseAuth


class ViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {
    

    let geocoder = Geocoder.sharedGeocoder
    let directions = Directions.sharedDirections
    
   // let rootRef = FIRDatabase.database().referenceFromURL("https://mappie-1369.firebaseio.com/user")
   // var messageRef: FIRDatabaseReference!

    
    // let ref = Firebase(url: "https://mappie-1369.firebaseio.com/user")
    
    
    var currentLocation: String = ""
    
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var mapView: MGLMapView!
    
    let locationManager = CLLocationManager()
    let serviceManager = ServiceManager()
    var searchBarText1 = SearchText()
    var searchBarText: String = ""
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.mapView.showsUserLocation = true
        let rootRef = FIRDatabase.database().reference()
        let ref = "\(rootRef)/user"
        
        print(rootRef)
        print(ref)
        
        UIChanges()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //searchBar.text = searchBarText1.searchBarText
        
        self.locationManager.startUpdatingLocation()
        
        //let searchBarText = NSUserDefaults.standardUserDefaults().objectForKey("searchBarText")
        
            print(searchBarText14)
            serviceManager.allNearbyRestaurantsRequest(String(searchBarText14)) { (listRestaurants, coordinates) in
                let center = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                self.mapView.setCenterCoordinate(center, zoomLevel: 12, animated: true)
            
                let currentPoint = MGLPointAnnotation()
                currentPoint.coordinate = coordinates
                self.mapView.addAnnotation(currentPoint)
                list = listRestaurants
                for pin in listRestaurants {
                //print(each)
                self.dropPin(pin)
                }
            }
            self.mapView.reloadInputViews()
        }


    func dropPin(pin: Pin) {
                let point = MGLPointAnnotation()
                point.coordinate = pin.coordinates
                point.title = pin.name
                point.subtitle = pin.address
                self.mapView.addAnnotation(point)
    }
    
    func UIChanges() {
        
        goButton.layer.cornerRadius = goButton.frame.width/2
        goButton.clipsToBounds = true
        goButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        //searchBar.barTintColor = UIColor.whiteColor()
        //searchBar.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goSegue" {
            self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext

        }

        if segue.identifier == "HelpMe" {
            let viewController = segue.destinationViewController as! RandomPopViewController
            viewController.indexSelected = index
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
            self.currentLocation = placemark.name
        }
    }
    
    
    
    
    func  locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print ("Errors:" + error.localizedDescription)
    }
    
//    func covertAddressToLatLon(addresses: [String]) {
//        
//        for address in addresses {
//        
//            let address = address
//            let geocoder = CLGeocoder()
//        
//            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
//                if((error) != nil){
//                    print("Error", error)
//                }
//                if let placemark = placemarks?.first {
//                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
//                    self.dropPin(coordinates)
//                }
//            })
//        }
//    }
    
    func mapView(mapView: MGLMapView, imageForAnnotation annotation: MGLAnnotation) -> MGLAnnotationImage? {
        // Try to reuse the existing ‘pisa’ annotation image, if it exists.
        var annotationImage = mapView.dequeueReusableAnnotationImageWithIdentifier("point")
        
        if annotationImage == nil {
            // Leaning Tower of Pisa by Stefan Spieler from the Noun Project.
            var image = UIImage(named: "restaurant-1")!
            
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

    
    func polyRoute() {
        let pointw = MGLPointAnnotation()
        pointw.coordinate = CLLocationCoordinate2D(latitude: 38.9131752, longitude: -77.0324047)
        //point1.title = "Voodoo Doughnut"
        //point1.subtitle = "22 SW 3rd Avenue Portland Oregon, U.S.A."
        self.mapView.addAnnotation(pointw)
        
        let point2 = MGLPointAnnotation()
        point2.coordinate = CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365)
        //point2.title = "Voodoo Doughnut"
        //point2.subtitle = "22 SW 3rd Avenue Portland Oregon, U.S.A."
        self.mapView.addAnnotation(point2)
        
        let point3 = MGLPointAnnotation()
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
}

//extension ViewController: UISearchBarDelegate {
//    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//        let searchController = storyboard!.instantiateViewControllerWithIdentifier("Search") as! SearchAutoCompleteTableViewController
//        
//        self.presentViewController(searchController, animated: true, completion: nil)
//    }
//}

