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
    
    // the current 100 student locations on the map
    var studentLocations = [ StudentLocation ]()
    
    // Udacity request URLs,
    // Udacity login response variables
    struct UdacityInfo
    {
        static let udacityLogin = "https://www.udacity.com/api/session"
        static let udacityUserData = "https://www.udacity.com/api/users/<user_id>"
        static var sessionID: String?
        static var userFirstName: String?
        static var userLastName: String?
        static var personalKey: String?
    }
    
    struct ParseInfo
    {
        static let appID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let apiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let apiURL = "https://api.parse.com/1/classes/StudentLocation"
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
        var jsonificationError: NSError?
        var loginData = NSJSONSerialization.dataWithJSONObject(
            loginParameters,
            options: nil,
            error: &jsonificationError
        )!
        
        // if there was an error with the JSON-ification, use the completion handler to fail
        if jsonificationError != nil
        {
            return completionHandler(
                success: false,
                loginError: "There was an error creating the login parameter data.",
                timeoutError: nil
            )
        }
        
        // create the request
        let request = createPOSTRequestForUdacity(
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
    func createPOSTRequestForUdacity( #url: String, parameters: NSData ) -> NSURLRequest
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
                    timeoutError: error.localizedDescription
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
                    let account = dataJSON[ "account" ] as! NSDictionary
                    let session = dataJSON[ "session" ] as! NSDictionary
                    
                    // save the personal key
                    OnTheMapClient.UdacityInfo.personalKey = account[ "key" ] as? String
                    
                    // save the session ID
                    OnTheMapClient.UdacityInfo.sessionID = session[ "id" ] as? String
                    
                    // get current user data
                    dispatch_async( dispatch_get_main_queue(),
                    {
                        self.getUserData()
                        {
                            success, username in
                            
                            if success
                            {
                                let returnedName = username as [ String : String ]!
                                OnTheMapClient.UdacityInfo.userFirstName = returnedName[ "first" ]! as String
                                OnTheMapClient.UdacityInfo.userLastName = returnedName[ "last" ]! as String
                                
                                return completionHandler(
                                    success: true,
                                    loginError: nil,
                                    timeoutError: nil
                                )
                            }
                            else
                            {
                                return completionHandler(
                                    success: false,
                                    loginError: "There was an error getting your user data from Udacity.",
                                    timeoutError: nil
                                )
                            }
                        }
                    } )
                }
            }
        }
        
        loginTask.resume()
        
        return loginTask
    }
    
    // after successfully logging into Udacity, get the user's data
    func getUserData( completionHandler: ( success: Bool, username: [ String : String ]? ) -> Void )
    {
        // create the request URL by replacing the placeholder with the user's userID
        var userDataURL = OnTheMapClient.UdacityInfo.udacityUserData
        let requestURL = userDataURL.stringByReplacingOccurrencesOfString( "<user_id>", withString: OnTheMapClient.UdacityInfo.personalKey!, options: nil, range: nil )
        
        let userDataRequest = NSMutableURLRequest( URL: NSURL( string: requestURL )! )
        
        let userDataTask = session.dataTaskWithRequest( userDataRequest )
        {
            data, response, error in
            
            if let error = error
            {
                // could not get the user data from Udacity
                return completionHandler(
                    success: false,
                    username: nil
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
                
                let user = dataJSON[ "user" ] as! NSDictionary
                var username = [ String : String ]()
                username[ "first" ] = user[ "first_name" ] as? String
                username[ "last" ] = user[ "last_name" ] as? String
                
                return completionHandler(
                    success: true,
                    username: username
                )
            }
        }
        
        userDataTask.resume()
    }
    
    // make Parse request for the locations of where Udacity students are studying
    func getStudentLocations( completionHandler: ( success: Bool, studentLocations: [ StudentLocation ]?, error: String? ) -> Void )
    {
        let parseRequest = createParseRequestForType( "GET", studentInfo: nil )
        
        let studentLocationsTask = session.dataTaskWithRequest( parseRequest )
        {
            data, response, error in
            
            if let error = error
            {
                // use the completion handler to send the error back to the
                // MapAndTableViewController and the GoogleMapViewController
                return completionHandler(
                    success: false,
                    studentLocations: nil,
                    error: "There was a problem getting the student locations."
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
                
                // send the locations back to the GoogleMapViewController
                return completionHandler(
                    success: true,
                    studentLocations: self.studentLocations,
                    error: nil
                )
            }
        }
        
        studentLocationsTask.resume()
    }
    
    func createParseRequestForType( methodType: String, studentInfo: [ String : AnyObject ]? ) -> NSURLRequest
    {
        // this is all that is needed for a GET request
        let request = NSMutableURLRequest( URL: NSURL( string: OnTheMapClient.ParseInfo.apiURL )! )
        request.addValue( OnTheMapClient.ParseInfo.appID, forHTTPHeaderField: "X-Parse-Application-Id" )
        request.addValue( OnTheMapClient.ParseInfo.apiKey, forHTTPHeaderField: "X-Parse-REST-API-Key" )
        
        // a POST request requires extra values
        if methodType == "POST"
        {
            request.HTTPMethod = "POST"
            request.addValue( "application/json", forHTTPHeaderField: "Content-Type" )
            
            var dataficationError: NSError?
            let requestData = NSJSONSerialization.dataWithJSONObject(
                studentInfo!,
                options: nil,
                error: &dataficationError
            )
            request.HTTPBody = requestData
        }
        
        return request
    }
    
    func postNewStudentInfo( studentInfo: [ String : AnyObject ], completionHandler: ( success: Bool, postingError: NSError? ) -> Void )
    {
        // the POST request to add a student location to the map requires the data object,
        // with the info passed from the InformationPostingViewController
        let postRequest = createParseRequestForType( "POST", studentInfo: studentInfo )
        
        let postTask = session.dataTaskWithRequest( postRequest )
        {
            data, response, error in
            
            if let error = error
            {
                return completionHandler(
                    success: false,
                    postingError: error
                )
            }
            else
            {                
                return completionHandler(
                    success: true,
                    postingError: nil
                )
            }
        }
        
        postTask.resume()
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
