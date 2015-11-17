//
//  ViewController.swift
//  Net
//
//  Created by Jesse Stauffer on 11/10/15.
//  Copyright © 2015 Jesse Stauffer. All rights reserved.
//

import UIKit

class Chat: UITableViewController, PPKControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var peerIDs : NSMutableArray = []
    var connectedPeers = 0
    var myUsername : NSString!
    let APIKey = "YOUR API KEY HERE"
    var messages : NSMutableArray = []
    var textField = UITextField()
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updateTitle()
        PPKController.enableWithConfiguration(APIKey, observer: self)
        
        // add users button
        let userBtn = UIBarButtonItem(title: "Users", style: .Plain, target: self, action: "viewUsers")
        self.navigationItem.leftBarButtonItem = userBtn
        
        // add write button
        let writeBtn = UIButton(type: UIButtonType.RoundedRect)
        writeBtn.frame = CGRectMake(20, self.view.frame.size.height-80, (self.view.frame.size.width/2)-30, 60)
        writeBtn.setTitle("Share Text", forState: UIControlState.Normal)
        writeBtn.tintColor = UIColor.whiteColor()
        writeBtn.titleLabel?.font = UIFont.systemFontOfSize(20)
        writeBtn.backgroundColor = UIColor(red: 0.12, green: 0.81, blue: 0.43, alpha: 1.0)
        writeBtn.addTarget(self, action: "write", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.view.addSubview(writeBtn)
        
        // add photo button
        let photoBtn = UIButton(type: UIButtonType.RoundedRect)
        photoBtn.frame = CGRectMake((self.view.frame.size.width/2)+10, self.view.frame.size.height-80, (self.view.frame.size.width/2)-30, 60)
        photoBtn.setTitle("Share Pic", forState: UIControlState.Normal)
        photoBtn.tintColor = UIColor.whiteColor()
        photoBtn.titleLabel?.font = UIFont.systemFontOfSize(20)
        photoBtn.backgroundColor = UIColor(red: 0.12, green: 0.81, blue: 0.43, alpha: 1.0)
        photoBtn.addTarget(self, action: "photo", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationController?.view.addSubview(photoBtn)
        
        // setup photo picker
        picker.delegate = self
    }
    
    func write() {
        // create alert box with textfield
        let alert = UIAlertController(title: "Share Text", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.textFields![0].autocapitalizationType = UITextAutocapitalizationType.Sentences
        alert.textFields![0].autocorrectionType = UITextAutocorrectionType.Default
        alert.addAction(UIAlertAction(title: "Share", style: UIAlertActionStyle.Default, handler: {
            (UIAlertAction) in
            // share message
            self.messages.insertObject(["from":"Me", "message":self.textField.text as String!, "hasPhoto":false], atIndex: 0)
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            
            // log events to console
            print("clicked send")
            print(self.textField.text)
            for peer in self.peerIDs {
                let textData = (self.textField.text?.dataUsingEncoding(NSUTF8StringEncoding))! as NSData
                let msgDictionary = ["hasPhoto":false, "data":textData]
                let dictionaryAsData = NSKeyedArchiver.archivedDataWithRootObject(msgDictionary)
                PPKController.sendMessage(dictionaryAsData, withHeader: "Hi", to: peer.peerID as String)
            }
        }))
        
        self.presentViewController(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func photo() {
        // choose from gallery
        self.picker.allowsEditing = false
        self.picker.sourceType = .PhotoLibrary
        self.presentViewController(self.picker, animated: true, completion: nil)
    }
    
    func configurationTextField(textField: UITextField!)
    {
        // pass value to textField object
        self.textField = textField!
    }
    
    func viewUsers() {
        // go to the users view
        let newView = self.storyboard?.instantiateViewControllerWithIdentifier("Users") as! Users
        newView.users = peerIDs
        let navContr = UINavigationController(rootViewController: newView)
        self.presentViewController(navContr, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateTitle() {
        // show number of connected peers
        self.title = NSString(format: "Chatting with %d", connectedPeers) as String
    }

    // PPKControllerDelegate Methods
    
    func PPKControllerInitialized() {
        // start the p2p discovery and messaging
        print("Initialized Successfully")
        let myDiscoveryInfo = myUsername.dataUsingEncoding(NSUTF8StringEncoding)
        PPKController.startP2PDiscoveryWithDiscoveryInfo(myDiscoveryInfo)
        PPKController.startOnlineMessaging()
    }
    
    func p2pPeerDiscovered(peer: PPKPeer!) {
        // add a connected peer and update the title
        connectedPeers++
        updateTitle()
        peerIDs.addObject(peer)
    }
    
    func p2pPeerLost(peer: PPKPeer!) {
        // remove a connected peer and update the title
        connectedPeers--
        updateTitle()
        peerIDs.removeObject(peer)
    }
    
    func messageReceived(messageBody: NSData!, header messageHeader: String!, from peerID: String!) {
        // get peer name
        var locatedPeer : PPKPeer!
        for peer in peerIDs {
            if peer.peerID == peerID {
                locatedPeer = peer as! PPKPeer
            }
        }
        
        // unarchive the data dictionary
        let dataDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(messageBody)
        let hasPhoto = dataDictionary?.objectForKey("hasPhoto") as! Bool
        if hasPhoto {
            // add msg to table containing photo
            self.messages.insertObject(["from": NSString(data: locatedPeer.discoveryInfo, encoding: NSUTF8StringEncoding) as! String, "message":"", "hasPhoto":true, "photo":dataDictionary?.objectForKey("data") as! NSData], atIndex: 0)
        }
        else {
            // add msg to table containing text
            self.messages.insertObject(["from": NSString(data: locatedPeer.discoveryInfo, encoding: NSUTF8StringEncoding) as! String, "message":NSString(data: (dataDictionary?.objectForKey("data"))! as! NSData, encoding: NSUTF8StringEncoding)!, "hasPhoto":false, "photo":""], atIndex: 0)
        }
        
        // reload the table
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    // MARK: UITableViewDelegate Methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // show default msg if there are no messages
        if messages.count > 0 {
            return messages.count
        }
        else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if messages.count > 0 {
            let hasPhoto = messages.objectAtIndex(indexPath.row).objectForKey("hasPhoto") as! Bool
            if hasPhoto {
                return 183
            }
            else {
                return 60
            }
        }
        else {
            return 60
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if messages.count > 0 {
            // display the message
            let message = messages.objectAtIndex(indexPath.row).objectForKey("message") as! String
            let peer = messages.objectAtIndex(indexPath.row).objectForKey("from") as! String
            let hasPhoto = messages.objectAtIndex(indexPath.row).objectForKey("hasPhoto") as! Bool
            if hasPhoto {
                let photoData = messages.objectAtIndex(indexPath.row).objectForKey("photo") as! NSData
                let cell = self.tableView.dequeueReusableCellWithIdentifier("PhotoCell")! as! PhotoCell
                cell.from?.text = peer
                cell.photoView.image = UIImage(data: photoData)
                if peer == "Me" {
                    cell.from.textColor = UIColor(red: 0.12, green: 0.81, blue: 0.43, alpha: 1.0)
                }
                else {
                    cell.from.textColor = UIColor.blackColor()
                }
                return cell
            }
            else {
                let cell = self.tableView.dequeueReusableCellWithIdentifier("MessageCell")! as UITableViewCell
                cell.textLabel?.text = message
                cell.detailTextLabel?.text = peer
                cell.textLabel?.font = UIFont.systemFontOfSize(18)
                if peer == "Me" {
                    cell.detailTextLabel?.textColor = UIColor(red: 0.12, green: 0.81, blue: 0.43, alpha: 1.0)
                }
                else {
                    cell.detailTextLabel?.textColor = UIColor.blackColor()
                }
                return cell
            }
        }
        else {
            // display the default message
            let cell = self.tableView.dequeueReusableCellWithIdentifier("MessageCell")! as UITableViewCell
            cell.textLabel?.text = "No Messages Yet"
            cell.textLabel?.font = UIFont.systemFontOfSize(16)
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.detailTextLabel?.text = "Go grab some friends"
            return cell
        }
    }

    //: MARK - UIImagePickerController Delegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage]
        let imageData = UIImageJPEGRepresentation(chosenImage as! UIImage, 0.1)! as NSData
        self.dismissViewControllerAnimated(true, completion: nil)
        // send the photo
        for peer in self.peerIDs {
            self.messages.insertObject(["from":"Me", "message":"", "hasPhoto":true, "photo":imageData], atIndex: 0)
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            
            // construct the data dictionary with the image data
            let msgDictionary = ["hasPhoto":true, "data":imageData]
            
            // archive the data dictionary and send
            let dictionaryAsData = NSKeyedArchiver.archivedDataWithRootObject(msgDictionary)
            PPKController.sendMessage(dictionaryAsData, withHeader: "Hi", to: peer.peerID as String)
            print("sent photo");
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // close the image picker view
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

