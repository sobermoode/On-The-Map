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
    
    // map view outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkSubmissionView: UIView!
    @IBOutlet weak var linkSubmissionTextField: UITextField!
    @IBOutlet weak var submitLinkButton: BorderedButton!
    @IBOutlet weak var refineSearchButton: BorderedButton!
    
    let geocoder = CLGeocoder()
    
    var currentLocation: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.hidden = true
        linkSubmissionView.hidden = true
        refineSearchButton.hidden = true
        configureButtons()
        
        locationTextField.text = "hermosa beach, ca"
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

    @IBAction func findOnTheMap( sender: BorderedButton )
    {
        let address = locationTextField.text
        
        if address.isEmpty
        {
            // TODO: handle empty location with an alert
            println( "Please enter the location you're studying from 😁" )
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
                    // TODO: handle error with alert
                    println( "There was an error finding that location." )
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
                            
                            // set the current location
                            self.currentLocation = bestResult.location.coordinate
                            
                            // show the map view and link submission view;
                            // hide the search view
                            self.mapView.hidden = false
                            self.linkSubmissionView.hidden = false
                            self.refineSearchButton.hidden = false
                            self.enterLocationView.hidden = true
                        }
                        else
                        {
                            // TODO: handle this with an alert
                            println( "That location didn't match any results." )
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func submitLink( sender: BorderedButton )
    {
        println( "Submitting link..." )
        
        // Parse POST request
        
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
