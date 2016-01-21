//
//  QuestCollectionViewController.swift
//  Carleton150

import UIKit

private let reuseIdentifier = "QuestCell"
private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

class QuestCollectionViewController: UICollectionViewController {

    var quests: [Quest] = []
    let images: [UIImage] = [UIImage(named: "magical_mystery.jpg")!, UIImage(named: "let_it_be.jpg")!]
	var curCellIndex: Int = 0
	
	@IBAction func startQuest(sender: AnyObject) {}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "questStartSegue" {
			let nextCtrl = (segue.destinationViewController as! QuestViewController)
            let currentIndex = (self.collectionView?.visibleCells()[0] as! QuestCollectionViewCell).questIndex
			nextCtrl.quest = self.quests[currentIndex]
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		getQuests()
    }

	func getQuests() {
        DataService.requestQuest("", limit: 5, completion: { (success, result) -> Void in
            if let quests = result {
                self.quests = quests
                self.collectionView!.reloadData()
            }
        });
	}
	
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quests.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
	
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! QuestCollectionViewCell
		cell.backgroundColor = UIColor.whiteColor()
		cell.imageView.image = images[indexPath.row]
		cell.name.text = quests[indexPath.row].name
        cell.information.numberOfLines = 10
		cell.information.text = quests[indexPath.row].questDescription
		cell.questIndex = indexPath.row
        return cell
    }
}
