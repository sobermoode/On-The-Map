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
    
    // if the "cancel" action originated from the map search view,
    // then dimiss this view as well
    override func viewWillAppear( animated: Bool )
    {
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
    }
    
    // Calls this function when the tap is recognized.
    func DismissKeyboard()
    {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing( true )
    }
    
    // go back to the information posting view
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
                            
                            // stop and hide the activity indicator
                            self.activityIndicator.stopAnimating()
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
}
