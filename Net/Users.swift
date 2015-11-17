//
//  Users.swift
//  Net
//
//  Created by Jesse Stauffer on 11/13/15.
//  Copyright © 2015 Jesse Stauffer. All rights reserved.
//

import UIKit

class Users: UITableViewController {
    
    var users : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    func initializeView() {
        self.title = "Current Users"
        self.tableView.reloadData()
        
        // create close button
        let closeBtn = UIBarButtonItem(title: "Close", style: .Plain, target: self, action: "close")
        self.navigationItem.leftBarButtonItem = closeBtn
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //: MARK - UITableViewDelegate Methods
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // display a default msg if no users are found
        if users.count == 0 {
            return 1
        }
        else {
            return users.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("UsersCell")! as UITableViewCell
        if users.count > 0 {
            // display the users name
            cell.textLabel?.text = NSString(data: users.objectAtIndex(indexPath.row).discoveryInfo, encoding: NSUTF8StringEncoding) as? String
        }
        else {
            // default message
            cell.textLabel?.text = "There are no others currently chatting."
        }
        return cell
    }
    
}