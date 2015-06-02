//
//  GoogleMapViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 5/24/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//
//  NOTE (5/29/15):
//  I originally attempted to use the Google Maps API to implement these features,
//  but, while reading through the forums, looking for solutions to the many problems
//  I was having, I realized that I should be using MapKit instead. Once I made that
//  breakthrough, development went much smoother, and much more quickly. I pretty much
//  finished the project, before, during the process of adding polish, I discovered that
//  I probably should have remade this controller with a different name. But that's why
//  it's named the way it is.

import UIKit
import MapKit

class GoogleMapViewController: UIViewController, MKMapViewDelegate {
    
    var studentLocations = [ StudentLocation ]()
    var studentMap: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // get the student locations from Parse
        OnTheMapClient.sharedInstance().getStudentLocations
        {
            success, studentLocations, error in
            
            // if there was an error retrieving the student locations
            if let error = error
            {
                self.createAlert(
                    title: "Whoops!",
                    message: error
                )
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
                        // create the map and center it on hermosa beach, ca (my hometown 😁)
                        self.studentMap = MKMapView( frame: self.view.frame )
                        self.studentMap.region = MKCoordinateRegion(
                            center: CLLocationCoordinate2DMake( 33.862, -118.399 ),
                            span: MKCoordinateSpan(
                                latitudeDelta: 15.0,
                                longitudeDelta: 15.0
                            )
                        )
                        self.studentMap.delegate = self
                        
                        // set the map as the view
                        self.view = self.studentMap
                        
                        // pin the student locations to the map
                        self.addLocationsToMap()
                    } )
                }
            }
        }
    }
    
    // the function receives the array of student locations from Parse
    // and then creates pins for each student with their relevant info
    // and adds the pin to the map
    func addLocationsToMap()
    {
        for location in studentLocations
        {
            var pin = MKPointAnnotation()
            pin.coordinate = location.coordinate
            pin.title = location.title
            pin.subtitle = location.subtitle
            
            studentMap.addAnnotation( pin )
        }
    }
    
    // NOTE:
    // code taken from Jarrod Parkes's PinSample project, posted to the forums
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let pinIdentifier = "pin"
        
        var pin = mapView.dequeueReusableAnnotationViewWithIdentifier( pinIdentifier ) as? MKPinAnnotationView
        
        if pin == nil
        {
            pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdentifier )
            pin!.canShowCallout = true
            pin!.pinColor = .Red
            pin!.rightCalloutAccessoryView = UIButton.buttonWithType( .DetailDisclosure ) as! UIButton
        }
        else
        {
            pin?.annotation = annotation
        }
        
        return pin
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        dispatch_async( dispatch_get_main_queue(),
        {
            let urlString: String! = view.annotation.subtitle
            let studentURL = NSURL( string: urlString )
            
            // can that URL be opened?
            let canOpenURL = UIApplication.sharedApplication().openURL( studentURL! )
            if canOpenURL
            {
                UIApplication.sharedApplication().openURL( studentURL! )
            }
            else
            {
                self.createAlert(
                    title: "Whoops!",
                    message: "This student's URL (\( studentURL! )) couldn't be opened."
                )
            }
        } )
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
