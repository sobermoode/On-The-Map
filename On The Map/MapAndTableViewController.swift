//
//  MapAndTableViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 5/19/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit

class MapAndTableViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden( false, animated: false )
        
        println( "The MapAndTableViewController did load!!!" )

        // Do any additional setup after loading the view.
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
