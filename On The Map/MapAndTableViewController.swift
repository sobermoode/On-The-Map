//
//  MapAndTableViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 5/19/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit

class MapAndTableViewController: UITabBarController {
    
    override func viewWillAppear( animated: Bool )
    {
        // create the navigation bar
        createNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func createNavigationBar()
    {
        // create a navigation bar for the buttons
        let frameSize = self.view.frame
        var navBar = UINavigationBar( frame: CGRectMake( 0, 0, frameSize.width, 64 ) )
        
        // create a navigation item for the navigation bar
        var navItem = UINavigationItem( title: "On The Map" )
        
        // create the navigation bar buttons
        let logoutButton = UIBarButtonItem(
            title: "Logout",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "logout"
        )
        
        let pinButton = UIBarButtonItem(
            image: UIImage( named: "pin" ),
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "dropPin"
        )
        
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Refresh,
            target: self,
            action: "refreshResults"
        )
        
        // add the buttons to the navigation item
        navItem.leftBarButtonItem = logoutButton
        navItem.rightBarButtonItems = [ refreshButton, pinButton ]
        
        // add all the navigation items to the navigation bar
        navBar.items = [ navItem ]
        
        // add the complete navigation bar to the view
        self.view.addSubview( navBar )
    }
    
    // to return to the UdacityLoginViewController
    func logout()
    {
        dismissViewControllerAnimated( true, completion: nil )
    }
    
    func dropPin()
    {
        println( "Dropping a pin..." )
    }
    
    func refreshResults()
    {
        println( "Refreshing results..." )
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
