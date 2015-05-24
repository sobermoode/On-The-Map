//
//  MapAndTableViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 5/19/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit

class MapAndTableViewController: UITabBarController {
    
    // var sender: UIViewController?
    
    override func viewWillAppear( animated: Bool )
    {
        // create a navigation bar for the buttons
        let frameSize = self.view.frame
        var navBar = UINavigationBar( frame: CGRectMake( 0, 21, frameSize.width, 44 ) )
        navBar.barTintColor = UIColor.lightGrayColor()
        
        // create a navigation item for the navigation bar
        var navItem = UINavigationItem( title: "On The Map" )
        
        // create the logout button
        let logoutButton = UIBarButtonItem(
            title: "Logout",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "logout"
        )
        
        // add the logout button to the navigation item
        navItem.leftBarButtonItem = logoutButton
        
        // add all the navigation items to the navigation bar
        navBar.items = [ navItem ]
        
        // add the complete navigation bar to the view
        self.view.addSubview( navBar )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // to return to the UdacityLoginViewController
    func logout()
    {
        dismissViewControllerAnimated( true, completion: nil )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
