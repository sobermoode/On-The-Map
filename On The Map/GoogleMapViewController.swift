//
//  GoogleMapViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 5/24/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit
import MapKit

class GoogleMapViewController: UIViewController {
    
    var studentLocations = [ StudentLocation ]()
    var studentMap: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // get the student locations from Parse
        OnTheMapClient.sharedInstance().getStudentLocations
        {
            // completion handler...
            success, studentLocations, error in
            
            // if there was an error retrieving the student locations
            if let error = error
            {
                println( error )
            }
            // otherwise, we have locations to pin on the map
            else if success
            {
                if let studentLocations = studentLocations
                {
                    // save the locations
                    self.studentLocations = studentLocations
                    
                    // map updates must be made on the main thread
                    dispatch_async( dispatch_get_main_queue(),
                    {
                        // create the map and center it on hermosa beach, ca
                        self.studentMap = MKMapView( frame: self.view.frame )
                        self.studentMap.region = MKCoordinateRegion(
                            center: CLLocationCoordinate2DMake( 33.862, -118.399 ),
                            span: MKCoordinateSpan( latitudeDelta: 15.0, longitudeDelta: 15.0 )
                        )
                        
                        // set the map as the view
                        self.view = self.studentMap
                        
                        // pin the student locations to the map
                        self.addLocationsToMap( studentLocations )
                    } )
                }
            }
        }
    }
    
    // the function receives the array of student locations from Parse
    // and then creates pins for each student with their relevant info
    // and adds the pin to the map
    func addLocationsToMap( locations: [ StudentLocation ] )
    {
        for location in locations
        {
            var pin = MKPointAnnotation()
            pin.coordinate = location.coordinate
            pin.title = location.title
            pin.subtitle = location.subtitle
            
            studentMap.addAnnotation( pin )
        }
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
