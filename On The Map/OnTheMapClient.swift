//
//  OnTheMapClient.swift
//  On The Map
//
//  Created by Aaron Justman on 5/22/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit

class OnTheMapClient: NSObject
{
    var session: NSURLSession
    
    // required for logging into Udacity
    var sessionID: String?
    
    // the current 100 student locations on the map
    var studentLocations = [ StudentLocation ]()
    
    struct UdacityInfo
    {
        static let udacityLogin = "https://www.udacity.com/api/session"
        static let personalKey = 968766250
    }
    
    struct ParseInfo
    {
        static let appID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let GETURL = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    // NOTE:
    // modeled after the MovieManager singleton client class by Jarrod Parkes
    override init()
    {
        session = NSURLSession.sharedSession()
        
        super.init()
    }
    
    func loginToUdacity( #username: String, password: String, completionHandler: ( success: Bool, loginError: String?, timeoutError: String? ) -> Void )
    {
        // create login parameters dictionary
        let loginParameters =
        [
            "udacity" :
            [
                "username" : username,
                "password" : password
            ]
        ]
        
        // turn the login parameters into a data object to attach to the request
        var jsonifyError: NSError?
        var loginData = NSJSONSerialization.dataWithJSONObject( loginParameters, options: nil, error: &jsonifyError )!
        
        // if there was an error with the JSON-ification, use the completion handler to fail
        if jsonifyError != nil
        {
            return completionHandler(
                success: false,
                loginError: "There was an error creating the login parameter data.",
                timeoutError: nil
            )
        }
        
        // create the request
        let request = createRequestForPOST(
            url: OnTheMapClient.UdacityInfo.udacityLogin,
            parameters: loginData
        )
        
        // create the task and handle the result
        let task = createUdacityLoginTaskWithRequest( request )
        {
            success, loginError, timeoutError in
            
            if success
            {
                // handle successful login with completion handler
                return completionHandler( success: true, loginError: nil, timeoutError: nil )
            }
            else if let error = loginError
            {
                // handle Udacity error code with completion handler
                return completionHandler( success: false, loginError: error, timeoutError: nil )
            }
            else if let error = timeoutError
            {
                // handle timeout error with completion handler
                return completionHandler( success: false, loginError: nil, timeoutError: error )
            }
        }
    }
    
    // create a URL request with the supplied username/password dictionary
    // as a data object for the HTTPBody
    func createRequestForPOST( #url: String, parameters: NSData ) -> NSURLRequest
    {
        let request = NSMutableURLRequest( URL: NSURL( string: url )! )
        request.HTTPMethod = "POST"
        request.addValue( "application/json", forHTTPHeaderField: "Accept" )
        request.addValue( "application/json", forHTTPHeaderField: "Content-Type" )
        request.HTTPBody = parameters
        
        return request
    }
    
    // the login task is created and any error codes are sent back up the completion handler chain;
    // otherwise, a successful login attempt is communicated back to the UdacityLoginViewController
    func createUdacityLoginTaskWithRequest( request: NSURLRequest, completionHandler: ( success: Bool, loginError: String?, timeoutError: String? ) -> Void ) -> NSURLSessionDataTask
    {
        let loginTask = session.dataTaskWithRequest( request )
        {
            data, response, error in
            
            /*
                possible error codes:
                400: either missing username or password
                403: both credentials are present, but the account doesn't exist
                NSURLErrorDomain Code = -1001: The request timed out. The error in the
                    completion handler will not be nil and contain this value.
            */
            if let error = error
            {
                return completionHandler(
                    success: false,
                    loginError: nil,
                    timeoutError: "The login attempt timed out."
                )
            }
            else
            {
                // parse returned data, as per the Udacity API guide
                let newData = data.subdataWithRange( NSMakeRange( 5, data.length - 5 ) )
                let dataJSON = NSJSONSerialization.JSONObjectWithData(
                    newData,
                    options: nil,
                    error: nil
                ) as! NSDictionary

                // udacity error code
                if let statusCode = dataJSON[ "status" ] as? Int
                {
                    switch statusCode
                    {
                        // missing username or password
                        case 400:
                            let parameter = dataJSON[ "parameter" ] as! NSString
                            let missingParameter = parameter.substringFromIndex( 8 )
                            
                            return completionHandler(
                                success: false,
                                loginError: "You forgot to enter a \( missingParameter ).",
                                timeoutError: nil
                            )
                        
                        // no account with the supplied username/password
                        case 403:
                            return completionHandler(
                                success: false,
                                loginError: "There is no account with that username and password.",
                                timeoutError: nil
                            )

                        // something unexpected happened
                        default:
                            return completionHandler(
                                success: false,
                                loginError: "There was a problem logging into Udacity.",
                                timeoutError: nil
                            )
                    }
                }
                // successful login
                else
                {
                    let session = dataJSON[ "session" ] as! NSDictionary
                    let id = session[ "id" ] as! String
                    
                    // save the session ID
                    self.sessionID = id
                    
                    return completionHandler(
                        success: true,
                        loginError: nil,
                        timeoutError: nil
                    )
                }
            }
        }
        
        loginTask.resume()
        
        return loginTask
    }
    
    func getStudentLocations( completionHandler: ( success: Bool, studentLocations: [ StudentLocation ]?, error: String? ) -> Void )
    {
        let parseRequest = createParseRequest()
        
        let studentLocationsTask = session.dataTaskWithRequest( parseRequest )
        {
            data, response, error in
            
            if let error = error
            {
                // handle error
                // TODO: use alert for Parse error
                return completionHandler(
                    success: false,
                    studentLocations: nil,
                    error: "There was a problem with the Parse request."
                )
            }
            else
            {
                // parse data
                var jsonificationError: NSError?
                let results = NSJSONSerialization.JSONObjectWithData(
                    data,
                    options: nil,
                    error: &jsonificationError
                ) as! NSDictionary
                
                let udacityStudents = results[ "results" ] as! NSArray
                
                // empty the current array of student locations
                self.studentLocations.removeAll( keepCapacity: false )
                
                // populate array of student locations with most current data
                for currentStudent in udacityStudents
                {
                    var newStudentInfo = StudentLocation( studentInfo: currentStudent as? [String : AnyObject] )
                    
                    self.studentLocations.append( newStudentInfo )
                }
                
                return completionHandler(
                    success: true,
                    studentLocations: self.studentLocations,
                    error: nil
                )
            }
        }
        
        studentLocationsTask.resume()
    }
    
    func createParseRequest() -> NSURLRequest
    {
        let request = NSMutableURLRequest( URL: NSURL( string: OnTheMapClient.ParseInfo.GETURL )! )
        request.addValue( OnTheMapClient.ParseInfo.appID, forHTTPHeaderField: "X-Parse-Application-Id" )
        request.addValue( OnTheMapClient.ParseInfo.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key" )
        
        return request
    }
    
    // NOTE:
    // modeled after the MovieManager singleton client class by Jarrod Parkes
    class func sharedInstance() -> OnTheMapClient {
        
        struct Singleton {
            static var sharedInstance = OnTheMapClient()
        }
        
        return Singleton.sharedInstance
    }
}
