//
//  SearchAutoCompleteTableViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/14/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import MapboxGeocoder



class SearchAutoCompleteTableViewController: UITableViewController {
    var resultsArray = [String]()

    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 345, 20))
   // @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.barTintColor = UIColor.whiteColor()
        searchBar.becomeFirstResponder()
        
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.translucent = false
            navigationBar.tintColor = UIColor.whiteColor()
            navigationBar.barTintColor = UIColor(red: 38.0 / 255, green: 191.0 / 255, blue: 140.0 / 255, alpha: 1)
            navigationBar.titleTextAttributes = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName) as? [String : AnyObject]
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            navigationBar.shadowImage = UIImage()
        }
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }



    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        cell.textLabel?.text = resultsArray[indexPath.row]

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToMap" {
            let index = tableView.indexPathForSelectedRow
            let viewController = segue.destinationViewController as! TabScrollViewController

            viewController.searchBarText1.searchBarText = self.resultsArray[index!.row]
//            print(self.resultsArray[index!.row])
//            print(viewController.searchBarText1.searchBarText = self.resultsArray[index!.row])
        }

    }
}



extension SearchAutoCompleteTableViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar,
                   textDidChange searchText: String){
        

        
        let geocoder = Geocoder.sharedGeocoder
        
        let options = ForwardGeocodeOptions(query: searchBar.text!)
        
        // To refine the search, you can set various properties on the options object.
        //options.allowedISOCountryCodes = ["CA"]
        options.focalLocation = CLLocation(latitude: 37.749536, longitude: -122.465068)
        options.allowedScopes = [.Address, .PointOfInterest]
        
        let task = geocoder.geocode(options: options) { (placemarks, attribution, error) in
            let placemark = placemarks![0]
            let coordinate = placemark.location.coordinate

            for placemark in placemarks! {
                self.resultsArray.insert(placemark.qualifiedName, atIndex: 0)
            }
            self.tableView.reloadData()
            
            
            
        }
    }
}
