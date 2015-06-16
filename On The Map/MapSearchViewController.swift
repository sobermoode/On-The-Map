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
    @IBOutlet weak var submittedLinkTextField: UITextField!
    
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
        
        // the locality is cool, but if the user has a typo in what they entered,
        // the search may come up in some random place, without that property set to anything.
        // will use whatever was entered, in that case.
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
    
    @IBAction func submitLink( sender: UIButton )
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
                        // pass the relevant information to the info posting view
                        let infoView = self.presentingViewController as! InformationPostingView2Controller
                        infoView.didPost = true
                        infoView.postedLocation = self.currentSearch
                        
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
    
    @IBAction func refineSearch( sender: UIButton )
    {
        dismissViewControllerAnimated( true, completion: nil )
    }
    
    // NOTE:
    // this was a suggestion from my previous code review
    func isValidURL( url: NSURL ) -> Bool
    {
        let request = NSURLRequest( URL: url )
        
        return NSURLConnection.canHandleRequest( request )
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
