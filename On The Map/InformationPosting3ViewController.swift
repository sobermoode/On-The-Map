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
    
    // initial view outlets
    @IBOutlet weak var yourLocationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // the navigation bar
    var navBar: UINavigationBar!
    
    // everything needed for the map
    let geocoder = CLGeocoder()
    var locationMap: MKMapView!
    var currentSearch: CLPlacemark!
    var submittedLinkTextField: UITextField!
    
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
        // show the activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        // get the user's location
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
                    // create the map view and its view elements
                    self.locationMap = self.createMap()
                    self.submittedLinkTextField = self.createSubmittedLinkTextField()
                    let submitLinkButton = self.createSubmitLinkButton()
                    let refineSearchButton = self.createRefineSearchButton()
                    
                    if let placemarks = placemarks
                    {
                        // if the search term returns ambiguous results, we'll use the first one as the "best";
                        // if that isn't what the user wanted, they can refine their search
                        if let bestResult = placemarks.first as? CLPlacemark
                        {
                            // save the current search
                            self.currentSearch = bestResult
                            
                            // set the map on the coordinates of the search location
                            self.locationMap.region = MKCoordinateRegion(
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
                            
                            self.locationMap.addAnnotation( pin )
                            
                            // stop and hide the activity indicator
                            self.activityIndicator.stopAnimating()
                            
                            // add the map to the view
                            self.locationMap.addSubview( self.submittedLinkTextField )
                            self.locationMap.addSubview( submitLinkButton )
                            self.locationMap.addSubview( refineSearchButton )
                            self.view.addSubview( self.locationMap )
                            
                        }
                    }
                }
            }
        }
    }
    
    // functions to create the map view and its view elements
    
    func createMap() -> MKMapView
    {
        // create the map
        let newMap = MKMapView( frame: CGRect(
            origin: CGPoint(
                x: 0, y: 64
            ),
            size: CGSize(
                width: self.view.frame.width, height: self.view.frame.height - 64
            )
        ) )
        
        return newMap
    }
    
    func createSubmittedLinkTextField() -> UITextField
    {
        let newSubmittedLinkTextField = UITextField(
            frame: CGRect(
                x: 25, y: 10,
                width: CGRectGetWidth( self.locationMap.frame)  - 50, height: 30
            )
        )
        newSubmittedLinkTextField.backgroundColor = UIColor.whiteColor()
        newSubmittedLinkTextField.font = UIFont( name: "AvenirNext-Regular", size: 14 )
        newSubmittedLinkTextField.textAlignment = NSTextAlignment.Center
        newSubmittedLinkTextField.placeholder = "Link to your stuff"
        newSubmittedLinkTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        
        return newSubmittedLinkTextField
    }
    
    func createSubmitLinkButton() -> UIButton
    {
        let newSubmitLinkButton = UIButton(
            frame: CGRect(
                x: CGRectGetMidX( self.locationMap.frame ) - 100, y: 45,
                width: 200, height: 30
            )
        )
        newSubmitLinkButton.backgroundColor = UIColor.lightGrayColor()
        newSubmitLinkButton.setTitle(
            "Submit link",
            forState: UIControlState.Normal
        )
        newSubmitLinkButton.titleLabel?.font = UIFont( name: "AvenirNext-DemiBold", size: 14 )
        newSubmitLinkButton.setTitleColor( UIColor.whiteColor(), forState: UIControlState.Normal )
        newSubmitLinkButton.addTarget(
            self,
            action: "submitLink:",
            forControlEvents: UIControlEvents.TouchUpInside
        )
        
        return newSubmitLinkButton
    }
    
    func createRefineSearchButton() -> UIButton
    {
        let newRefineSearchButton = UIButton(
            frame: CGRect(
                x: CGRectGetMidX( self.locationMap.frame ) - 100,
                y: self.locationMap.frame.height - 40,
                width: 200, height: 30
            )
        )
        newRefineSearchButton.backgroundColor = UIColor.lightGrayColor()
        newRefineSearchButton.setTitle(
            "Refine search",
            forState: UIControlState.Normal
        )
        newRefineSearchButton.titleLabel?.font = UIFont( name: "AvenirNext-DemiBold", size: 14 )
        newRefineSearchButton.setTitleColor( UIColor.whiteColor(), forState: UIControlState.Normal )
        newRefineSearchButton.addTarget(
            self,
            action: "hideMap:",
            forControlEvents: UIControlEvents.TouchUpInside
        )
        
        return newRefineSearchButton
    }
    
    // submit the user's link
    func submitLink( sender: UIButton )
    {
        // make sure there's something in the text field
        if submittedLinkTextField.text.isEmpty
        {
            createAlert(
                title: "Whoops!",
                message: "Please submit a link to your work 😁"
            )
        }
        else
        {
            // can that URL be opened?
            let studentURL = NSURL( string: submittedLinkTextField.text )!
            if isValidURL( studentURL )
            {
                var assembledData = [ String : AnyObject ]()
                assembledData[ "uniqueKey" ] = "1234"
                assembledData[ "firstName" ] = OnTheMapClient.UdacityInfo.userFirstName
                assembledData[ "lastName" ] = OnTheMapClient.UdacityInfo.userLastName
                assembledData[ "mapString" ] = currentSearch.name
                assembledData[ "mediaURL" ] = submittedLinkTextField.text
                assembledData[ "latitude" ] = currentSearch.location.coordinate.latitude
                assembledData[ "longitude" ] = currentSearch.location.coordinate.longitude
                
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
                        // let the tab bar controller know to refresh its views
                        if let tabController = self.presentingViewController as? MapAndTableViewController
                        {
                            tabController.currentLocation = self.currentSearch
                            tabController.refreshResults()
                        }
                        else
                        {
                            self.createAlert(
                                title: "Whoops!",
                                message: "There was a problem updating the map."
                            )
                        }
                        
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
                self.createAlert(
                    title: "Whoops!",
                    message: "That wasn't a valid URL."
                )
            }
        }
    }
    
    // NOTE:
    // this was a suggestion from my previous code review
    func isValidURL( url: NSURL ) -> Bool
    {
        let request = NSURLRequest( URL: url )
        
        return NSURLConnection.canHandleRequest( request )
    }
    
    // remove the map, so the user can refine their search
    func hideMap( sender: UIButton )
    {
        locationMap.removeFromSuperview()
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
