//
//  FilterPopUpViewController.swift
//  Mapbox_demo
//
//  Created by Winnie Wen on 7/14/16.
//  Copyright © 2016 wiwen. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FilterPopUpViewController: UIViewController {

    @IBOutlet weak var smallView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        smallView.layer.cornerRadius = 10.0
        smallView.layer.borderColor = UIColor.grayColor().CGColor
        smallView.layer.borderWidth = 0.5
        smallView.clipsToBounds = true
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        super.touchesBegan(touches, withEvent:event)
    }
    

    @IBAction func searchButton(sender: AnyObject) {
        

    }
}
