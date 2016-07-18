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


    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.barTintColor = UIColor.whiteColor()
        searchBar.becomeFirstResponder()

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
            let viewController = segue.destinationViewController as! ViewController

            viewController.searchBarText1.searchBarText = self.resultsArray[index!.row]
            print(self.resultsArray[index!.row])
            print(viewController.searchBarText1.searchBarText = self.resultsArray[index!.row])
        }

    }
}



extension SearchAutoCompleteTableViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar,
                   textDidChange searchText: String){
        

        
        let geocoder = Geocoder.sharedGeocoder
        
        let options = ForwardGeocodeOptions(query: searchBar.text!)
        
        // To refine the search, you can set various properties on the options object.
        options.allowedISOCountryCodes = ["CA"]
        options.focalLocation = CLLocation(latitude: 45.3, longitude: -66.1)
        options.allowedScopes = [.Address, .PointOfInterest]
        
        let task = geocoder.geocode(options: options) { (placemarks, attribution, error) in
            let placemark = placemarks![0]
            //print(placemark.name)
            // 200 Queen St
            //print(placemark.qualifiedName)
            // 200 Queen St, Saint John, New Brunswick E2L 2X1, Canada
            
            let coordinate = placemark.location.coordinate
            //print("\(coordinate.latitude), \(coordinate.longitude)")
            // 45.270093, -66.050985
            
            for placemark in placemarks! {
                //print(placemark)
                self.resultsArray.append(placemark.qualifiedName)
                self.tableView.reloadData()
                
            }
            
            
            
        }
    }
}
