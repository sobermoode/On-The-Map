//
//  InformationPosting3ViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 6/16/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit

class InformationPosting3ViewController: UIViewController {
    
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
        // navBar.translucent = false
        // navBar.barTintColor = UIColor.clearColor()
        
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
    }
    
    func cancel()
    {
        dismissViewControllerAnimated( true, completion: nil )
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
