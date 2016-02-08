//
//  QuestCollectionViewController.swift
//  Carleton150

import UIKit

private let reuseIdentifier = "QuestCell"
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
let screenSize: CGRect = UIScreen.mainScreen().bounds

class QuestCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var quests: [Quest] = []
    let images: [UIImage] = [UIImage(named: "magical_mystery.jpg")!, UIImage(named: "let_it_be.jpg")!
        , UIImage(named: "Schiller.jpg")!]
	var curCellIndex: Int = 0
	
	@IBAction func startQuest(sender: AnyObject) {}
	
    /**
        Prepares for a segue to the quest view for a particular quest in the collection.
     
        Parameters: 
            - segue:  The segue that was triggered by the user. If this is not one of 
                      the quest start buttons, don't switch to anything.
     
            - sender: The sender, in our case, will be one of the buttons at the bottom 
                      of each quest description.
     */
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "questStartSegue" {
			let nextCtrl = (segue.destinationViewController as! QuestViewController)
            let currentIndex = (self.collectionView?.visibleCells()[0] as! QuestCollectionViewCell).questIndex
			nextCtrl.quest = self.quests[currentIndex]
		}
	}
	
    /**
        Upon load of this view, set logo and 
        request quests from the server.
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up properties for the navigation bar
        Utils.setUpNavigationBar(self)
        
        // get and store quests for presentation
		getQuests()
    }
    

    /**
        Request quest data from the server.
     */
	func getQuests() {
        QuestDataService.requestQuest("", limit: 5, completion: { (success, result) -> Void in
            if let quests = result {
                self.quests = quests
                self.collectionView!.reloadData()
            }
        });
	}
	
    /**
        Determine the number of sections (different than number of items)
        in the collection view.
     */
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
        Determine the amount of items in the collection view.
     */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quests.count
    }

    /**
        Builds the collection view, populating each cell.
     */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
	
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! QuestCollectionViewCell
        cell.sizeToFit()
    
		cell.backgroundColor = UIColor.whiteColor()
		cell.imageView.image = images[indexPath.row]
       // cell.imageView.frame = CGRect(x:, y:, width: screenSize.width*0.7, height: screenSize.height*0.35)
        cell.imageView.sizeThatFits(CGSize(width: screenSize.width*0.8, height: screenSize.height*0.35))
		cell.name.text = quests[indexPath.row].name
        cell.information.numberOfLines = 10
		cell.information.text = quests[indexPath.row].questDescription
		cell.questIndex = indexPath.row
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSizeMake(screenSize.width * 0.98, self.view.frame.size.height - (44+49))
//            return CGSizeMake(screenSize.width*0.98, screenSize.height*0.8)
    }
}
