//
//  MapSearchViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 6/12/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit
import MapKit

class MapSearchViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var currentSearch: CLPlacemark!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set the map on the coordinates of the search location
        mapView.region = MKCoordinateRegion(
            center: currentSearch.location.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.1,
                longitudeDelta: 0.1
            )
        )
        
        // drop a pin at this location
        var pin = MKPointAnnotation()
        pin.coordinate = currentSearch.location.coordinate
        if let pinTitle = currentSearch.locality
        {
            pin.title = currentSearch.locality
        }
        else
        {
            pin.title = currentSearch.name
        }
        
        pin.subtitle = "\( currentSearch.location.coordinate.latitude ), \( currentSearch.location.coordinate.longitude )"
        
        mapView.addAnnotation( pin )
    }

    @IBAction func cancelToInfoView( sender: UIButton )
    {
        let infoView = presentingViewController as! InformationPostingView2Controller
        
        infoView.didCancelMapSearch = true
        
        dismissViewControllerAnimated( true, completion: nil )
    }
    
    @IBAction func refineSearch( sender: UIButton )
    {
        dismissViewControllerAnimated( true, completion: nil )
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
