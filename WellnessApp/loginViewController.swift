//
//  loginViewController.swift
//  wellness
//
//  Created by Anna Jo McMahon on 3/2/15.
//  Copyright (c) 2015 Andrei Puni. All rights reserved.
//

import UIKit
import Parse

class loginViewController: UIViewController {
	@IBOutlet var usernameText: UITextField!
	@IBOutlet var passwordText: UITextField!
	@IBOutlet var loginButton: UIButton!
	@IBOutlet var createAccountButton: UIButton!
	@IBOutlet var backView: UIView!


    override func viewDidLoad() {
        super.viewDidLoad()
		var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
		backView.addGestureRecognizer(tap)
		
    }
	//Calls this function when the tap is recognized.
	func DismissKeyboard(){
		//Causes the view to resign the first responder status (dismisses the keyboard)
		backView.endEditing(true)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func loginButtonAction(sender: UIButton) {
		var username = condenseWhitespace(usernameText.text)
		var password = condenseWhitespace(passwordText.text)
		PFUser.logInWithUsernameInBackground(username, password:password) {
			(user: PFUser?, error: NSError?) -> Void in
			if user != nil { // if there is a user
				//make an instance of the app delegate
				var appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
				var storyboard = UIStoryboard(name: "Main", bundle: nil)
				//dismiss the current view controller, and have the app delegate instantiate the root view controller (this time it is the Navigation controller)
				self.dismissViewControllerAnimated(true, completion:{(Bool)  in
					println("login dismissed")
					})
				appdelegate.window?.rootViewController = (storyboard.instantiateInitialViewController() as! UINavigationController)
			} else {
				println("login failed")
				self.showAlert()
				
			}
		}
	}
	
	
	func showAlert(){
		var createAccountErrorAlert: UIAlertView = UIAlertView()
		createAccountErrorAlert.delegate = self
		createAccountErrorAlert.title = "Error"
		createAccountErrorAlert.message = "That is not an account"
		createAccountErrorAlert.addButtonWithTitle("Create Account")
		createAccountErrorAlert.addButtonWithTitle("Dismiss")
		createAccountErrorAlert.show()
	}
	
	func condenseWhitespace(string: String) -> String {
		let components = string.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).filter({!isEmpty($0)})
		return join(" ", components)
	}
	
	func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
		switch buttonIndex{
		case 1:
			NSLog("Retry");
			break;
		case 0:
			self.performSegueWithIdentifier("createAccountSegue", sender: self)
			break;
		default:
			NSLog("Default");
			break;
		}
	}
	

}
