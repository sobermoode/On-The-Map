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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
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
        
        /* configure email textfield */
        // code based on the MyFavoriteMovies app
        let emailTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let emailTextFieldPaddingView = UIView(frame: emailTextFieldPaddingViewFrame)
        emailTextField.leftView = emailTextFieldPaddingView
        emailTextField.leftViewMode = .Always
        emailTextField.font = UIFont(name: "AvenirNext-Medium", size: 14.0)
        emailTextField.backgroundColor = UIColor(red: 1.0, green: 0.776, blue: 0.576, alpha:1.0)
        emailTextField.textColor = UIColor.whiteColor()
        emailTextField.attributedPlaceholder = NSAttributedString(string: emailTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        emailTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        /* configure password textfield */
        // code based on the MyFavoriteMovies app
        let passwordTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let passwordTextFieldPaddingView = UIView(frame: passwordTextFieldPaddingViewFrame)
        passwordTextField.leftView = passwordTextFieldPaddingView
        passwordTextField.leftViewMode = .Always
        passwordTextField.font = UIFont(name: "AvenirNext-Medium", size: 14.0)
        passwordTextField.backgroundColor = UIColor(red: 1.0, green: 0.776, blue: 0.576, alpha:1.0)
        passwordTextField.textColor = UIColor.whiteColor()
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        // configure login button and facebook button
        // BorderedButton code based on the MyFavoriteMovies app
        loginButton.themeBorderedButton()
        loginButton.highlightedBackingColor = UIColor(red: 0.899, green: 0.222, blue: 0.0, alpha:1.0)
        loginButton.backingColor = UIColor(red: 0.956, green:0.333, blue:0.0, alpha: 1.0)
        loginButton.backgroundColor = UIColor(red: 0.956, green:0.333, blue:0.0, alpha: 1.0)
        
        facebookButton.themeBorderedButton()
        facebookButton.highlightedBackingColor = UIColor(red: 0.0, green: 0.298, blue: 0.686, alpha:1.0)
        facebookButton.backingColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        facebookButton.backgroundColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
    }
    
    // attempt to verify user credentials with Udacity;
    // segue to the map and table view if successful
    @IBAction func loginToUdacity( sender: BorderedButton )
    {
        let enteredEmail = emailTextField.text
        let enteredPassword = passwordTextField.text
        
        OnTheMapClient.sharedInstance().loginToUdacity( username: enteredEmail, password: enteredPassword )
        {
            success, loginError, timeoutError in
            
            if success
            {
                // segue to MapAndTable view
                dispatch_async( dispatch_get_main_queue(),
                {
                    // instantiate the controllers
                    let mapAndTableView = self.storyboard?.instantiateViewControllerWithIdentifier( "MapAndTable" ) as! MapAndTableViewController
                    let googleMapView = self.storyboard?.instantiateViewControllerWithIdentifier( "GoogleMap" ) as! GoogleMapViewController
                    let studentListView = self.storyboard?.instantiateViewControllerWithIdentifier( "StudentList" ) as! StudentListTableViewController
                    
                    // set the tab bar items
                    googleMapView.tabBarItem.image = UIImage( named: "map" )
                    googleMapView.tabBarItem.title = "Map"
                    googleMapView.navigationController?.navigationBarHidden = false
                    studentListView.tabBarItem.image = UIImage( named: "list" )
                    studentListView.tabBarItem.title = "List"
                    
                    // add the controller items to the tab bar controller
                    mapAndTableView.viewControllers = [ googleMapView, studentListView ]
                    
                    // segue
                    self.showViewController( mapAndTableView, sender: self )
                } )
            }
            else if let error = loginError
            {
                // handle Udacity login error code
                dispatch_async( dispatch_get_main_queue(),
                {
                    self.createAlert( title: "Whoops!", message: error )
                } )
            }
            else if let error = timeoutError
            {
                // timeout error
                dispatch_async( dispatch_get_main_queue(),
                {
                    self.createAlert( title: "Whoops!", message: error )
                } )
            }
        }
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
        createAlert(
            title: "Sorry 😓",
            message: "I don't have a Facebook account, so I haven't implemented this functionality."
        )
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
}
