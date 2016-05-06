//
//  SomeCollectionViewCell.swift
//  MonthCalender
//
//  Created by David on 2016/5/5.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class SomeCollectionViewCell: UICollectionViewCell {
	
	var currentCalenderDate: NSDate?
	var date: NSDate! {
		didSet {
			updateUI()
		}
	}
	var titleLabel: UILabel!
	var todayShapeLayer: CAShapeLayer?
	var didSelectedShapeLayer: CAShapeLayer?
	var selectedDates: [NSDate] = []
	
	override init(frame: CGRect) {
		super.init(frame: frame)
//		backgroundColor = randomColor()
		
		titleLabel = UILabel()
		titleLabel.textAlignment = .Center
		titleLabel.font = UIFont.systemFontOfSize(14)
		titleLabel.frame.size.height = 17
		
		addSubview(titleLabel)
		
		didSelectedShapeLayer = CAShapeLayer()
		let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
		didSelectedShapeLayer!.path = UIBezierPath(ovalInRect: rect).CGPath
		didSelectedShapeLayer!.fillColor = UIColor.redColor().CGColor
		didSelectedShapeLayer!.position = CGPoint(x: (frame.width - rect.width) / 2, y: (frame.height - rect.height) / 2)
		layer.insertSublayer(didSelectedShapeLayer!, below: titleLabel.layer)
	}
	
	func updateUI() {
		titleLabel.text = "\(dayOfDate(date))"
		titleLabel.sizeToFit()
		titleLabel.center = CGPoint(x: bounds.midX, y: bounds.midY)
		
		if sameMonth() {
			titleLabel.textColor = UIColor.blackColor()
		} else {
			titleLabel.textColor = UIColor.lightGrayColor()
		}
		
		if today() {
			print("yo")
			todayLayer()
		} else {
			todayShapeLayer?.removeFromSuperlayer()
		}
		
		performSelect()
	}
	
	func todayLayer() {
		todayShapeLayer = CAShapeLayer()
		let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
		todayShapeLayer!.path = UIBezierPath(ovalInRect: rect).CGPath
		todayShapeLayer!.fillColor = UIColor.redColor().CGColor
		todayShapeLayer!.position = CGPoint(x: (frame.width - rect.width) / 2, y: (frame.height - rect.height) / 2)
		layer.insertSublayer(todayShapeLayer!, below: titleLabel.layer)
		
		titleLabel.textColor = UIColor.whiteColor()
	}
	
	func sameMonth() -> Bool {
		if monthOfDate(date) == monthOfDate(currentCalenderDate) {
			return true
		}
		return false
	}
	
	func today() -> Bool {
		let now = NSDate()
		if dayOfDate(date) == dayOfDate(now) {
			if monthOfDate(date) == monthOfDate(now) {
				if yearOfDate(date) == yearOfDate(now) {
					print(date)
					return true
				}
			}
		}
		return false
	}
	
	func dayOfDate(date: NSDate) -> Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date ?? NSDate()).day
	}
	
	func monthOfDate(date: NSDate?) -> Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date ?? NSDate()).month
	}
	
	func yearOfDate(date: NSDate?) -> Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date ?? NSDate()).year
	}
	
	func randomColor() -> UIColor {
		let r = CGFloat(Double(rand() % 255) / 255.0)
		let g = CGFloat(Double(rand() % 255) / 255.0)
		let b = CGFloat(Double(rand() % 255) / 255.0)
		return UIColor(red: r, green: g, blue: b, alpha: 1)
	}
	
	func performSelect() {
		if selectedDates.contains(date) {
			didSelectedShapeLayer?.hidden = false
		} else {
			didSelectedShapeLayer?.hidden = true
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		CATransaction.setDisableActions(true)
		didSelectedShapeLayer?.hidden = true
		todayShapeLayer?.hidden = true
		
	}
}
