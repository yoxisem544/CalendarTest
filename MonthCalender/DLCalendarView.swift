//
//  DLCalendarView.swift
//  MonthCalender
//
//  Created by David on 2016/5/9.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

public class DLCalendarView: UIView {
	
	var calendarCollectionView: UICollectionView
	var calendarCollectionViewLayout: UICollectionViewFlowLayout
	
	var selectedDates: [NSDate] = []
	var calendar: [[NSDate]]
	var startDate: NSDate?
	var endDate: NSDate?

	public override init(frame: CGRect) {
		
		calendarCollectionViewLayout = UICollectionViewFlowLayout()
		calendarCollectionView = UICollectionView(frame: frame, collectionViewLayout: calendarCollectionViewLayout)
		calendar = []
		
		super.init(frame: frame)
		
		// layout
		calendarCollectionViewLayout.sectionInset = UIEdgeInsetsZero
		calendarCollectionViewLayout.minimumLineSpacing = 0
		calendarCollectionViewLayout.minimumInteritemSpacing = 0
		let itemWidth = frame.width / 7
		let itemHeight = frame.height / 6
		calendarCollectionViewLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
		calendarCollectionViewLayout.scrollDirection = .Horizontal
		
		// configure collection view
		calendarCollectionView.frame.origin = CGPointZero
		calendarCollectionView.backgroundColor = UIColor.whiteColor()
		calendarCollectionView.pagingEnabled = true
		calendarCollectionView.delegate = self
		calendarCollectionView.dataSource = self
		
		calendarCollectionView.registerClass(SomeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		
		addSubview(calendarCollectionView)
		
		// configure calendar
		if startDate == nil {
			let components = NSDateComponents()
			components.year = 1970
			components.month = 1
			components.day = 1
			startDate = NSCalendar.currentCalendar().dateFromComponents(components)
		}
		if endDate == nil {
			let components = NSDateComponents()
			components.year = 2099
			components.month = 12
			components.day = 31
			endDate = NSCalendar.currentCalendar().dateFromComponents(components)
		}
		if let startDate = startDate, let endDate = endDate {
			// calculate the required months to create
			let monthsToCreate = monthsBetween(date: startDate, andDate: endDate)
			if monthsToCreate >= 0 {
				for month in 0..<monthsToCreate {
					if let date = dateByAddingMonths(month, toDate: startDate), let monthOnCalendar = configureMonthByDate(date) {
						calendar.append(monthOnCalendar)
					}
				}
			} else {
				print("error creating caclendar!!!")
			}
		} else {
			print("error creating calendar!!")
		}
	}
	
	func monthsBetween(date date: NSDate, andDate: NSDate) -> Int {
		return (yearOfDate(andDate) - yearOfDate(date)) * 12 + (monthOfDate(andDate) - monthOfDate(date)) + 1
	}
	
	func configureMonthByDate(date: NSDate) -> [NSDate]? {
		
		// check if this date has a first date of the month
		guard let firstDayOfTheMonth = beginingOfMonthOfDate(date) else { return nil }
		// initial cache
		var datesOfMonth = [NSDate]()
		// get weekday of the beginning date of this month
		let startWeekday = weekdayOfDate(firstDayOfTheMonth)
		// first, create dates of this month.
		for dayOffsetFromFirstDay in 0..<daysOfDate(firstDayOfTheMonth) {
			// 0 is first day of this month.
			// this for loop will create dates of this month
			// ex. 4/1 ~ 4/30, 30 is +29 offset from first day
			if let date = dateByAddingDays(dayOffsetFromFirstDay, toDate: firstDayOfTheMonth) {
				datesOfMonth.append(date)
			}
		}
		// second, show previous month's dates
		// ex. if 4/1 is fri, so you are going to show 5/31 on preivous thu, etc.
		for daysFromPreviousMonth in (1..<startWeekday) {
			if let date = dateBySubtractingDays(daysFromPreviousMonth, toDate: firstDayOfTheMonth) {
				datesOfMonth.insert(date, atIndex: 0)
			}
		}
		// third, make this array to contain 42 days.
		for daysToNextMonth in (datesOfMonth.count..<42) {
			// -1 because weekday start from 1
			if let date = dateByAddingDays(daysToNextMonth - startWeekday - 1, toDate: firstDayOfTheMonth) {
				datesOfMonth.append(date)
			}
		}
		
		return datesOfMonth
	}
	
	func daysOfDate(date: NSDate) -> Int {
		return NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date).length
	}
	
	func weekdayOfDate(date: NSDate) -> Int {
		// will return from 1 ~ 7
		// 1 is sunday
		// 7 is saturday
		// sun mon tue wen thu fri sat
		//  1	2	3	4	5	6	7
		return NSCalendar.currentCalendar().component(NSCalendarUnit.Weekday, fromDate: date)
	}
	
	func beginingOfMonthOfDate(date: NSDate) -> NSDate? {
		let component = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour], fromDate: date)
		component.day = 1
		return NSCalendar.currentCalendar().dateFromComponents(component)
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
	
	func dateByAddingMonths(months: Int, toDate: NSDate) -> NSDate? {
		let components = NSDateComponents()
		components.year = NSIntegerMax
		components.month = NSIntegerMax
		components.weekOfYear = NSIntegerMax
		components.day = NSIntegerMax
		components.month = months
		return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: toDate, options: [])
	}
	
	func dateBySubtractingMonths(months: Int, toDate: NSDate) -> NSDate? {
		return dateByAddingMonths(-months, toDate: toDate)
	}
	
	func dateByAddingDays(days: Int, toDate: NSDate) -> NSDate? {
		let components = NSDateComponents()
		components.year = NSIntegerMax
		components.month = NSIntegerMax
		components.weekOfYear = NSIntegerMax
		components.day = NSIntegerMax
		components.day = days
		return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: toDate, options: [])
	}
	
	func dateBySubtractingDays(days: Int, toDate: NSDate) -> NSDate? {
		return dateByAddingDays(-days, toDate: toDate)
	}
	
	public required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func stringOfDate(date: NSDate) -> String {
		let year = yearOfDate(date)
		let month = monthOfDate(date)
		let day = dayOfDate(date)
		return "\(year)-\(month)-\(day)"
	}
	
	func dateOfIndexPath(indexPath: NSIndexPath) -> NSDate {
		let indexOnCalendar = 7 * (indexPath.item % 6) + indexPath.item / 6
		return calendar[indexPath.section][indexOnCalendar]
	}
	
	func selectIndexPathOnCalendar(indexPath: NSIndexPath) {
		let dateSelected = dateOfIndexPath(indexPath)
		if !selectedDates.contains(dateSelected) {
			selectedDates.append(dateSelected)
		} else {
			if let index = selectedDates.indexOf(dateSelected) {
				selectedDates.removeAtIndex(index)
			}
		}
	}
	
	func currentDateOfIndexPath(indexPath: NSIndexPath) -> NSDate {
		return calendar[indexPath.section][21]
	}
	
	// MARK: - Getters
	var currentMaxMonths: Int? {
		if let startDate = startDate, let endDate = endDate {
			return monthsBetween(date: startDate, andDate: endDate)
		}
		return nil
	}
	
	var calendarWidth: CGFloat {
		return calendarCollectionView.frame.width
	}
	
	// MARK: - Calendar mover
	func jumpToDate(date: NSDate) {
		
	}
	
	func nextMonth() {
		let point = CGPoint(x: calendarCollectionView.contentOffset.x + calendarWidth, y: 0)
		if let startDate = startDate, let endDate = endDate {
			if !(point.x > CGFloat(monthsBetween(date: startDate, andDate: endDate) - 1) * calendarWidth) {
				calendarCollectionView.setContentOffset(point, animated: true)
			}
		}
	}
	
	func previousMonth() {
		let point = CGPoint(x: calendarCollectionView.contentOffset.x - calendarWidth, y: 0)
		if !(point.x < 0) {
			calendarCollectionView.setContentOffset(point, animated: true)
		}
	}
}

extension DLCalendarView : UICollectionViewDelegate, UICollectionViewDataSource {
	
	public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return calendar.count
	}
	
	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return calendar[section].count
	}
	
	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! SomeCollectionViewCell
		cell.selectedDates = selectedDates
		cell.currentCalenderDate = currentDateOfIndexPath(indexPath)
		cell.date = dateOfIndexPath(indexPath)
		
		return cell
	}
	
	public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SomeCollectionViewCell
		selectIndexPathOnCalendar(indexPath)
		cell.selectedDates = selectedDates
		cell.performSelect()
	}
}
extension DLCalendarView : UIScrollViewDelegate {
	public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
		let beginingDate = beginingOfMonthOfDate(calendar[page][21])
		print(stringOfDate(beginingDate!))
	}
}