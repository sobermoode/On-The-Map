//
//  StudentLocations.swift
//  On The Map
//
//  Created by Aaron Justman on 5/25/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import Foundation

struct StudentLocation
{
    var objectID : String?
    var uniqueKey: String?
    var firstName: String?
    var lastName : String?
    var mapString: String?
    var mediaURL : String?
    var latitude : Float?
    var longitude: Float?
    var createdAt: NSDate?
    var updatedAt: NSDate?
    
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
            self.latitude = studentInfo[ "latitude " ] as? Float
            self.longitude = studentInfo[ "longitude" ] as? Float
            self.createdAt = studentInfo[ "createdAt" ] as? NSDate
            self.updatedAt = studentInfo[ "updatedAt" ] as? NSDate
        }
    }
}