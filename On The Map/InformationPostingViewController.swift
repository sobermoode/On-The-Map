//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 5/28/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class InformationPostingViewController: UIViewController {
    
    // search view outlets
    @IBOutlet weak var enterLocationView: UIView!
    @IBOutlet weak var findButton: BorderedButton!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // map view outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkSubmissionView: UIView!
    @IBOutlet weak var linkSubmissionTextField: UITextField!
    @IBOutlet weak var submitLinkButton: BorderedButton!
    @IBOutlet weak var refineSearchButton: BorderedButton!
    
    // for use with geocoding the student's location
    let geocoder = CLGeocoder()
    
    // to set the map view on a just-posted location
    var currentLocation: CLLocationCoordinate2D?
    var didPost = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.hidden = true
        linkSubmissionView.hidden = true
        refineSearchButton.hidden = true
        configureButtons()
        
        //Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func configureButtons()
    {
        findButton.themeBorderedButton()
        findButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        findButton.highlightedBackingColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha:1.0)
        findButton.backingColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        findButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        submitLinkButton.themeBorderedButton()
        submitLinkButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        submitLinkButton.highlightedBackingColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha:1.0)
        submitLinkButton.backingColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        submitLinkButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        refineSearchButton.themeBorderedButton()
        refineSearchButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        refineSearchButton.highlightedBackingColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha:1.0)
        refineSearchButton.backingColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        refineSearchButton.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func findOnTheMap( sender: BorderedButton )
    {
        // show the activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        let address = locationTextField.text
        
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
                    if let placemarks = placemarks
                    {
                        // if the search term returns ambiguous results, we'll use the first one as the "best";
                        // if that isn't what the user wanted, they can refine their search
                        if let bestResult = placemarks.first as? CLPlacemark
                        {
                            // set the map on the coordinates of the search location
                            self.mapView.region = MKCoordinateRegion(
                                center: bestResult.location.coordinate,
                                span: MKCoordinateSpan(
                                    latitudeDelta: 0.1,
                                    longitudeDelta: 0.1
                                )
                            )
                            
                            // drop a pin at this location
                            var pin = MKPointAnnotation()
                            pin.coordinate = bestResult.location.coordinate
                            pin.title = bestResult.locality
                            pin.subtitle = "\( bestResult.location.coordinate.latitude ), \( bestResult.location.coordinate.longitude )"
                            
                            self.mapView.addAnnotation( pin )
                            
                            // set the current location
                            self.currentLocation = bestResult.location.coordinate
                            
                            // show the map view and link submission view;
                            // hide the search view
                            self.mapView.hidden = false
                            self.linkSubmissionView.hidden = false
                            self.refineSearchButton.hidden = false
                            self.enterLocationView.hidden = true
                            
                            // stop and hide the activity indicator
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func submitLink( sender: BorderedButton )
    {
        if linkSubmissionTextField.text.isEmpty
        {
            createAlert(
                title: "Whoops!",
                message: "Please submit a link to your work 😁"
            )
        }
        else if let enteredURL = NSURL( string: linkSubmissionTextField.text )
        {
            var assembledData = [ String : AnyObject ]()
            assembledData[ "uniqueKey" ] = "1234"
            assembledData[ "firstName" ] = OnTheMapClient.UdacityInfo.userFirstName
            assembledData[ "lastName" ] = OnTheMapClient.UdacityInfo.userLastName
            assembledData[ "mapString" ] = locationTextField.text
            assembledData[ "mediaURL" ] = linkSubmissionTextField.text
            assembledData[ "latitude" ] = currentLocation?.latitude
            assembledData[ "longitude" ] = currentLocation?.longitude
            
            // Parse POST request
            OnTheMapClient.sharedInstance().postNewStudentInfo( assembledData )
            {
                success, postingError in
                
                if let error = postingError
                {
                    // handle with alert
                    dispatch_async( dispatch_get_main_queue(),
                    {
                        self.createAlert(
                            title: "Whoops!",
                            message: "There was a problem putting your location on the map."
                        )
                    } )
                }
                else if success
                {
                    // successfully added the location to the map
                    self.didPost = true
                    
                    // dismiss this view controller
                    self.dismissViewControllerAnimated(
                        true,
                        completion: nil
                    )
                }
            }
        }
        else
        {
            // if the supplied URL is invalid in some way
            createAlert(
                title: "Whoops!",
                message: "Please enter a valid URL."
            )
        }
    }
    
    @IBAction func refineSearch( sender: BorderedButton )
    {
        // hide the map view and link submission view;
        // show the search view
        self.mapView.hidden = true
        self.linkSubmissionView.hidden = true
        self.refineSearchButton.hidden = true
        self.enterLocationView.hidden = false
    }
    
    @IBAction func cancelPinDrop( sender: UIButton )
    {
        dismissViewControllerAnimated( true, completion: nil )
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
    
    // refresh the map view when this view disappears
    override func viewWillDisappear( animated: Bool )
    {
        let tabController = presentingViewController as! MapAndTableViewController
        
        // let the tab controller know if a new location was posted
        tabController.didPost = didPost
        
        // if so, give the tab controller the new location
        if didPost
        {
            tabController.currentLocation = currentLocation
        }
        
        tabController.refreshResults()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
