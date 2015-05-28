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
    
    override func viewWillAppear( animated: Bool )
    {
        println( "GoogleMapView will appear..." )
        
//        dispatch_async( dispatch_get_main_queue(),
//        {
//            OnTheMapClient.sharedInstance().getStudentLocations()
//            println( "Got the student locations. They are: \( OnTheMapClient.sharedInstance().studentLocations.count )." )
//        } )
//        OnTheMapClient.sharedInstance().getStudentLocations()
//        println( "Got the student locations. They are: \( OnTheMapClient.sharedInstance().studentLocations.count )." )
//
//        studentMap = MKMapView( frame: self.view.frame )
//        studentMap.region = MKCoordinateRegion(
//            center: CLLocationCoordinate2DMake( 33.862, -118.399 ),
//            span: MKCoordinateSpan( latitudeDelta: 15.0, longitudeDelta: 15.0 )
//        )
//        
//        self.view = studentMap
//        
//        var exampleInfo: StudentLocation = OnTheMapClient.sharedInstance().studentLocations.first!
//        println( "exampleInfo: \( exampleInfo )." )
//        
//        var pin = MKPointAnnotation()
//        pin.coordinate = exampleInfo.coordinate!
//        pin.title = exampleInfo.title
//        pin.subtitle = exampleInfo.subtitle
//        
//        studentMap.addAnnotation( pin )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        println( "GoogleMapView did load." )
        OnTheMapClient.sharedInstance().getStudentLocations()
//        studentLocations = OnTheMapClient.sharedInstance().studentLocations
//        println( "There are \( studentLocations.count ) student locations." )
        
        // OnTheMapClient.sharedInstance().getStudentLocations()
        // println( "Got the student locations. They are: \( OnTheMapClient.sharedInstance().studentLocations.count )." )
        
        // self.navigationController?.setNavigationBarHidden( false, animated: false )
    }
    
    func listStudentLocations()
    {
        println( "The GoogleMapView has \( studentLocations.count ) student locations." )
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
