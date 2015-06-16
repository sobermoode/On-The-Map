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
    // student info properties
    var objectID : String?
    var uniqueKey: String?
    var firstName: String?
    var lastName : String?
    var mapString: String?
    var mediaURL : String?
    var latitude : Double?
    var longitude: Double?
    var createdAt: String?
    var updatedAt: String?
    
    // computed properties;
    // for use with map annotations
    var coordinate: CLLocationCoordinate2D?
    {
        return CLLocationCoordinate2D( latitude: self.latitude!, longitude: self.longitude! )
    }
    var title: String?
    {
        return "\( self.firstName! ) \( self.lastName! )"
    }
    var subtitle: String?
    {
        return self.mediaURL!
    }
    
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
            self.createdAt = studentInfo[ "createdAt" ] as? String
            self.updatedAt = studentInfo[ "updatedAt" ] as? String
        }
    }
}