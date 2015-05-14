
//  homeTableViewController.swift

import UIKit
import Parse
import SystemConfiguration

class homeTableViewController: UITableViewController {

	var otherSurveys: [survey] = [survey]()
	var completedSurveys: [survey] = [survey]()
	var surveysArray: [survey] = [survey]()
	var AllSurveys: [survey] = [survey]()
	var pastSurveyArrays: [survey] = [survey]()
	var futureSurveysArray: [survey] = [survey]()
	let cellIdentifier = "homeTableViewCell"
	let cellHeaderIdentifier = "CustomHeaderCell"
	var theSurveySelected = 0;
	let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
	var inProgressSurveys: [survey] = [survey]()
	var currentUser = PFUser.currentUser
	var reset = false
	

    override func viewDidLoad() {
		super.viewDidLoad()
		self.hidesBottomBarWhenPushed = true;
		//maketheobjectswithLocalDataStore()
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "emptyTheArrays", name: mySpecialNotificationKey, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "emptyTheArrays", name: updateKey, object: nil)
	

		var currentUser = PFUser.currentUser()
		if currentUser != nil {
			println("there is a  user")
		} else {
			println("no user")
			self.performSegueWithIdentifier("notAUser", sender: self)
		}
		self.tabBarController
		self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "enteredForeground:", name: UIApplicationWillEnterForegroundNotification, object: nil)
		
		// register hometableview subclass
		self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
		self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellHeaderIdentifier)
		//maketheobjectswithLocalDataStore()
		
		
		if AllSurveys.isEmpty{
			maketheobjectswithLocalDataStore()
		}
		self.tableView.reloadData()
		self.tableView.setNeedsDisplay()
		
		
		var refreshControl = UIRefreshControl()
  		refreshControl.addTarget(self, action: Selector("updateTheSurveys"), forControlEvents: UIControlEvents.ValueChanged)
 		 self.refreshControl = refreshControl
		}
	
	func enteredForeground(sender : AnyObject) {
		print("enter foreground home view")
		//updateTheSurveys()
		self.tableView.reloadData()
		self.tableView.setNeedsDisplay()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

	func emptyTheArrays(){
		
		AllSurveys.removeAll(keepCapacity: false)
		completedSurveys.removeAll(keepCapacity: false)
		pastSurveyArrays.removeAll(keepCapacity: false)
		futureSurveysArray.removeAll(keepCapacity: false)
		surveysArray.removeAll(keepCapacity: false)
		otherSurveys.removeAll(keepCapacity: false)
		maketheobjectswithLocalDataStore()
	}
	
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
		if(section == 0){
			return surveysArray.count
		}
		else if (section == 1){
			return futureSurveysArray.count
		}
		else if (section == 2){
			return pastSurveyArrays.count
		}
		else{
			return otherSurveys.count
		}
		
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! homeTableViewCell? {
			var currentSurvey = survey()
			if (indexPath.section == 0) {
				currentSurvey = surveysArray[indexPath.row]
				cell.timeLabel.text = "Expires: "+currentSurvey.surveyExpirationTimeNiceFormat
				var progress = currentSurvey.getProgress()
				cell.surveyProgressView.setProgress(Float(progress), animated: false)
			}
			else{
				cell.setDisabledCellLook()
				if (indexPath.section == 1){
					currentSurvey = futureSurveysArray[indexPath.row]
					cell.timeLabel.text = "Begins: " + currentSurvey.surveyTimeNiceFormat
				}
				else{
					currentSurvey = pastSurveyArrays[indexPath.row]
					cell.timeLabel.text = "Expired: "+currentSurvey.surveyExpirationTimeNiceFormat

					if (pastSurveyArrays[indexPath.row].completed){
						cell.timeLabel.text = "Expired: "+currentSurvey.surveyExpirationTimeNiceFormat+", completed"}
					else{
						cell.timeLabel.text = "Expired: "+currentSurvey.surveyExpirationTimeNiceFormat+", missed"
					}
				}
			}
			
			cell.surveyLabel.text = currentSurvey.surveyDescriptor
			cell.setCellImage(currentSurvey.surveyDescriptor)
			
			return cell;
			}
			else {
			
				// code most likely will not go here, just a precaution
				return homeTableViewCell( style: UITableViewCellStyle.Default, reuseIdentifier: "Cell" );
			}
    }
	
	override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		
		if let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! CustomHeaderCell? {
		headerCell.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
		headerCell.headerLabel.textColor = UIColor.whiteColor()
		if (section == 0){
			headerCell.headerLabel.text = "Current Surveys"
		}
		else if (section == 1){
			headerCell.headerLabel.text = "Future Surveys"
		}
		else if (section == 2){
			headerCell.headerLabel.text = "Past Surveys"
		}
		else{
			headerCell.headerLabel.text = "other"

			}
		return headerCell}
			
		else{
			return CustomHeaderCell( style: UITableViewCellStyle.Default, reuseIdentifier: "HeaderCell" );
		}
	}
	override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) ->CGFloat{
		return 50;
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if(indexPath.section == 0){
		theSurveySelected = indexPath.row
		self.performSegueWithIdentifier("surveySelected", sender: self)

		}
	}
	
	func maketheobjectswithLocalDataStore(){
		//AllSurveys = surveysArray + pastSurveyArrays //
		var survey1 : survey?
		var query = PFQuery(className:"SurveySummary")
		query.fromLocalDatastore()

		query.findObjectsInBackgroundWithBlock {
			(objects: [AnyObject]?, error: NSError?) -> Void in
			
			if error == nil {
				var query2 = query
				if let objects = objects as? [PFObject] {
					
					for (var surveyNumber = 0; surveyNumber<objects.count ; surveyNumber++){
						var duplicate : Bool = false;
						for survey in self.AllSurveys{
							if survey.surveyDescriptor == objects[surveyNumber]["Category"] as! String{
								duplicate=true
							}
						}
						if duplicate == false {
							var surveyTimes = objects[surveyNumber]["Time"] as! [String]
							for (index, time) in enumerate(surveyTimes) {
								survey1 = survey()
								survey1!.surveyName = objects[surveyNumber]["Survey"] as! String
								survey1!.surveyDescriptor = objects[surveyNumber]["Category"] as! String
								survey1!.active = objects[surveyNumber]["Active"] as! Bool
								
								if( surveyTimes.count>1){
									survey1!.dailyIterationNumber = index+1}
								survey1!.sendTime = time
								if let days = objects[surveyNumber]["Days"] as? [Int] {
									survey1!.sendDays = days
								}
								
								survey1!.surveyActiveDuration = objects[surveyNumber]["surveyActiveDuration"] as! Double
								survey1!.versionIdentifier = objects[surveyNumber]["Version"] as! Double
								survey1!.makeNSdate()
								survey1!.queryParseForSurveyData()
								self.AllSurveys.append(survey1!)
							}
						}
					}
					self.updateTheSurveys()
				}else {
					print("BAD")
				}
				//refresh
			}
			else {
				println("FAILED HERE")
				println("Error: \(error) \(error!.userInfo!)")
			}
		}
		
	}

	func updateTheSurveys(){

		if !(surveysArray.isEmpty && futureSurveysArray.isEmpty && pastSurveyArrays.isEmpty){
			AllSurveys = surveysArray + pastSurveyArrays + futureSurveysArray
		}
		self.surveysArray.removeAll(keepCapacity: false)
		self.futureSurveysArray.removeAll(keepCapacity: false)
		self.pastSurveyArrays.removeAll(keepCapacity: false)
		self.pastSurveyArrays = completedSurveys

	// check the time of each survey created to decide which section it should go in, past , present, or future
	for survey in self.AllSurveys{
		if(survey.pastPresentOrFuture() == "present"){
			if !(survey.completed){
				surveysArray.append(survey)
			}
			else{
				pastSurveyArrays.append(survey)
			}
		}
		else if (survey.pastPresentOrFuture() == "future"){
			futureSurveysArray.append(survey)
		}
		else if (survey.pastPresentOrFuture() == "past"){
			pastSurveyArrays.append(survey)
		}
		else if (survey.pastPresentOrFuture() == "none"){
			pastSurveyArrays.append(survey)
 
			
			//otherSurveys.append(survey)
		}
		
		}
		self.refreshControl?.endRefreshing()
		self.tableView.reloadData()
		self.tableView.setNeedsDisplay()
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	if segue.identifier == "surveySelected" {
		let nextView :SurveyTableViewController = segue.destinationViewController as! SurveyTableViewController
		nextView.currentSurvey = surveysArray[theSurveySelected]
	}
	}
}







