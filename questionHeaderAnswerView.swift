//
//  questionHeaderAnswerView.swift
//  WellnessApp
//
//  Created by Anna Jo McMahon on 4/12/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

import UIKit

class questionHeaderAnswerView: UIView {
	
	var questionString: String
	var viewsDictionary = [String: UIView]()
	var questionLabel: UILabel = UILabel()
	let metrics = [ "margin" : 10 , "sliderSize" : 15, "labelSize" : 15, "betweenSliders": 10]
	
	init(frame: CGRect, questionString : String){
		self.questionString = questionString
		super.init(frame: frame)
		//displayView()
		
	}
	
	required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func displayView(){
	self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
	self.questionLabel = UILabel()
	self.questionLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
	self.questionLabel.text = self.questionString
	self.questionLabel.font = UIFont.systemFontOfSize(20)
	self.questionLabel.lineBreakMode = .ByWordWrapping
	self.questionLabel.numberOfLines = 0
	self.questionLabel.minimumScaleFactor = 0.7
	self.questionLabel.textAlignment = .Center
	self.questionLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
	self.viewsDictionary["questionLabel"] = self.questionLabel

	self.addSubview(self.questionLabel)

	var centerLabelConstraint = NSLayoutConstraint(item: questionLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
	let vertPosLabelConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[questionLabel]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewsDictionary)
	let horizontalLabelConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[questionLabel]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewsDictionary)
	self.addConstraint(centerLabelConstraint)
	self.addConstraints(vertPosLabelConstraint)
	self.addConstraints(horizontalLabelConstraint)
	}
}
