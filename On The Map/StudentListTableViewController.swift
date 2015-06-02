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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
