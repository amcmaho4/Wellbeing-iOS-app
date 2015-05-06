//
//  homeTableViewCell.swift
//  wellness
//
//  Created by Anna Jo McMahon on 3/2/15.
//  Copyright (c) 2015 Andrei Puni. All rights reserved.
//

import UIKit

class homeTableViewCell: UITableViewCell {

	@IBOutlet var timeLabel: UILabel!
	@IBOutlet var surveyLabel: UILabel!
	@IBOutlet var surveyProgressView: UIProgressView!
	@IBOutlet var surveyDescriptionImageView: UIImageView!

	enum surveyIdentifiers : String {
		case mood = "Mood", spirit = "Spirituality", sleep = "Sleep",dayrecon = "Day Reconstruction", social = "Social Interaction", wellness = "Life", generic = "Other"
		
		static let allValues = [mood, spirit, sleep, dayrecon, social,wellness, generic]
	}
	enum surveyImages : String {
		case mood = "mood.jpg", spirit = "Faith.jpg", sleep = "sleep.jpg",dayrecon = "Reconstruction.jpg", social = "social-1.jpg", wellness = "wellness.jpg", generic = "generic.png"
		
		static let allValues = [mood, spirit, sleep, dayrecon, social,wellness, generic]
	}

	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	
	func setEnabledCellLook(){
	
	}
	func setDisabledCellLook(){
		timeLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
		surveyLabel.textColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
		selectionStyle = UITableViewCellSelectionStyle.None  //so you cannot select the rows
		surveyProgressView.hidden = true
	}
	
	func setCellImage(surveyDescriptor: String){
		var match = false;
		for surveytype in surveyIdentifiers.allValues{
			if(surveyDescriptor == surveytype.rawValue ){
				match = true;
				surveyDescriptionImageView.image = UIImage(named: surveyImages.allValues[surveytype.hashValue].rawValue)
			}
		}
		if !match{
			surveyDescriptionImageView.image = UIImage(named: "generic.png")
		}
	}

}
