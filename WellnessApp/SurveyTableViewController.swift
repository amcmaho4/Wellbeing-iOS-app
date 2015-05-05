//
//  SurveyTableViewController.swift
//  WellnessApp
//
//  Created by Anna Jo McMahon on 4/11/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

import UIKit
import Parse
class SurveyTableViewController: UITableViewController, UIScrollViewDelegate {
	var currentSurvey : survey = survey()
	var completed = false
	@IBOutlet var nextbutton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.contentOffset = CGPointMake(0, 0 - self.tableView.contentInset.top)
		self.navigationController?.toolbarHidden = false
		tableView!.rowHeight = UITableViewAutomaticDimension
		tableView!.estimatedRowHeight = 80
		tableView!.sectionHeaderHeight = 100.0
		var dummyViewHeight:CGFloat = 100.0;
		var dummyFrame = CGRectMake(0, 0, self.tableView!.bounds.size.width, dummyViewHeight);
		var dummyView = UIView(frame : dummyFrame)
		self.tableView!.tableHeaderView = dummyView;
		self.tableView!.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);
		self.tableView!.allowsMultipleSelection = true
		// Uncomment the following line to preserve selection between presentations
		self.clearsSelectionOnViewWillAppear = false
		print("load the individual survey  view controller")
		completed = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewWillDisappear(animated: Bool) {
		updateParseDataStore()
		println("leaving the individual survey  view controller")
	}

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return currentSurvey.questions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if currentSurvey.questions[section].answerType == "Button" {
        	return currentSurvey.questions[section].answerOptions.count
		}
		else{
			return 1
		}
    }
	
	
	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		var currentQuestionString = currentSurvey.questions[section].questionString as String
		
		
		var headerView = questionHeaderAnswerView(frame: CGRectMake(10, 10, self.tableView.bounds.width, tableView.sectionHeaderHeight), questionString: currentQuestionString)//
		headerView.displayView()
		return headerView
	}
	override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
		updateVisibleSliderCells()
	}
	
	
	func updateVisibleSliderCells(){
		var visiblePaths :NSArray  = tableView.indexPathsForVisibleRows()!
		for path in visiblePaths {
			if let cell = tableView.cellForRowAtIndexPath(path as! NSIndexPath) as? sliderTableViewCell {
				if let time = cell.lastEditedAt as NSDate?{
					currentSurvey.questions[path.section].answerIndex = Int(cell.questionSlider!.value)
					currentSurvey.questions[path.section].timeStamp = time
				}
			}
		}
	
	}

	@IBAction func pressed(sender: AnyObject) {
		print("bar button action")
		//var last = tableView.indexPathsForVisibleRows()?.last as! NSIndexPath
		var last = tableView.indexPathsForVisibleRows()!.last as! NSIndexPath
		//tableView.cellForRowAtIndexPath(last as NSIndexPath)?.backgroundColor = UIColor.redColor();
		var lastSection = (tableView.indexPathsForVisibleRows()?.last!.section)!
		
		if lastSection-1 >= 0{
			// because if only part of a section is showing you want to continue to show it
			lastSection -= 1
		}
		var firstSection = (tableView.indexPathsForVisibleRows()?.first!.section)!
		var lastSectionNumberOfRows = tableView.numberOfRowsInSection(lastSection+1)
	
		var rect: CGRect = self.tableView.bounds;
		var distanceToScroll:CGFloat = 0;
		
		if tableView.numberOfSections() == lastSection+2 {
			var cellIndexToScroll = NSIndexPath(forRow: lastSectionNumberOfRows-1 , inSection: tableView.numberOfSections()-1)
			self.tableView.scrollToRowAtIndexPath(cellIndexToScroll, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
		
		}
			
		else{
		var lastRect = tableView.rectForRowAtIndexPath(last)
		
		for (var i=firstSection; i<=lastSection ; i++){
			distanceToScroll += tableView.rectForSection(i).height 
			
		}
		var scrollToRect: CGRect = CGRectOffset(rect, 0, distanceToScroll);
		self.tableView.scrollRectToVisible(scrollToRect, animated: true)
		}
		
		

	}
	@IBAction func backbutton(sender: AnyObject) {
		print("bar button action")
		
		//var last = tableView.indexPathsForVisibleRows()?.last as! NSIndexPath
		
		var last: AnyObject = tableView.indexPathsForVisibleRows()!.last!

		var lastSection = (tableView.indexPathsForVisibleRows()?.last!.section)!
		if lastSection-1 >= 0{
			lastSection -= 1
		}
		
		//var lastt = tableView.indexPathsForVisibleRows().last

		var firstSection = (tableView.indexPathsForVisibleRows()?.first!.section)!
		var lastSectionNumberOfRows = tableView.numberOfRowsInSection(lastSection)
		
		var rect: CGRect = self.tableView.bounds;
		var lastRect = tableView.rectForRowAtIndexPath(last as! NSIndexPath)
		var distanceToScroll:CGFloat = 0;
		for (var i=firstSection; i<=lastSection ; i++){
			distanceToScroll += tableView.rectForSection(i).height
			var scrollToRect: CGRect = CGRectOffset(rect, 0, -distanceToScroll);
			self.tableView.scrollRectToVisible(scrollToRect, animated: true)
		 }
	}
		
		
	
	
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		var reuseIdentifier = "cell"
		if(indexPath.section>currentSurvey.questions.count || indexPath.row>currentSurvey.questions[indexPath.section].answerOptions.count){
			let cell = UITableViewCell()
			cell.tintColor = UIColor.blueColor()
			print("here")
		}
		
		if currentSurvey.questions[indexPath.section].answerType == "Button" {
			let cell = buttonTableViewCell()
			cell.setAnswer(currentSurvey.questions[indexPath.section].answerOptions, answerIndex: indexPath.row)
			setTheStateAtIndexPath(indexPath) // selects/ deselects the appropriate cells
			return cell
		}
		else{
			let cell = sliderTableViewCell()
			cell.display(currentSurvey.questions[indexPath.section])
			return cell
		}
    }




	//override func tableView(tableView: UITableView,
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if currentSurvey.questions[indexPath.section].answerType == "Button" {
			currentSurvey.questions[indexPath.section].answerIndex = indexPath.row
			currentSurvey.questions[indexPath.section].unixTimeStamp = NSDate().timeIntervalSince1970 * 1000
			//update the tableview values
			var visiblePaths :NSArray  = tableView.indexPathsForVisibleRows()!
			for path in visiblePaths{
				setTheStateAtIndexPath(path as! NSIndexPath)
			}
		}
		else{
			// slider view data is gathered when the user scrolls
			if let cell = tableView.cellForRowAtIndexPath(indexPath) as? sliderTableViewCell
			{

			}
		}
	}
	
	
	func setTheStateAtIndexPath(path: NSIndexPath){
		if(currentSurvey.questions[path.section].answerIndex != -1 && currentSurvey.questions[path.section].answerIndex == path.row){
				tableView.selectRowAtIndexPath(path, animated: false, scrollPosition: UITableViewScrollPosition.None)
		}
		else{
			tableView.deselectRowAtIndexPath(path, animated: false)
		}
	}
	
	
	
	@IBAction func SubmitButtonAction(sender: UIButton){
		// check if all the questions have been answered
		updateVisibleSliderCells()
		if(currentSurvey.getProgress() != 1){
			createNotDoneAlertView(currentSurvey.getAnswered())
		}
		else{
			updateParseDataStore()
			currentSurvey.completed = true
			
			currentSurvey.surveyCompletedTime = NSDate()
			self.navigationController?.popToRootViewControllerAnimated(true)
		//	performSegueWithIdentifier("backToAllSurveys", sender: sender)
		}
	}
	
	func createNotDoneAlertView(answered: CGFloat){
		var createAccountErrorAlert: UIAlertView = UIAlertView()
		createAccountErrorAlert.delegate = self
		createAccountErrorAlert.title = "Are sure you would like to submit?"
		createAccountErrorAlert.message = "you have only answered \( Int(answered))/\(currentSurvey.questions.count) questions"
		createAccountErrorAlert.addButtonWithTitle("Submit")
		createAccountErrorAlert.addButtonWithTitle("Continue Working")
		createAccountErrorAlert.show()
	}
	
	func updateParseDataStore(){
		for questionN in currentSurvey.questions{
			if(questionN.answerIndex>=0){
			var surveyResponse = PFObject(className:"testingSurveyDataCollection")
			surveyResponse["surveyID"] = currentSurvey.surveyName
			surveyResponse["userEmail"] = currentSurvey.userEmail
			
			surveyResponse["appID"] = "ND-WB-SAV-2015-04-18"
			surveyResponse["userID"] = UIDevice.currentDevice().identifierForVendor.UUIDString
				
			surveyResponse["questionResponseString"] = questionN.answerOptions[questionN.answerIndex]
			surveyResponse["questionResponse"] = questionN.answerIndex

			surveyResponse["Category"] = currentSurvey.surveyDescriptor

			surveyResponse["unixTimeStamp"] = questionN.timeStamp.timeIntervalSince1970*1000
			surveyResponse["questionID"] = questionN.questionID
			surveyResponse.saveEventually()
			}
			
		}
		
		var objects: [AnyObject] = currentSurvey.questions
		if let objects = objects as? [PFObject] {
			PFObject.pinAllInBackground(objects)
		}
	}

	override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
		footerView.backgroundColor = UIColor.blackColor()
		
		return footerView
	}

	override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 5.0
	}
	//send the entire
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "backToHomeScreen" {
			let nextView :homeTableViewController = homeTableViewController()
			nextView.inProgressSurveys.append(currentSurvey)
		}
	}
	override func didMoveToParentViewController(parent: UIViewController?){
		if let parent = parent as? homeTableViewController{
			if completed{
				parent.completedSurveys.append(currentSurvey)
			}
			else{
				parent.inProgressSurveys.append(currentSurvey)
			}
		}
	}
	
	
	func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
		switch buttonIndex{
			case 1:
				NSLog("Retry");
				break;
			case 0:
				//updateParseDataStore()
				currentSurvey.surveyCompletedTime = NSDate()
				currentSurvey.cancelNotifications()
				currentSurvey.completed = true;
				self.navigationController?.popToRootViewControllerAnimated(true)
				//performSegueWithIdentifier("backToAllSurveys", sender: self)
				break;
			default:
				NSLog("Default");
				break;
		}
	}
	

}
