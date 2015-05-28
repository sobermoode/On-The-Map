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
        
        OnTheMapClient.sharedInstance().getStudentLocations
        {
            success, studentLocations, error in
            
            if let error = error
            {
                println( error )
            }
            else if success
            {
                if let studentLocations = studentLocations
                {
                    self.studentLocations = studentLocations
                    
                    dispatch_async( dispatch_get_main_queue(),
                    {
                        self.studentMap = MKMapView( frame: self.view.frame )
                        self.studentMap.region = MKCoordinateRegion(
                            center: CLLocationCoordinate2DMake( 33.862, -118.399 ),
                            span: MKCoordinateSpan( latitudeDelta: 15.0, longitudeDelta: 15.0 )
                        )
                        
                        self.view = self.studentMap
                        
                        var exampleInfo: StudentLocation = self.studentLocations.first!
                        
                        var pin = MKPointAnnotation()
                        pin.coordinate = exampleInfo.coordinate!
                        pin.title = exampleInfo.title!
                        pin.subtitle = exampleInfo.subtitle!
                        
                        self.studentMap.addAnnotation( pin )
                    } )
                }
            }
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
