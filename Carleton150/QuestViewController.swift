//
//  QuestViewController.swift
//  Carleton150
//

import UIKit

class QuestViewController: UIViewController, UIPageViewControllerDataSource{
	
	var pageViewController: UIPageViewController!
	var quests = [Quest]()

	
	/**
	 Upon load setup the persistent storage if it has not been setup already, request data for
	 quests. Once the data has been loaded, create the first page of the paged layout
	*/
    override func viewDidLoad() {
		
		// setting up data persistence 
		if NSUserDefaults.standardUserDefaults().arrayForKey("startedQuests") == nil {
			NSUserDefaults.standardUserDefaults().setObject(Dictionary<String,Int>(), forKey: "startedQuests")
		}
		
		Utils.setUpNavigationBar(self)
		
		/**
		 * Request data from the server
		 */
		QuestDataService.requestQuest("", limit: 5, completion: { (success, result) -> Void in
			if let quests = result {
		
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
	
		Parameters:
			- index: integer used to fetch data from the quests array
	
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
		vc.quest = quests[index]
		return vc
	}
	
	/**
	 * MARK: - Data Source
	 * UIPageViewControllerDataSource Methods
	**/
	
	/**
		Prepares for a segue to the detail view for a particular point of
		interest on the map.
		
		Parameters:
		- segue:  The segue that was triggered by user. If this is not the
		segue to the landmarkDetail view, then don't perform the
		segue.
		
		- sender: The sender, in our case, will be one of the Google Maps markers
		that was pressed, which will in turn have data associated with
		it that will given to the landmark detail view.
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
	Prepares for a segue to the detail view for a particular point of
	interest on the map.
	
	Parameters:
	- segue:  The segue that was triggered by user. If this is not the
	segue to the landmarkDetail view, then don't perform the
	segue.
	
	- sender: The sender, in our case, will be one of the Google Maps markers
	that was pressed, which will in turn have data associated with
	it that will given to the landmark detail view.
	
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
	Prepares for a segue to the detail view for a particular point of
	interest on the map.
	
	Parameters:
	- segue:  The segue that was triggered by user. If this is not the
	segue to the landmarkDetail view, then don't perform the
	segue.
	
	- sender: The sender, in our case, will be one of the Google Maps markers
	that was pressed, which will in turn have data associated with
	it that will given to the landmark detail view.
	
	*/
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return self.quests.count
	}
	
	/**
	Prepares for a segue to the detail view for a particular point of
	interest on the map.
	
	Parameters:
	- segue:  The segue that was triggered by user. If this is not the
	segue to the landmarkDetail view, then don't perform the
	segue.
	
	- sender: The sender, in our case, will be one of the Google Maps markers
	that was pressed, which will in turn have data associated with
	it that will given to the landmark detail view.
	
	*/
	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 0
	}
	
}