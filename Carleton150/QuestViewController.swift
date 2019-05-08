//
//  QuestViewController.swift
//  Carleton150
//

import UIKit
import SwiftOverlays

class QuestViewController: UIViewController, UIPageViewControllerDataSource{
	
	var pageViewController: UIPageViewController!
    var quests: [Quest] = []
	let locationManager: CLLocationManager = CLLocationManager()
    var timer: Timer!
    var shouldReload: Bool = false
    
    @IBAction func goBackOnePage(_ sender: AnyObject) {
        let currentController = pageViewController.viewControllers![0] as! QuestContentViewController
        let previousIndex = currentController.pageIndex - 1
        if previousIndex >= 0 {
            pageViewController.setViewControllers([self.getViewControllerAtIndex(previousIndex)], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func goForwardOnePage(_ sender: AnyObject) {
        let currentController = pageViewController.viewControllers![0] as! QuestContentViewController
        let nextIndex = currentController.pageIndex + 1
        if nextIndex < quests.count {
            pageViewController.setViewControllers([self.getViewControllerAtIndex(nextIndex)], direction: .forward, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var noDataButton: UIButton!
    @IBOutlet weak var warningSign: UIImageView!
    

	/**
		Upon load setup the persistent storage if it has not been setup already, request data for
		 quests. Once the data has been loaded, create the first page of the paged layout
	 */
    override func viewDidLoad() {
        self.noDataButton.isHidden = true
        self.warningSign.isHidden = true
		
		self.showWaitOverlay()
		
		// setting up data persistence 
		if UserDefaults.standard.object(forKey: "startedQuests") == nil {
			UserDefaults.standard.set(Dictionary<String,Int>(), forKey: "startedQuests")
		}
        
		Utils.setUpNavigationBar(self)
        
        self.getQuests()
        
        // triggers page to reload every 30 minutes
        timer = Timer.scheduledTimer(timeInterval: 1800, target: self, selector: #selector(self.setReload), userInfo: nil, repeats: true)

    }

    override func viewDidAppear(_ animated: Bool) {
        
        if shouldReload {
           self.getQuests()
        }
        
        if let coordinates = locationManager.location?.coordinate {
            if Utils.userOffCampus(coordinates) {
                let alert = UIAlertController(title: "",
                                              message: "The Quests feature is intended to be used on the Carleton College campus. Visit campus soon to embark on a Quest!",
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func setReload() {
        shouldReload = true
    }
   
    /**
        If the data is not available, give the user the option
        to try to get the data again.
     */
    @IBAction func getData(_ sender: AnyObject) {
        self.noDataButton.isHidden = true
        self.warningSign.isHidden = true
        self.showWaitOverlay()
        self.getQuests()
    }
    
    /**
        Get quests from the server.
     */
    func getQuests() {
		QuestDataService.getQuests() { (success, result) -> Void in
			if let quests = result {
				self.removeAllOverlays()
				self.quests = quests
				self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
				self.pageViewController.dataSource = self

				let startVC = self.getViewControllerAtIndex(0) as QuestContentViewController
				let viewControllers = NSArray(object: startVC)
				
				self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: true, completion: nil)
                self.addChild(self.pageViewController)
				self.view.addSubview(self.pageViewController.view)
                self.pageViewController.didMove(toParent: self)

            } else {
                self.noDataButton.isHidden = false
                self.warningSign.isHidden = false
                self.removeAllOverlays()
			}
		}
    }
	
	/**
		Fetches the appropriate UIViewController when swiping between pages. It creates a new
		instance of QuestContentViewController and sets the quest name, description, image and
		passes the quest to the QuestContentViewController
	
		- Parameters:
			index: integer used to fetch data from the quests array
	
		- Returns: UI View Controller
	
	 */
	func getViewControllerAtIndex(_ index: Int) -> QuestContentViewController {
		// if we're at the edges of the page view
		if ((self.quests.count == 0 ) || (index >= self.quests.count)) {
			return QuestContentViewController()
		}
		// create new page view
		let vc: QuestContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "QuestContentViewController") as! QuestContentViewController
		// set attributes of the new view
		vc.pageIndex = index
		vc.titleText = quests[index].name
		vc.descText = quests[index].questDescription
		vc.imageURL = quests[index].imageURL
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
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		let vc = viewController as! QuestContentViewController
		var index  = vc.pageIndex as Int
		if (index == 0 || index == NSNotFound) {
			return nil
		}
		index -= 1
		return self.getViewControllerAtIndex(index)
	}
	
	/**
		Gets the view controller for the next page or nil if at last page
		
		- Parameters:
			pageViewController: the view controller responsible for managing the page layout.
		
		- Returns: view controller for the next page or nil
	
	*/
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		let vc = viewController as! QuestContentViewController
		var index = vc.pageIndex as Int
		if (index == NSNotFound){
			return nil
		}
		index += 1
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
	func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return self.quests.count
	}
	
	/**
		Returns the index of the selected item to be reflected in the page indicator.
		
		- Parameters:
			pageViewController: the view controlelr responsible for managing the page layout.
		- Returns: index of first item in the quests array i.e. 0
	
	*/
	func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		return 0
	}
	
}
