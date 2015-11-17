//
//  Intro.swift
//  Net
//
//  Created by Jesse Stauffer on 11/10/15.
//  Copyright © 2015 Jesse Stauffer. All rights reserved.
//

import UIKit

class Intro: UIViewController {
    
    var textField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
    }
    
    func initializeView() {
        // set background color
        self.view.backgroundColor = UIColor(red: 0.20, green: 0.28, blue: 0.37, alpha: 1.0)
        
        // set up textfield
        textField = UITextField(frame: CGRectMake(20, 80, self.view.frame.size.width-40, 60))
        textField.placeholder = "Nickname"
        textField.backgroundColor = UIColor.whiteColor()
        textField.textAlignment = NSTextAlignment.Center
        textField.font = UIFont.systemFontOfSize(20)
        self.view.addSubview(textField)
        
        // add tap recognizer to close textfield's keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        // set up description view
        let descriptionView = UITextView(frame: CGRectMake(20, 180, self.view.frame.size.width-40, 100))
        descriptionView.backgroundColor = UIColor.clearColor()
        descriptionView.text = "A demo of p2pkit's mesh networking technology. This example lets you broadcast messages to nearby users."
        descriptionView.font = UIFont.systemFontOfSize(18)
        descriptionView.textColor = UIColor.whiteColor()
        descriptionView.textAlignment = NSTextAlignment.Center
        descriptionView.userInteractionEnabled = false
        self.view.addSubview(descriptionView)
        
        // set up get started button
        let getStartedBtn = UIButton(type: UIButtonType.RoundedRect)
        getStartedBtn.frame = CGRectMake(20, self.view.frame.size.height - 170, self.view.frame.size.width-40, 60)
        getStartedBtn.tintColor = UIColor.whiteColor()
        getStartedBtn.setTitle("Get Started", forState: UIControlState.Normal)
        getStartedBtn.titleLabel?.font = UIFont.systemFontOfSize(20)
        getStartedBtn.backgroundColor = UIColor(red: 0.17, green: 0.24, blue: 0.32, alpha: 1.0)
        getStartedBtn.addTarget(self, action: "getStarted", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(getStartedBtn)
        
        // set up info view
        let infoView = UITextView(frame: CGRectMake(20, self.view.frame.size.height-80, self.view.frame.size.width-40, 80))
        infoView.backgroundColor = UIColor.clearColor()
        infoView.text = "P2PKit requires that all users have bluetooth enabled on their devices."
        infoView.font = UIFont.systemFontOfSize(14)
        infoView.textColor = UIColor.whiteColor()
        infoView.textAlignment = NSTextAlignment.Center
        infoView.userInteractionEnabled = false
        self.view.addSubview(infoView)
        
    }
    
    // fired when the user taps outside the textfield
    func dismissKeyboard() {
        self.textField.resignFirstResponder()
    }
    
    // pass username to the chat view
    func getStarted() {
        if ((self.textField.text! as NSString).length > 0 && self.textField.text != "Pick a Username!") {
            let newView = self.storyboard?.instantiateViewControllerWithIdentifier("Chat") as! Chat
            newView.myUsername = self.textField.text
            let navController = UINavigationController(rootViewController: newView)
            self.presentViewController(navController, animated: true, completion: nil)
        }
        else {
            // invalid username
            self.textField.text = "Pick a Username!"
            self.textField.textColor = UIColor.redColor()
        }
    }
    
}
