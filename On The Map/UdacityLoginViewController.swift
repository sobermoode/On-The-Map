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
        
        /* Configure email textfield */
        // code based on the MyFavoriteMovies app
        let emailTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let emailTextFieldPaddingView = UIView(frame: emailTextFieldPaddingViewFrame)
        emailTextField.leftView = emailTextFieldPaddingView
        emailTextField.leftViewMode = .Always
        emailTextField.font = UIFont(name: "AvenirNext-Medium", size: 17.0)
        emailTextField.backgroundColor = UIColor(red: 1.0, green: 0.776, blue: 0.576, alpha:1.0)
        emailTextField.textColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
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
        passwordTextField.textColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
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
    
    @IBAction func openInSafari( sender: UIButton )
    {
        UIApplication.sharedApplication().openURL( NSURL( string: "https://www.udacity.com/account/auth#!/signin" )! )
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
