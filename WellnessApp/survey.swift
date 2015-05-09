//
//  survey.swift
//  wellness
//
//  Created by Anna Jo McMahon on 3/17/15.
//  Copyright (c) 2015 Andrei Puni. All rights reserved.
//

import Foundation
import UIKit

//import SQLite
import Parse
class survey {
	//data pulled from the parse data store:
	var questions : [question] = [question]()
	var surveyName : String!
	var surveyTime : NSDate!
	var sendTime: String
	var surveyActiveDuration: Double = 0
	var versionIdentifier:Double = 0.0
	var active: Bool
	var sendDays: [Int]
	var surveyDescriptor : String

	var userEmail: String
	var updated : Bool!
	//displayed on the home screen
	var surveyTimeNiceFormat : String
	var surveyExpirationTimeNiceFormat : String
	var taken = false
	var dailyIterationNumber: Int?
	var expirationTime: NSDate!
	var possibleSendDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
	var notifications = [UILocalNotification]()
	var completed: Bool
	var surveyCompletedTime: NSDate?
	

	init(){
		self.questions = [question]()
		self.surveyName = ""
		self.surveyTime = NSDate()
		self.updated = false
		self.sendTime = ""
		self.surveyDescriptor = ""
		self.surveyTimeNiceFormat = ""
		self.surveyExpirationTimeNiceFormat = ""
		self.userEmail = ""
		sendDays = [0,1,2,3,4,5,6]
		active = true
		completed = false
	}
	
	
func getProgress()->CGFloat{
		var answered: CGFloat = 0
		for question in self.questions{
			if(question.answerIndex != -1){
				answered++
			}
		}
		let progress: CGFloat = answered/CGFloat(self.questions.count)
		return progress
	}
func getAnswered()->CGFloat{
		var answered: CGFloat = 0
		for question in self.questions{
			if(question.answerIndex != -1){
				answered++
			}
		}
		return answered
}
	
func queryParseForSurveyData(){
//
	


		var tempQuest : question = question()
		var query = PFQuery(className:surveyName)
		query.fromLocalDatastore()
		query.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]?, error: NSError?) -> Void in
			if error == nil {
				if let objects = objects as? [PFObject] {
					for (var q = 0; q<objects.count ; q++){
						tempQuest = question()
						tempQuest.answerOptions = objects[q]["options"] as! [String]
						tempQuest.answerType = objects[q]["questionType"] as! String
						tempQuest.questionString = objects[q]["question"] as! String
						tempQuest.questionID = objects[q]["questionId"] as! Int
						tempQuest.endPointStrings = objects[q]["endPoints"] as! [String]
						self.questions.append(tempQuest)
					}
				}
			} else {
				println("Error: \(error) \(error!.userInfo!)")
			}
		}
	
	
	
	
	
	}
	func pastPresentOrFuture()->String{
		if(self.active == true){
			if contains(self.sendDays, getDayOfWeek()) {
				if( expirationTime.timeIntervalSinceNow > 0 && surveyTime.timeIntervalSinceNow < 0){
					return "present"
				}
				else if(expirationTime.timeIntervalSinceNow < 0 ){
					return "past"
				}
				else {
					return "future"
				}
			}
		}
		return "none"
	}
	
func getDayOfWeek()->Int {
		let todayDate = NSDate()
		let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
		let myComponents = myCalendar.components(.CalendarUnitWeekday, fromDate: todayDate)
		let weekDay = myComponents.weekday - 1
		return weekDay
}
	
func makeNSdate(){
	//instantiate a calendar
	let calendar = NSCalendar.currentCalendar()
	
	// define unit flag groupings used to set specific date components
	var fullDateUnitFlags = NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitDay
	var justTimeUnitFlags = NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute
	
	//get the current time date components from the string retrieved from parse
	var dateFormatter = NSDateFormatter()
	dateFormatter.dateFormat = "HH:mm"
	var surveyDateTime = dateFormatter.dateFromString(sendTime)
	
	var surveyDateTimeComponents =  calendar.components(justTimeUnitFlags, fromDate: surveyDateTime!)
	
	let currentDate = NSDate()
	let currentDateComponents = calendar.components(fullDateUnitFlags, fromDate: currentDate)
	
	// set survey date time = time of survey retrieved form parse
	//set all other date components to that of the current date
	let surveyDateComponents = NSDateComponents()
	surveyDateComponents.minute = surveyDateTimeComponents.minute
	surveyDateComponents.hour = surveyDateTimeComponents.hour
	surveyDateComponents.day = currentDateComponents.day
	surveyDateComponents.year = currentDateComponents.year
	surveyDateComponents.month = currentDateComponents.month
	let surveyDate = calendar.dateFromComponents(surveyDateComponents)
	surveyTime = surveyDate!
	self.makeFormatedStringDate()
	self.makeExpirationTime()
	makeNotifications()

	}
func makeFormatedStringDate(){
		let dayTimePeriodFormatter = NSDateFormatter()
		dayTimePeriodFormatter.dateFormat = "E, h:mm a"
		surveyTimeNiceFormat = dayTimePeriodFormatter.stringFromDate(surveyTime)
	}
	
func makeExpirationTime(){
	self.expirationTime = surveyTime.dateByAddingTimeInterval(surveyActiveDuration*60)
	makeFormatedStringDateExpiration()
}
	
func makeFormatedStringDateExpiration(){
		let dayTimePeriodFormatter = NSDateFormatter()
		dayTimePeriodFormatter.dateFormat = "E, h:mm a"
		surveyExpirationTimeNiceFormat = dayTimePeriodFormatter.stringFromDate(expirationTime)
}
func makeNotifications() {
	var timeIntervalToAdd = (surveyActiveDuration/4)*60 //in minutes
	var notificationTimes = [surveyTime,
		surveyTime.dateByAddingTimeInterval(timeIntervalToAdd),
		surveyTime.dateByAddingTimeInterval(timeIntervalToAdd*2),
		surveyTime.dateByAddingTimeInterval(timeIntervalToAdd*3)]
	
		for sendTime in notificationTimes {
			var reminder = UILocalNotification()
			reminder.fireDate = sendTime
			reminder.timeZone = NSTimeZone.localTimeZone()
			reminder.alertBody = " Time to take your "+surveyDescriptor + " survey"
			reminder.repeatInterval = NSCalendarUnit.CalendarUnitDay
			notifications.append(reminder)
			UIApplication.sharedApplication().scheduleLocalNotification(reminder)
		}
}
func cancelNotifications(){
	for notification in notifications{
		UIApplication.sharedApplication().cancelLocalNotification(notification)
	}
}
	
	
}