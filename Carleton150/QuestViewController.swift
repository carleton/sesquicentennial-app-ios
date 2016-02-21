//
//  QuestViewController.swift
//  Carleton150
//

import UIKit
import SwiftOverlays

class QuestViewController: UIViewController, UIPageViewControllerDataSource{
	
	var pageViewController: UIPageViewController!
	var quests = [Quest]()

	
	/**
		Upon load setup the persistent storage if it has not been setup already, request data for
		 quests. Once the data has been loaded, create the first page of the paged layout
	 */
    override func viewDidLoad() {
		
		self.showWaitOverlay()
		
		// setting up data persistence 
		if NSUserDefaults.standardUserDefaults().objectForKey("startedQuests") == nil {
			NSUserDefaults.standardUserDefaults().setObject(Dictionary<String,Int>(), forKey: "startedQuests")
		}
		
		Utils.setUpNavigationBar(self)
		
		/**
			Request data from the server
		 */
		QuestDataService.requestQuest("", limit: 5, completion: { (success, result) -> Void in
			if let quests = result {
				
				self.removeAllOverlays()
				self.quests = quests
				self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
				self.pageViewController.dataSource = self
				
				let startVC = self.getViewControllerAtIndex(0) as QuestContentViewController
				let viewControllers = NSArray(object: startVC)
				
				self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
				self.addChildViewController(self.pageViewController)
				self.view.addSubview(self.pageViewController.view)
				self.pageViewController.didMoveToParentViewController(self)
				
			} else {
				// handle error gracefully here i.e. create a button that allows you to make the request again
			}
		});
		
	}
	
	/**
		Fetches the appropriate UIViewController when swiping between pages. It creates a new
		instance of QuestContentViewController and sets the quest name, description, image and
		passes the quest to the QuestContentViewController
	
		- Parameters:
			index: integer used to fetch data from the quests array
	
		- Returns: UI View Controller
	
	*/
	func getViewControllerAtIndex(index: Int) -> QuestContentViewController {
		// if we're at the edges of the page view
		if ((self.quests.count == 0 ) || (index >= self.quests.count)) {
			return QuestContentViewController()
		}
		// create new page view
		let vc: QuestContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("QuestContentViewController") as! QuestContentViewController
		// set attributes of the new view
		vc.pageIndex = index
		vc.titleText = quests[index].name
		vc.descText = quests[index].questDescription
		vc.image = quests[index].image
		vc.difficultyRating = quests[index].difficulty
		vc.quest = quests[index]
		return vc
	}
	
	/**
	 * MARK: - Data Source
	 * UIPageViewControllerDataSource Methods
	**/
	
	/**
		Gets the view controller for the previous page or nil if at first page
		
		- Parameters:
			pageViewController: the view controller responsible for managing the page layout.
		
		- Returns: view controller for the previous page or nil
	
	*/
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		let vc = viewController as! QuestContentViewController
		var index  = vc.pageIndex as Int
		if (index == 0 || index == NSNotFound) {
			return nil
		}
		index--
		return self.getViewControllerAtIndex(index)
	}
	
	/**
		Gets the view controller for the next page or nil if at last page
		
		- Parameters:
			pageViewController: the view controller responsible for managing the page layout.
		
		- Returns: view controller for the next page or nil
	
	*/
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		let vc = viewController as! QuestContentViewController
		var index = vc.pageIndex as Int
		if (index == NSNotFound){
			return nil
		}
		index++
		if (index == self.quests.count) {
			return nil
		}
		return self.getViewControllerAtIndex(index)
	}

	/**
		Set the number of pages in the page view
	
		- Parameters:
			pageViewController: the view controller responsible for managing the page layout.
	
		- Returns: total number of quests

	*/
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return self.quests.count
	}
	
	/**
		Returns the index of the selected item to be reflected in the page indicator.
		
		- Parameters:
			pageViewController: the view controlelr responsible for managing the page layout.
		- Returns: index of first item in the quests array i.e. 0
	
	*/
	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 0
	}
	
}