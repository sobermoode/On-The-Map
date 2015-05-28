//
//  StudentLocations.swift
//  On The Map
//
//  Created by Aaron Justman on 5/25/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import Foundation
import MapKit

struct StudentLocation
{
    var objectID : String?
    var uniqueKey: String?
    var firstName: String?
    var lastName : String?
    var mapString: String?
    var mediaURL : String?
    var latitude : Double?
    var longitude: Double?
    var createdAt: NSDate?
    var updatedAt: NSDate?
    
    var coordinate: CLLocationCoordinate2D?
    var title: String?
    var subtitle: String?
    
    init( studentInfo: [ String : AnyObject ]? )
    {
        if let studentInfo = studentInfo
        {
            self.objectID = studentInfo[ "objectID" ] as? String
            self.uniqueKey = studentInfo[ "uniqueKey" ] as? String
            self.firstName = studentInfo[ "firstName" ] as? String
            self.lastName = studentInfo[ "lastName" ] as? String
            self.mapString = studentInfo[ "mapString" ] as? String
            self.mediaURL = studentInfo[ "mediaURL" ] as? String
            self.latitude = studentInfo[ "latitude" ] as? Double
            self.longitude = studentInfo[ "longitude" ] as? Double
            self.createdAt = studentInfo[ "createdAt" ] as? NSDate
            self.updatedAt = studentInfo[ "updatedAt" ] as? NSDate
            
            self.coordinate = CLLocationCoordinate2D( latitude: self.latitude!, longitude: self.longitude! )
            self.title = "\( self.firstName ) \( self.lastName )"
            self.subtitle = self.mediaURL
        }
    }
}