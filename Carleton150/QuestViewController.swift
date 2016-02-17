//
//  QuestViewController.swift
//  Carleton150
//

import UIKit

class QuestViewController: UIViewController, UIPageViewControllerDataSource{
	
	var quests = [Quest]()
	var curCellIndex: Int = 0
	
    override func viewDidLoad() {
		
		// Load Quests Data From the Server
		QuestDataService.requestQuest("", limit: 5, completion: { (success, result) -> Void in
			if let quests = result {
				
				self.quests = quests
				
			} else {
				// handle error gracefully here
			}
		});
		
	}
	
	func getViewControllerAtIndex(index: Int) -> ContentViewController {
		if ((self.quests.count == 0 ) || (index >= self.quests.count)) {
			return ContentViewController
		}
	}
	
	/**
	 * MARK: - Data Source
	 * UIPageViewControllerDataSource Methods
	**/
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		
	}

	
	
}