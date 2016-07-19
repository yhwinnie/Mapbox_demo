//
//  TabScrollViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/18/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import ACTabScrollView


class TabScrollViewController: UIViewController, ACTabScrollViewDelegate, ACTabScrollViewDataSource{
    
    var contentViews = [AnyObject]()
    var names = ["Food", "Boba", "Activites"]
    
    var searchBarText1 = SearchText()
    

    @IBOutlet weak var tabScrollView: ACTabScrollView!
    
    lazy   var searchBar:UISearchBar = UISearchBar(frame: CGRectMake(0, 0, 345, 20))

    var viewControllers = [UIViewController]()
    var indexSelected: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.placeholder = "Enter address"
        
        let leftNavBarButton = UIBarButtonItem(customView:searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        tabScrollView.delegate = self
        tabScrollView.dataSource = self
        tabScrollView.defaultPage = 3

        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        viewControllers.append(storyboard.instantiateViewControllerWithIdentifier("MapView") as! ViewController)
        viewControllers.append(storyboard.instantiateViewControllerWithIdentifier("BobaMap") as! BobaMapViewController)
        viewControllers.append(storyboard.instantiateViewControllerWithIdentifier("ActivitiesMap") as! ActivitiesViewController)
        
        //searchBar.text = "47 Seashore Drive"
        
        for i in 0 ..< viewControllers.count {
            let vc = viewControllers[i]            /* set somethings for vc */
            
            addChildViewController(vc) // don't forget, it's very important
            
            contentViews.append(vc.view)
        }
        
        // set navigation bar appearance
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //print(searchBarText1.searchBarText)
        searchBar.text = searchBarText1.searchBarText
        if let searchBarText = searchBar.text {
            NSUserDefaults.standardUserDefaults().setObject(searchBarText1.searchBarText, forKey: "searchBarText")
        }
    }
    
    func tabScrollView(tabScrollView: ACTabScrollView, didChangePageTo index: Int) {
        //print(index)
    }
    
    func tabScrollView(tabScrollView: ACTabScrollView, didScrollPageTo index: Int) {
    }
    
    // MARK: ACTabScrollViewDataSourceh
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