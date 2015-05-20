//
//  UdacityLoginViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 5/18/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit

class UdacityLoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: BorderedButton!
    @IBOutlet weak var facebookButton: BorderedButton!
    
    // NOTE:
    // alert code adapted from
    // http://stackoverflow.com/a/24022696
    // create the Facebook alert
    var alert = UIAlertController(
        title: "Sorry 😓",
        message: "I don't have a Facebook account, so I haven't implemented this functionality.",
        preferredStyle: UIAlertControllerStyle.Alert )
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
        
        // add an alert action
        alert.addAction( UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.Default,
            handler: nil )
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // NOTE:
    // Most of the configureUI() code is based on parts of the MovieManager and MyFavoriteMovies apps
    // by Jarrod Parkes
    func configureUI()
    {
        /* Configure background gradient */
        // code based on the MovieManager app
        self.view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 1.0, green: 0.596, blue: 0.035, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 1.0, green: 0.431, blue: 0.0, alpha: 1.0).CGColor
        var backgroundGradient = CAGradientLayer()
        backgroundGradient.colors = [colorTop, colorBottom]
        backgroundGradient.locations = [0.0, 1.0]
        backgroundGradient.frame = view.frame
        self.view.layer.insertSublayer(backgroundGradient, atIndex: 0)
        
        /* Configure email textfield */
        // code based on the MyFavoriteMovies app
        let emailTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let emailTextFieldPaddingView = UIView(frame: emailTextFieldPaddingViewFrame)
        emailTextField.leftView = emailTextFieldPaddingView
        emailTextField.leftViewMode = .Always
        emailTextField.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        emailTextField.backgroundColor = UIColor(red: 1.0, green: 0.776, blue: 0.576, alpha:1.0)
        emailTextField.textColor = UIColor.whiteColor()
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        emailTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        /* Configure password textfield */
        // code based on the MyFavoriteMovies app
        let passwordTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let passwordTextFieldPaddingView = UIView(frame: passwordTextFieldPaddingViewFrame)
        passwordTextField.leftView = passwordTextFieldPaddingView
        passwordTextField.leftViewMode = .Always
        passwordTextField.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        passwordTextField.backgroundColor = UIColor(red: 1.0, green: 0.776, blue: 0.576, alpha:1.0)
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        // BorderedButton code based on the MyFavoriteMovies app
        loginButton.themeBorderedButton()
        loginButton.highlightedBackingColor = UIColor(red: 0.899, green: 0.222, blue: 0.0, alpha:1.0)
        loginButton.backingColor = UIColor(red: 0.956, green:0.333, blue:0.0, alpha: 1.0)
        loginButton.backgroundColor = UIColor(red: 0.956, green:0.333, blue:0.0, alpha: 1.0)
        
        facebookButton.themeBorderedButton()
        facebookButton.highlightedBackingColor = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
        facebookButton.backingColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        facebookButton.backgroundColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        // let lighterBlue = UIColor(red: 0.956, green:0.333, blue:0.0, alpha: 1.0)
    }
    
    // attempt to verify user credentials with Udacity;
    // segue to the map and table view if successful
    @IBAction func loginToUdacity( sender: BorderedButton )
    {
        let enteredEmail = emailTextField.text
        let enteredPassword = passwordTextField.text
        
        let loginParameters =
        [
            "udacity" :
            [
                "username" : enteredEmail,
                "password" : enteredPassword
            ]
        ]
        
        var jsonifyError: NSError?
        var loginData = NSJSONSerialization.dataWithJSONObject( loginParameters, options: nil, error: &jsonifyError )
        
        let request = NSMutableURLRequest( URL: NSURL( string: "https://www.udacity.com/api/session" )! )
        request.HTTPMethod = "POST"
        request.addValue( "application/json", forHTTPHeaderField: "Accept" )
        request.addValue( "application/json", forHTTPHeaderField: "Content-Type" )
        request.HTTPBody = loginData
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest( request )
        {
            data, response, error in
            
            if let error = error
            {
                println( "There was a problem logging into Udacity: \( error )." )
                return
            }
            else
            {
                println( "Response: \( response )." )
                
                let newData = data.subdataWithRange( NSMakeRange( 5, data.length - 5 ) )
                // println( newData )
                println(NSString(data: newData, encoding: NSUTF8StringEncoding))
            }
        }
        
        task.resume()
    }
    
    // NOTE:
    // code adapted from
    // https://mobilitytalks.wordpress.com/2012/04/19/open-a-link-in-safari-from-your-iphone-application/
    @IBAction func openInSafari( sender: UIButton )
    {
        UIApplication.sharedApplication().openURL( NSURL( string: "https://www.udacity.com/account/auth#!/signin" )! )
    }

    // show the Facebook alert
    @IBAction func facebookAlert( sender: BorderedButton )
    {
        self.presentViewController(
            alert,
            animated: true,
            completion: nil
        )
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
