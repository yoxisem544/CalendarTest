//
//  ViewController.swift
//  MonthCalender
//
//  Created by David on 2016/5/5.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public class ViewController: UIViewController {
	
	var cc: DLCalendarView!
	
	@IBOutlet weak var changeTodayColorButton: UIButton!
	@IBOutlet weak var changeSelectedColorButton: UIButton!
	@IBOutlet weak var changeThisMonthTextColorButton: UIButton!
	@IBOutlet weak var changeOtherMonthTextColorButton: UIButton!
	@IBOutlet weak var changeSelectedDateTextColorButton: UIButton!
	@IBOutlet weak var colorPlate: UIView!
	@IBOutlet weak var rs: UISlider!
	@IBOutlet weak var gs: UISlider!
	@IBOutlet weak var bs: UISlider!
	
	@IBAction func changeTodayColorButtonClicked() {
		changeTodayColorButton.backgroundColor = colorPlate.backgroundColor
		cc.todayColor = colorPlate.backgroundColor
		cc.reloadCalendarColor()
	}
	
	@IBAction func changeSelectedColorButtonClicked() {
		changeSelectedColorButton.backgroundColor = colorPlate.backgroundColor
		cc.selectedColor = colorPlate.backgroundColor
		cc.reloadCalendarColor()
	}
	
	@IBAction func changeThisMonthTextColorButtonClicked() {
		changeThisMonthTextColorButton.backgroundColor = colorPlate.backgroundColor
		cc.thisMonthTextColor = colorPlate.backgroundColor
		cc.reloadCalendarColor()
	}
	
	@IBAction func changeOtherMonthTextColorButtonClicked() {
		changeOtherMonthTextColorButton.backgroundColor = colorPlate.backgroundColor
		cc.otherMonthTextColor = colorPlate.backgroundColor
		cc.reloadCalendarColor()
	}
	
	@IBAction func changeSelectedDateTextColorButtonClicked() {
		changeSelectedDateTextColorButton.backgroundColor = colorPlate.backgroundColor
		cc.selectedDateTextColor = colorPlate.backgroundColor
		cc.reloadCalendarColor()
	}

	@IBAction func redChanged(sender: AnyObject) {
		colorPlate.backgroundColor = UIColor(red: CGFloat(rs.value), green: CGFloat(gs.value), blue: CGFloat(bs.value), alpha: 1.0)
	}
	
	@IBAction func greenChanged(sender: AnyObject) {
		colorPlate.backgroundColor = UIColor(red: CGFloat(rs.value), green: CGFloat(gs.value), blue: CGFloat(bs.value), alpha: 1.0)
	}
	
	@IBAction func blueChanged(sender: AnyObject) {
		colorPlate.backgroundColor = UIColor(red: CGFloat(rs.value), green: CGFloat(gs.value), blue: CGFloat(bs.value), alpha: 1.0)
	}
	
	@IBOutlet weak var dateLabel: UILabel!
	
	override public func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.

		// yoyo
		let calendarSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 250)
		cc = DLCalendarView(frameWithHeader: CGRect(origin: CGPoint(x: 0, y: 400), size: calendarSize))
//		cc = DLCalendarView(frame: CGRect(origin: CGPoint(x: 0, y: 400), size: calendarSize))
		view.addSubview(cc)
		print(cc.currentMaxMonths)
		print(cc.currentMaxMonths)
		
		cc.delegate = self
	}
	
	override public func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		cc.jumpToTaday()
		dateLabel.text = stringOfDate(cc.currentDate)
	}

	// start 1970 1
	// end 2099 12
	func daysOfDate(date: NSDate) -> Int {
		return NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date).length
	}
	
	func tomorrowOfDate(date: NSDate) -> NSDate? {
		let component = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: date)
		component.day += 1
		return NSCalendar.currentCalendar().dateFromComponents(component)
	}
	
	func yesterdayOfDate(date: NSDate) -> NSDate? {
		let component = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: date)
		component.day -= 1
		return NSCalendar.currentCalendar().dateFromComponents(component)
	}
	
	func beginingOfMonthOfDate(date: NSDate) -> NSDate? {
		let component = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: date)
		component.day = 1
		return NSCalendar.currentCalendar().dateFromComponents(component)
	}
	
	func endOfMonthOfDate(date: NSDate) -> NSDate? {
		let component = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: date)
		component.month += 1
		component.day = 0
		return NSCalendar.currentCalendar().dateFromComponents(component)
	}
	
	func weekdayOfDate(date: NSDate) -> Int {
		// will return from 1 ~ 7
		// 1 is sunday
		// 7 is saturday
		// sun mon tue wen thu fri sat
		//  1	2	3	4	5	6	7
		return NSCalendar.currentCalendar().component(NSCalendarUnit.Weekday, fromDate: date)
	}
	
	func yearOfDate(date: NSDate) -> Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date).year
	}
	
	func monthOfDate(date: NSDate) -> Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date).month
	}
	
	func dayOfDate(date: NSDate) -> Int {
		return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: date).day
	}
	
	func stringOfDate(date: NSDate?) -> String {
		if let date = date {
			let year = yearOfDate(date)
			let month = monthOfDate(date)
			let day = dayOfDate(date)
			return "\(year)-\(month)-\(day)"
		}
		return ""
	}
	
	func dateByAddingYear(year: Int, toDate: NSDate) -> NSDate? {
		let components = NSDateComponents()
		components.year = NSIntegerMax
		components.month = NSIntegerMax
		components.weekOfYear = NSIntegerMax
		components.day = NSIntegerMax
		components.year = year
		return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: toDate, options: [])
	}
	
	func dateByAddingMonth(month: Int, toDate: NSDate) -> NSDate? {
		let components = NSDateComponents()
		components.year = NSIntegerMax
		components.month = NSIntegerMax
		components.weekOfYear = NSIntegerMax
		components.day = NSIntegerMax
		components.month = month
		return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: toDate, options: [])
	}
	
	func dateByAddingWeek(week: Int, toDate: NSDate) -> NSDate? {
		let components = NSDateComponents()
		components.year = NSIntegerMax
		components.month = NSIntegerMax
		components.weekOfYear = NSIntegerMax
		components.day = NSIntegerMax
		components.weekOfYear = week
		return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: toDate, options: [])
	}
	
	func dateByAddingDay(day: Int, toDate: NSDate) -> NSDate? {
		let components = NSDateComponents()
		components.year = NSIntegerMax
		components.month = NSIntegerMax
		components.weekOfYear = NSIntegerMax
		components.day = NSIntegerMax
		components.day = day
		return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: toDate, options: [])
	}

}

extension ViewController : DLCalendarViewDelegate {
	public func DLCalendarViewDidSelectDate(date: NSDate) {
		dateLabel.text = stringOfDate(date) + " Selected"
	}
	
	public func DLCalendarViewDidDeselectDate(date: NSDate) {
		dateLabel.text = stringOfDate(date) + " Deselected"
	}
	
	public func DLCalendarViewDidChangeToDate(date: NSDate?) {
		dateLabel.text = stringOfDate(date)
		print("yo")
	}
}