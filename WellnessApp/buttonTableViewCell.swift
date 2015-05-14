//
//  buttonTableViewCell.swift
//  WellnessApp
//
//  Created by Anna Jo McMahon on 4/11/15.
//  Copyright (c) 2015 anna. All rights reserved.
//

import UIKit

class buttonTableViewCell: UITableViewCell {
	
	var buttonLabel: UILabel?
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	func setAnswer(answersOptions: [String] ,answerInd: Int){
		self.buttonLabel = UILabel()
		
		self.buttonLabel!.text = answersOptions[answerInd]
		var viewsDictionary: [String: UILabel] = ["buttonLabel": self.buttonLabel! ]
		self.buttonLabel!.setTranslatesAutoresizingMaskIntoConstraints(false)
		self.addSubview(self.buttonLabel!)
		
		
		var centerLabelConstraint = NSLayoutConstraint(item: self.buttonLabel!, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
		
		let vertPosLabelConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[buttonLabel]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewsDictionary)
		let horizontalLabelConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[buttonLabel]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: viewsDictionary)
		self.addConstraint(centerLabelConstraint)
		self.addConstraints(vertPosLabelConstraint)
		self.addConstraints(horizontalLabelConstraint)
		
	}
	func display(){
		//self.buttonLabel =
	}
	
		
	

}
