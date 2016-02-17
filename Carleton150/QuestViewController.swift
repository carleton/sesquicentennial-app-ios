//
//  QuestViewController.swift
//  Carleton150
//

import UIKit

class QuestViewController: UIViewController, UIPageViewControllerDataSource{
	
	var pageViewController: UIPageViewController!
	
	var quests = [Quest]()
	var curCellIndex: Int = 0

    override func viewDidLoad() {
		
//		Utils.setUpNavigationBar(self)

		// Load Quests Data From the Server
		QuestDataService.requestQuest("", limit: 5, completion: { (success, result) -> Void in
			if let quests = result {
				
				self.quests = quests

				self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
				self.pageViewController.dataSource = self
				
				let startVC = self.getViewControllerAtIndex(0) as QuestContentViewController
				let viewControllers = NSArray(object: startVC)
				
				self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
				self.pageViewController.view.frame = CGRectMake(0,30,self.view.frame.width, self.view.frame.size.height - 60)
				
				self.addChildViewController(self.pageViewController)
				self.view.addSubview(self.pageViewController.view)
				self.pageViewController.didMoveToParentViewController(self)
				
			} else {
				// handle error gracefully here
			}
		});
		
	}
	
	
	/**
	 * This Function Gets You The Appropriate View Controller
	 *	
	 *	Params:
	 *		- index
	 *
	 *	Return:
	 *		-
	 **/
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
		return vc
	}
	
	/**
	 * MARK: - Data Source
	 * UIPageViewControllerDataSource Methods
	**/
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		let vc = viewController as! QuestContentViewController
		var index  = vc.pageIndex as Int
		if (index == 0 || index == NSNotFound) {
			return nil
		}
		index--
		return self.getViewControllerAtIndex(index)
	}
	
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

	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return self.quests.count
	}
	
	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 0
	}
	
}