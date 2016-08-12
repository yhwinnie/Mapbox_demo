//
//  TabScrollViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/18/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import ACTabScrollView
import Mapbox
import MapboxGeocoder
import MapboxDirections
import Contacts
import CoreLocation


class TabScrollViewController: UIViewController, ACTabScrollViewDelegate, ACTabScrollViewDataSource {
    
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var contentViews = [AnyObject]()
    var names = ["Food", "Coffee/Boba", "Activites"]
    
    var searchBarText1 = SearchText()
    let locationManager = CLLocationManager()
    let geocoder = Geocoder.sharedGeocoder
    
    
    @IBOutlet weak var tabScrollView: ACTabScrollView!
    
    var searchBar:UISearchBar!
    
    var viewControllers = [UIViewController]()
    var indexSelected: Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        searchBar = UISearchBar(frame: CGRectMake(0, 0, screenSize.width - 30, 20))
        searchBar.text = searchBarText1.searchBarText
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        

        
        searchBar.delegate = self
        searchBar.placeholder = "Enter address"
        
        //addConstraints()
        
        
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        tabScrollView.delegate = self
        tabScrollView.dataSource = self
        tabScrollView.defaultPage = 2
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        viewControllers.append(storyboard.instantiateViewControllerWithIdentifier("MapView") as! ViewController)
        viewControllers.append(storyboard.instantiateViewControllerWithIdentifier("BobaMap") as! BobaMapViewController)
        //viewControllers.append(storyboard.instantiateViewControllerWithIdentifier("ActivitiesMap") as! ActivitiesViewController)
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        for i in 0 ..< viewControllers.count {
            let vc = viewControllers[i]            /* set somethings for vc */
            
            addChildViewController(vc) // don't forget, it's very important
            
            contentViews.append(vc.view)
        }
        
        // set navigation bar appearance
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.translucent = false
            //navigationBar.tintColor = UIColor.whiteColor()
            //navigationBar.barTintColor = UIColor(red:0.20, green:0.60, blue:0.40, alpha:1.0)
            navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            navigationBar.shadowImage = UIImage()
        }
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    
    func addConstraints() {
        let topLeftViewLeadingConstraint = NSLayoutConstraint(item: self.searchBar, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal
            , toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 2)
        
        let topLeftViewTopConstraint = NSLayoutConstraint(item: self.searchBar, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal
            , toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 2)
        
        let topLeftViewTrailingConstraint = NSLayoutConstraint(item: self.searchBar, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal
            , toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 2)
        
//        let bottomLeftViewBottomConstraint = NSLayoutConstraint(item: self.searchBar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal
//            , toItem: self.navigationController?.navigationBar, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 2)
        
        NSLayoutConstraint.activateConstraints([topLeftViewLeadingConstraint, topLeftViewTopConstraint, topLeftViewTrailingConstraint])
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.text = searchBarText14
        if searchBar.text != nil {
            NSUserDefaults.standardUserDefaults().setObject(searchBarText1.searchBarText, forKey: "searchBarText")
        }
        searchBarText14 = searchBar.text!
    }
    
    func tabScrollView(tabScrollView: ACTabScrollView, didChangePageTo index: Int) {
        //tabSelected = index
    }
    
    func tabScrollView(tabScrollView: ACTabScrollView, didScrollPageTo index: Int) {
        //tabSelected = index
    }
    
    func numberOfPagesInTabScrollView(tabScrollView: ACTabScrollView) -> Int {
        return viewControllers.count
    }
    
    
    func tabScrollView(tabScrollView: ACTabScrollView, tabViewForPageAtIndex index: Int) -> UIView {
        // create a label
        let label = UILabel()
        label.text = names[index]
        label.textAlignment = .Center
        
        // if the size of your tab is not fixed, you can adjust the size by the following way.
        label.sizeToFit() // resize the label to the size of content
        label.frame.size = CGSize(
            width: label.frame.size.width + 28,
            height: label.frame.size.height + 36) // add some paddings
        
        return label
    }
    
    func tabScrollView(tabScrollView: ACTabScrollView, contentViewForPageAtIndex index: Int) -> UIView {
        
        return contentViews[index] as! UIView
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        // let sourceController = segue.sourceViewController as! EnterAddressesViewController
    }
}


extension TabScrollViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        let searchController = storyboard!.instantiateViewControllerWithIdentifier("Search") as! UINavigationController
        
        self.presentViewController(searchController, animated: true, completion: nil)
    }
}

extension TabScrollViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let location = locations.last
        _ = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        self.locationManager.stopUpdatingLocation()
        
        let options = ReverseGeocodeOptions(coordinate: CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude))
        
        geocoder.geocode(options: options) { (placemarks, attribution, error) in
            
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                self.searchBar.text = "Current Location"
                
                searchBarText14 = (placemark.postalAddress?.street)!
            }
            
        }
    }
    
    func  locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print ("Errors:" + error.localizedDescription)
    }
}
