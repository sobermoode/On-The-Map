//
//  MapAndTableViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 5/19/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit
import MapKit

class MapAndTableViewController: UITabBarController {
    
    var didPost: Bool?
    var currentLocation: CLLocationCoordinate2D?
    
    override func viewWillAppear( animated: Bool )
    {
        // create the navigation bar
        createNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func createNavigationBar()
    {
        // create a navigation bar for the buttons
        let frameSize = self.view.frame
        var navBar = UINavigationBar( frame: CGRectMake( 0, 0, frameSize.width, 64 ) )
        
        // create a navigation item for the navigation bar
        var navItem = UINavigationItem( title: "On The Map" )
        
        // create the navigation bar buttons
        let logoutButton = UIBarButtonItem(
            title: "Logout",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "logout"
        )
        
        let pinButton = UIBarButtonItem(
            image: UIImage( named: "pin" ),
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "dropPin"
        )
        
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Refresh,
            target: self,
            action: "refreshResults"
        )
        
        // add the buttons to the navigation item
        navItem.leftBarButtonItem = logoutButton
        navItem.rightBarButtonItems = [ refreshButton, pinButton ]
        
        // add all the navigation items to the navigation bar
        navBar.items = [ navItem ]
        
        // add the complete navigation bar to the view
        self.view.addSubview( navBar )
    }
    
    // to return to the UdacityLoginViewController
    func logout()
    {
        dismissViewControllerAnimated( true, completion: nil )
    }
    
    // bring up the InformationPostingViewController,
    // dismiss it when a location is successfully added to the map
    func dropPin()
    {
        let infoView = self.storyboard?.instantiateViewControllerWithIdentifier( "InformationPostingView" ) as! InformationPostingViewController
        
        presentViewController( infoView, animated: true, completion: nil )
    }
    
    func refreshResults()
    {
        OnTheMapClient.sharedInstance().getStudentLocations
        {
            success, studentLocations, error in
            
            if let error = error
            {
                self.createAlert(
                    title: "Whoops!",
                    message: error
                )
            }
            else if success
            {
                if let studentLocations = studentLocations
                {
                    dispatch_async( dispatch_get_main_queue(),
                    {
                        // update the pins on the map view
                        let googleMapView = self.viewControllers?.first as! GoogleMapViewController
                        googleMapView.studentLocations = studentLocations
                        googleMapView.studentMap.removeAnnotations( googleMapView.studentMap.annotations )
                        googleMapView.addLocationsToMap()
                        
                        // center the map on the just-posted location (if one was just posted)
                        if self.didPost!
                        {
                            googleMapView.centerMapOnLocation( self.currentLocation! )
                        }
                        
                        // update the student list on the table view
                        let studentTableView = self.viewControllers?.last as! StudentListTableViewController
                        studentTableView.studentLocations = studentLocations
                        studentTableView.tableView.reloadData()
                    } )
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
