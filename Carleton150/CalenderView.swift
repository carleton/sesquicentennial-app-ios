//
//  CalenderView.swift
//  Carleton150
//
//  Created by Sherry Gu on 1/12/16.
//  Copyright © 2016 edu.carleton.carleton150. All rights reserved.
//

import Foundation

class CalenderView: UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var events: UILabel!
    @IBOutlet var tableView: UITableView!
    let basicCellIdentifier = "BasicCell"
    
    var schedule : [Dictionary<String, String>] = []
    var tableLimit : Int!
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        getCalendar(20, date: NSDate())
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
    }
    
    func getCalendar(limit: Int, date: NSDate?) {
        
        self.tableLimit = limit
        
        if let desiredDate = date {
            DataService.requestEvents(desiredDate, limit: limit, completion: {
                (success: Bool, result: [Dictionary<String, String>]?) in
                self.schedule = result!
                self.tableView.reloadData()
            });
        } else {
            DataService.requestEvents(NSDate(), limit: limit, completion: {
                (success: Bool, result: [Dictionary<String, String>]?) in
                self.schedule = result!
                self.tableView.reloadData()
            });
        }
    }
    
    func refresh(indexPath : NSIndexPath){
        getCalendar(20, date: NSDate())
        self.refreshControl.endRefreshing()
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400.0
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return basicCellAtIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableLimit
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func basicCellAtIndexPath(indexPath: NSIndexPath) -> BasicCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(basicCellIdentifier) as! BasicCell
        settitleLabelForCell(cell, indexPath: indexPath)
        setDateForCell(cell, indexPath: indexPath)
        setDescriptionForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func settitleLabelForCell(cell: BasicCell, indexPath: NSIndexPath) {
        if self.schedule.isEmpty {
            cell.titleLabel.text = ""
        }
        else {
            let item = self.schedule[indexPath.row]["title"]
            cell.titleLabel.text = item as String!
        }
    }
    
    func setDateForCell(cell: BasicCell, indexPath: NSIndexPath) {
        if self.schedule.isEmpty {
            cell.Date.text = ""
        }
        else {
            let item = self.schedule[indexPath.row]["startTime"]
            cell.Date.text = item as String!
        }
    }
    
    func setDescriptionForCell(cell: BasicCell, indexPath: NSIndexPath) {
        if self.schedule.isEmpty {
            cell.Description.text = ""
        }
        else {
            let item = self.schedule[indexPath.row]["description"]
            cell.Description.text = item as String!
        }
    }
}