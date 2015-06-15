//
//  StudentListTableViewController.swift
//  On The Map
//
//  Created by Aaron Justman on 5/24/15.
//  Copyright (c) 2015 AaronJ. All rights reserved.
//

import UIKit

class StudentListTableViewController: UITableViewController {
    
    var studentLocations = [ StudentLocation ]()
    
    let reuseIdentifer = "studentCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // put the table view under the tab bar controllers's navigation bar
        self.tableView.contentInset = UIEdgeInsets(
            top: 64.0,
            left: 0.0,
            bottom: 0.0,
            right: 0.0
        )
        
        studentLocations = OnTheMapClient.sharedInstance().studentLocations
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return studentLocations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifer, forIndexPath: indexPath) as! UITableViewCell
        
        // get the current student
        let currentStudent = studentLocations[ indexPath.row ]

        // Configure the cell...
        
        // the only cell content is the student's full name
        cell.textLabel?.text = currentStudent.title

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dispatch_async( dispatch_get_main_queue(),
        {
            // get the current student and their URL
            let currentStudent = self.studentLocations[ indexPath.row ]
            let studentURL = NSURL( string: currentStudent.subtitle )
            
            // can that URL be opened?
            let canOpenURL = UIApplication.sharedApplication().openURL( studentURL! )
            if canOpenURL
            {
                UIApplication.sharedApplication().openURL( studentURL! )
            }
            else
            {
                self.createAlert(
                    title: "Whoops!",
                    message: "This student's URL (\( studentURL! )) couldn't be opened."
                )
            }
        } )
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
