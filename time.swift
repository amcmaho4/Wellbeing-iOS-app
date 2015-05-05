//
//  time.swift
//  WellnessApp
//
//  Created by Anna Jo McMahon on 4/12/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

import Foundation
public extension NSDate {
	func xDays(x:Int) -> NSDate {
		return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay, value: x, toDate: self, options: nil)!
	}
	func xWeeks(x:Int) -> NSDate {
		return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitWeekOfYear, value: x, toDate: self, options: nil)!
	}
	func xHours(x:Int) -> NSDate {
		return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitHour, value: x, toDate: self, options: nil)!
	}
	func xMinutes(x:Int) -> NSDate {
		return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMinute, value: x, toDate: self, options: nil)!
	}
	func xHoursMinutes(x:Int, y:Int) -> NSDate {
		var newDate: NSDate = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitHour, value: x, toDate: self, options: nil)!
		
		return NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitMinute, value: y, toDate: newDate, options: nil)!
		
	}
	
	var hoursFromToday: Int{
		return (NSCalendar.currentCalendar().components(.CalendarUnitHour, fromDate: self, toDate: NSDate(), options: nil).hour)%24
		
	}
	var weeksFromToday: Int{
		return NSCalendar.currentCalendar().components(.CalendarUnitWeekOfYear, fromDate: self, toDate: NSDate(), options: nil).weekOfYear
	}
	var relativeDateString: String {
		if weeksFromToday > 0 { return weeksFromToday > 1 ? "\(weeksFromToday) weeks and \(hoursFromToday) hours" : "\(weeksFromToday) week and \(hoursFromToday) hours"   }
		if hoursFromToday > 0 { return hoursFromToday > 1 ? "\(hoursFromToday) hours" : "\(hoursFromToday) hour"   }
		return ""
	}
	
}