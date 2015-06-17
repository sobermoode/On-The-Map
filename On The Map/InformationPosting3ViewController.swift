//
//  InformationPosting3ViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 6/16/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit

class InformationPosting3ViewController: UIViewController {
    
    @IBOutlet weak var yourLocationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var navBar: UINavigationBar!
    
    override func viewWillAppear( animated: Bool )
    {
        navBar = UINavigationBar(
            frame: CGRect(
                origin: CGPoint(
                    x: 0,
                    y: 0
                ),
                size: CGSize(
                    width: view.frame.width,
                    height: 64
                )
            )
        )
        navBar.translucent = false
        
        var navItem = UINavigationItem( title: "Your Location" )
        
        var cancelButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Cancel,
            target: self,
            action: "cancel"
        )
        cancelButton.tintColor = UIColor.redColor()
        
        navItem.leftBarButtonItem = cancelButton
        
        navBar.items = [ navItem ]
        
        view.addSubview( navBar )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // NOTE:
        // code taken from http://stackoverflow.com/a/27079103,
        // as per the suggestion from the code review
        // Looks for single or multiple taps.
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: "DismissKeyboard"
        )
        view.addGestureRecognizer( tap )
    }
    
    // Calls this function when the tap is recognized.
    func DismissKeyboard()
    {
        // Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing( true )
    }
    
    func cancel()
    {
        dismissViewControllerAnimated( true, completion: nil )
    }

    @IBAction func findOnTheMap( sender: UIButton )
    {
        
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
