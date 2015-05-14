//
//  AppDelegate.swift
//  WellnessApp
//
//  Created by Anna Jo McMahon on 4/11/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

import UIKit
import Parse
import Bolts

let mySpecialNotificationKey = "com.amcmaho4.specialNotificationKey"
let updateKey = "com.amcmaho4.updateKey"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var currentUser: PFUser?
	
	var surveyFetchEndTime = 3    //*************************CHANGE THIS IF NEEDED ********************//
	var surveyFetchStartTime = 0
	
	var window: UIWindow?
	var sendTime: NSDate = NSDate().dateByAddingTimeInterval(10)
	var allNotificationsForApp: [UILocalNotification]?
	var dataShouldBeReset: Bool?
	var Terminated:Bool? {
		get {
			return NSUserDefaults.standardUserDefaults().objectForKey("Terminated") as? Bool
		}
		set {
			NSUserDefaults.standardUserDefaults().setBool(newValue!, forKey: "Terminated")
		}
	}
	
	func reset() ->Bool{
		return dataShouldBeReset!
	}
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		dataShouldBeReset = true 
		initializeParse()
		setRootViewController();
		print("launching")
		application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
		var minfetch = UIApplicationBackgroundFetchIntervalMinimum  // set to the minimum amount
		
		//if application.respondsToSelector("registerUserNotificationSettings:") {
			let types:UIUserNotificationType = (.Alert | .Badge | .Sound)
			let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
			application.registerUserNotificationSettings(settings)
			//application.registerForRemoteNotifications()
		//}
		NSNotificationCenter.defaultCenter().postNotificationName(updateKey, object: self)

	return true
	}
	
	func application(application: UIApplication,didRegisterUserNotificationSettings
		notificationSettings: UIUserNotificationSettings){
			
			if notificationSettings.types == nil{
				/* The user did not allow us to send notifications */
				return
			}
	}
	
	func applicationDidEnterBackground(application: UIApplication) {
		
	}
	
	func applicationWillTerminate(application: UIApplication) {
		//Terminated = true
	}
	
	func applicationWillEnterForeground(application: UIApplication) {
	
	}
	
	func initializeParse(){
		Parse.enableLocalDatastore()
		Parse.setApplicationId("wFcqaTXYYCeNqKJ8wswlwtXChEzJyFyBV7N5JOZX",
			clientKey: "MomzqWhPQSVPNZ6hNjXtSSs6Lah5OMQCE8p4amsW")
	}
	
	
	func updateParseLocalDataStore(){
		var querysurveyStrings: [String] = [String]()
		var query: PFQuery = PFQuery(className:"SurveySummary")
		query.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]?, error: NSError?) -> Void in
			if error == nil {
				if let objects = objects as? [PFObject] {
					PFObject.pinAllInBackground(objects)
					for ob in objects{
						querysurveyStrings.append(ob["Survey"] as! String)
					}
				for surveyString in querysurveyStrings{
					var querysurvey = PFQuery(className: surveyString)
					querysurvey.findObjectsInBackgroundWithBlock {
						(objects: [AnyObject]?, error: NSError?) -> Void in
						if error == nil {
							if let objects = objects as? [PFObject] {
								PFObject.pinAllInBackground(objects)
							}
						}
					}
				}
				}
			}else {
				println("FAILED HERE")
				println("Error: \(error) \(error!.userInfo!)")
			}
		}
	}
	
	func application(application: UIApplication, performFetchWithCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
		
		let currentDate = NSDate()
		let calendar = NSCalendar.currentCalendar()
		let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute, fromDate:  NSDate())
		let currentHour = components.hour
		
		
		var surveyFetchEndTime = 3    //*************************CHANGE THIS IF NEEDED ********************//
		var surveyFetchStartTime = 0
		if(currentHour >= surveyFetchStartTime && currentHour <= surveyFetchEndTime){
			
					application.cancelAllLocalNotifications()	
					var querysurveyStrings: [String] = [String]()
					var query: PFQuery = PFQuery(className:"SurveySummary")
					query.findObjectsInBackground().continueWithSuccessBlock({
						(task: BFTask!) -> AnyObject! in
						return PFObject.unpinAllObjectsInBackground().continueWithSuccessBlock({
							(ignored: BFTask!) -> AnyObject! in
							let AllSurveys = task.result as? NSArray
								for ob in AllSurveys! {
									var surveyString = ob["Survey"] as! String
									query = PFQuery(className: surveyString)
									query.findObjectsInBackground().continueWithSuccessBlock({
										(task: BFTask!) -> AnyObject! in
										return PFObject.unpinAllObjectsInBackground().continueWithSuccessBlock({
											(ignored: BFTask!) -> AnyObject! in
											let allQuestions = task.result as? NSArray
											return PFObject.pinAllInBackground(allQuestions as? [AnyObject])
										})
									})
							}
							NSNotificationCenter.defaultCenter().postNotificationName(mySpecialNotificationKey, object: self)
							return PFObject.pinAllInBackground(AllSurveys as? [AnyObject])
							})
					})
			completionHandler(UIBackgroundFetchResult.NewData)
		}
		else {
			completionHandler(UIBackgroundFetchResult.NewData)
		}
	}
	
	func setRootViewController(){
				self.currentUser = PFUser.currentUser()
				var storyboard = UIStoryboard(name: "Main", bundle: nil)
		
				if let cUser = PFUser.currentUser() {
					var appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
					appdelegate.window?.rootViewController = (storyboard.instantiateInitialViewController() as! UINavigationController)
				}
				else{
					var loginviewController = storyboard.instantiateViewControllerWithIdentifier("loginView") as! UIViewController;
					self.window!.rootViewController = loginviewController
				}
	}
}

