//
//  InformationPosting3ViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 6/16/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit
import MapKit

class InformationPosting3ViewController: UIViewController {
    
    @IBOutlet weak var yourLocationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // the navigation bar
    var navBar: UINavigationBar!
    
    // for use with geocoding the student's location
    let geocoder = CLGeocoder()
    
    // for use when canceling from the map search view
    // var didCancelMapSearch = false
    
    // to let the tab bar controller know that a new location was posted
    var didPost: Bool = false
    var postedLocation: CLPlacemark!
    
    override func viewWillAppear( animated: Bool )
    {
        // create the nav bar
        setUpNavBar()
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
    
    func setUpNavBar()
    {
        // create the nav bar with the correct size
        navBar = UINavigationBar(
            frame: CGRect(
                origin: CGPoint(
                    x: 0,
                    y: 0
                ),
                size: CGSize(
                    width: view.frame.width,
                    height: 64
                )
            )
        )
        navBar.translucent = false
        
        // set the title
        var navItem = UINavigationItem( title: "Your Location" )
        
        // create the Cancel button
        var cancelButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Cancel,
            target: self,
            action: "cancel"
        )
        cancelButton.tintColor = UIColor.redColor()
        
        navItem.leftBarButtonItem = cancelButton
        
        // add the Cancel button to the nav bar
        navBar.items = [ navItem ]
        
        // add the nav bar to the view
        view.addSubview( navBar )
    }
    
    // Calls this function when the tap is recognized.
    func DismissKeyboard()
    {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing( true )
    }
    
    func cancel()
    {
        dismissViewControllerAnimated( true, completion: nil )
    }

    @IBAction func findOnTheMap( sender: UIButton )
    {
        // view.hidden = true
        
        // show the activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        let address = yourLocationTextField.text
        
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
                    let locationMap = MKMapView( frame: CGRect(
                        origin: CGPoint(
                            x: 0,
                            y: 64
                        ),
                        size: CGSize(
                            width: self.view.frame.width,
                            height: self.view.frame.height - 64
                        )
                    ) )
                    
                    if let placemarks = placemarks
                    {
                        // if the search term returns ambiguous results, we'll use the first one as the "best";
                        // if that isn't what the user wanted, they can refine their search
                        if let bestResult = placemarks.first as? CLPlacemark
                        {
                            // set the map on the coordinates of the search location
                            locationMap.region = MKCoordinateRegion(
                                center: bestResult.location.coordinate,
                                span: MKCoordinateSpan(
                                    latitudeDelta: 0.1,
                                    longitudeDelta: 0.1
                                )
                            )
                            
                            // drop a pin at this location
                            var pin = MKPointAnnotation()
                            pin.coordinate = bestResult.location.coordinate
                            
                            // the locality is cool, but if the user has a typo in what they entered,
                            // the search may come up in some random place, without that property set to anything.
                            // will use whatever was entered, in that case.
                            if let pinTitle = bestResult.locality
                            {
                                pin.title = bestResult.locality
                            }
                            else
                            {
                                pin.title = bestResult.name
                            }
                            
                            pin.subtitle = "\( bestResult.location.coordinate.latitude ), \( bestResult.location.coordinate.longitude )"
                            
                            locationMap.addAnnotation( pin )
                            
                            // stop and hide the activity indicator
                            self.activityIndicator.stopAnimating()
                            
                            self.view.addSubview( locationMap )
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
