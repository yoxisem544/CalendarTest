//
//  ViewController.swift
//  MonthCalender
//
//  Created by David on 2016/5/5.
//  Copyright © 2016年 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var collectionView: UICollectionView!
	var currentDate: NSDate = NSDate()
	var selectedDates: [NSDate] = []
	
	var timeLabel: UILabel!
	
	var cc: DLCalendarView!

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		
		configureCollectionView()
		
		let now = NSDate()
		var com = NSCalendar.currentCalendar().components([NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day], fromDate: now)
		com.day = 31
		let nextday = NSCalendar.currentCalendar().dateFromComponents(com)!
		print(daysOfDate(nextday))
		print(weekdayOfDate(nextday))
		
		print(nextday)
		print("=====")
		let nextM = dateByAddingMonth(1, toDate: nextday)
		print(nextM)
		let a = dateByAddingDay(2, toDate: nextday)
		print(a)
		
		configureCalendar()
		calendar.forEach { (dates: [NSDate]) in
//			print("\n", "===", "\n")
//			print(dates)
//			print(dates.count)
		}
		
		
		collectionView.reloadData()
		
		timeLabel = UILabel()
		timeLabel.frame.size.height = 30
		timeLabel.font = UIFont.systemFontOfSize(28)
		timeLabel.textAlignment = .Center
		timeLabel.text = "yoyoyo"
		timeLabel.sizeToFit()
		
		view.addSubview(timeLabel)
		timeLabel.center = view.center
		timeLabel.center.y += 100
		
		// yoyo
		let calendarSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 300)
		cc = DLCalendarView(frame: CGRect(origin: CGPoint(x: 0, y: 400), size: calendarSize))
		view.addSubview(cc)
		print(cc.currentMaxMonths)
		print(cc.currentMaxMonths)
		
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(t)))
		
		for _ in 1...cc.currentMaxMonths! {
			cc.nextMonth()
		}
	}
	
	func t(g: UITapGestureRecognizer) {
		let location = g.locationInView(view)
		if location.x > 250 {
			cc.nextMonth()
		} else {
			cc.previousMonth()
		}
	}
	
	var calendar: [[NSDate]] = []
	
	func configureCalendar() {
		let now = NSDate()
		for month in 0..<12*100 {
			if let date = dateByAddingMonth(month, toDate: now), let _month = configureMonth(date) {
				calendar.append(_month)
			}
		}
		let after = NSDate()
		print("time of creating 12 * 100 month")
		print(after.timeIntervalSinceDate(now))
	}
	
	func configureMonth(date: NSDate) -> [NSDate]? {
		var datesOfMonth = [NSDate]()
		guard let firstDayOfTheMonth = beginingOfMonthOfDate(date) else { return nil }
//		print(firstDayOfTheMonth)
		let startWeekDay = weekdayOfDate(firstDayOfTheMonth)
		// this month
		for day in 0..<daysOfDate(firstDayOfTheMonth) {
			if let _date = dateByAddingDay(day, toDate: firstDayOfTheMonth) {
				datesOfMonth.append(_date)
			}
		}
//		print(datesOfMonth)
		// previous month
//		print((1..<startWeekDay).reverse())
		for pd in (1..<startWeekDay).reverse().reverse() {
			if let _date = dateByAddingDay(-pd, toDate: firstDayOfTheMonth) {
				datesOfMonth.insert(_date, atIndex: 0)
			}
		}
//		print(datesOfMonth)
		// next month
		for nextD in (datesOfMonth.count+1...42) {
			if let _date = dateByAddingDay(nextD-startWeekDay, toDate: firstDayOfTheMonth) {
				datesOfMonth.append(_date)
			}
		}
//		print(datesOfMonth)
		
		return datesOfMonth
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
	
	func stringOfDate(date: NSDate) -> String {
		let year = yearOfDate(date)
		let month = monthOfDate(date)
		let day = dayOfDate(date)
		return "\(year)-\(month)-\(day)"
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
	
	func nextPage(scrollView: UIScrollView) {
		let nextPagePoint = CGPoint(x: scrollView.contentOffset.x + scrollView.frame.width, y: 0)
		scrollView.setContentOffset(nextPagePoint, animated: true)
	}
	
	func previousPage(scrollView: UIScrollView) {
		let previousPagePoint = CGPoint(x: scrollView.contentOffset.x - scrollView.frame.width, y: 0)
		scrollView.setContentOffset(previousPagePoint, animated: true)
	}
	
	func configureCollectionView() {
		
		let calendarSize = CGSize(width: UIScreen.mainScreen().bounds.width, height: 300)
		
		let layout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsetsZero
		layout.minimumInteritemSpacing = 0
		layout.minimumLineSpacing = 0
		layout.itemSize = CGSize(width: calendarSize.width/7, height: calendarSize.height/6)
		layout.scrollDirection = .Horizontal
		
		collectionView = UICollectionView(frame: CGRect(origin: CGPoint(x: 0, y:  0), size: calendarSize), collectionViewLayout: layout)
		collectionView.backgroundColor = UIColor.clearColor()
		
		view.addSubview(collectionView)
		
		collectionView.pagingEnabled = true
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
		collectionView.registerClass(SomeCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
	}


}

extension ViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return calendar.count
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return calendar[section].count
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! SomeCollectionViewCell
		let ya = 7*(indexPath.item%6) + indexPath.item/6
//		print(ya)\
		cell.selectedDates = selectedDates
		cell.currentCalenderDate = calendar[indexPath.section][21]
		cell.date = calendar[indexPath.section][ya]
		
		return cell
	}
	
	// MARK: - Delegate
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let cell = collectionView.cellForItemAtIndexPath(indexPath) as! SomeCollectionViewCell
		let ya = 7*(indexPath.item%6) + indexPath.item/6
		if !selectedDates.contains(calendar[indexPath.section][ya]) {
			selectedDates.append(calendar[indexPath.section][ya])
		} else {
			if let index = selectedDates.indexOf(calendar[indexPath.section][ya]) {
				selectedDates.removeAtIndex(index)
			}
		}
		cell.selectedDates = selectedDates
		cell.performSelect()
	}
}

extension ViewController : UIScrollViewDelegate {
	func scrollViewDidScroll(scrollView: UIScrollView) {
		
	}
	func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
		let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
		let beginingDate = beginingOfMonthOfDate(calendar[page][21])
		timeLabel.text = stringOfDate(beginingDate!)
		timeLabel.sizeToFit()
		timeLabel.center = view.center
		timeLabel.center.y += 100
		
		
	}
}