//
//  InformationPostingView2Controller.swift
//  On The Map
//
//  Created by Aaron Justman on 6/11/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingView2Controller: UIViewController {

    // view outlets
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var findButton: UIButton!
    
    // for use with geocoding the student's location
    let geocoder = CLGeocoder()
    
    // for use when canceling from the map search view
    var didCancelMapSearch = false
    
    override func viewWillAppear(animated: Bool) {
        if didCancelMapSearch
        {
            cancel( cancelButton )
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // NOTE:
        // code taken from http://stackoverflow.com/a/27079103,
        // as per the suggestion from the code review
        // Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: "DismissKeyboard"
        )
        view.addGestureRecognizer( tap )
        
        // activityIndicator.hidesWhenStopped = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Calls this function when the tap is recognized.
    func DismissKeyboard()
    {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing( true )
    }
    
    @IBAction func cancel( sender: UIButton )
    {
        dismissViewControllerAnimated( true, completion: nil )
    }
    
    @IBAction func findOnTheMap( sender: UIButton )
    {
        // show the activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        let address = locationTextField.text
        
        // make sure there is a string to geocode
        if address.isEmpty
        {
            self.createAlert(
                title: "Whoops!",
                message: "Please enter the location you're studying from 😁"
            )
            
            // stop and hide the activity indicator
            activityIndicator.stopAnimating()
        }
        else
        {
            // NOTE:
            // I used the code from http://stackoverflow.com/a/24708029
            // as a reference when devising this solution
            geocoder.geocodeAddressString( address )
            {
                placemarks, error in
                
                if let error = error
                {
                    dispatch_async( dispatch_get_main_queue(),
                        {
                            self.createAlert(
                                title: "Whoops!",
                                message: "There was an error finding that location."
                            )
                    } )
                    
                    // stop and hide the activity indicator
                    self.activityIndicator.stopAnimating()
                }
                else
                {
                    let mapSearchView = self.storyboard?.instantiateViewControllerWithIdentifier( "MapSearch" ) as! MapSearchViewController
                    
                    // self.presentViewController( mapSearchView, animated: true, completion: nil )
                    
                    if let placemarks = placemarks
                    {
                        // if the search term returns ambiguous results, we'll use the first one as the "best";
                        // if that isn't what the user wanted, they can refine their search
                        if let bestResult = placemarks.first as? CLPlacemark
                        {
                            // set the location on the map view
                            mapSearchView.currentSearch = bestResult
                            
                            // present the map search controller
                            self.presentViewController( mapSearchView, animated: true, completion: nil )
                            
                            // set the map on the coordinates of the search location
//                            self.mapView.region = MKCoordinateRegion(
//                                center: bestResult.location.coordinate,
//                                span: MKCoordinateSpan(
//                                    latitudeDelta: 0.1,
//                                    longitudeDelta: 0.1
//                                )
//                            )
                            
                            // drop a pin at this location
//                            var pin = MKPointAnnotation()
//                            pin.coordinate = bestResult.location.coordinate
//                            pin.title = bestResult.locality
//                            pin.subtitle = "\( bestResult.location.coordinate.latitude ), \( bestResult.location.coordinate.longitude )"
//                            
//                            self.mapView.addAnnotation( pin )
//                            
//                            // set the current location
//                            self.currentLocation = bestResult.location.coordinate
//                            
//                            // show the map view and link submission view;
//                            // hide the search view
//                            self.mapView.hidden = false
//                            self.linkSubmissionView.hidden = false
//                            self.refineSearchButton.hidden = false
//                            self.enterLocationView.hidden = true
//                            
//                            // stop and hide the activity indicator
//                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    // NOTE:
    // alert code adapted from
    // http://stackoverflow.com/a/24022696
    func createAlert( #title: String, message: String )
    {
        var alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        alert.addAction( UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: nil )
        )
        
        self.presentViewController(
            alert,
            animated: true,
            completion: nil
        )
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
