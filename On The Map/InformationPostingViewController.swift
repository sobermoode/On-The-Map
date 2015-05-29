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
    
    // initial view outlets
    @IBOutlet weak var enterLocationView: UIView!
    @IBOutlet weak var findButton: BorderedButton!
    @IBOutlet weak var locationTextField: UITextField!
    
    // map view outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkSubmissionView: UIView!
    @IBOutlet weak var linkSubmissionTextField: UITextField!
    @IBOutlet weak var submitLinkButton: BorderedButton!
    
    let geocoder = CLGeocoder()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.hidden = true
        linkSubmissionView.hidden = true
        configureButtons()
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
    }

    @IBAction func findOnTheMap( sender: BorderedButton )
    {
        let address = locationTextField.text
        
        if address.isEmpty
        {
            // handle empty location with an alert
        }
        else
        {
            // NOTE:
            // I used the code from http://stackoverflow.com/a/24708029
            // as a reference for helping devise this code
            geocoder.geocodeAddressString( address )
            {
                placemarks, error in
                
                if let error = error
                {
                    // handle error with alert
                }
                else
                {
                    if let placemarks = placemarks
                    {
                        println( "Got the placemarks!!!" )
                        println( placemarks )
                        self.mapView.hidden = false
                        self.linkSubmissionView.hidden = false
                        self.enterLocationView.hidden = true
                    }
                }
            }
        }
    }
    
    @IBAction func submitLink( sender: BorderedButton )
    {
        println( "Submitting link..." )
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
