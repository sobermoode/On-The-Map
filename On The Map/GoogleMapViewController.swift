//
//  GoogleMapViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 5/24/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit

class GoogleMapViewController: UIViewController {
    
    override func viewWillAppear( animated: Bool )
    {
        OnTheMapClient.sharedInstance().getStudentLocations()
        println( "Got the student locations. They are: \( OnTheMapClient.sharedInstance().studentLocations.count )." )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // self.navigationController?.setNavigationBarHidden( false, animated: false )
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
