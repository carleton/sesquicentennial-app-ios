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
    var eventsGroup = dispatch_group_create()
    var refreshControl:UIRefreshControl!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        DataService.requestEvents(NSDate(), limit: 5, completion: {
            (success: Bool, result: [Dictionary<String, String>]?) in
            print(result)
            self.schedule = result!
            //dispatch_group_leave(self.eventsGroup)
        });
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        //dispatch_group_enter(eventsGroup)
        
    }
    func refresh(indexPath:NSIndexPath){
        DataService.requestEvents(NSDate(), limit: 5, completion: {
            (success: Bool, result: [Dictionary<String, String>]?) in
            print(result)
            self.schedule = result!
            //dispatch_group_leave(self.eventsGroup)
        });

        self.tableView.reloadData()
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
        return 3
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func basicCellAtIndexPath(indexPath:NSIndexPath) -> BasicCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(basicCellIdentifier) as! BasicCell
        //dispatch_group_wait(self.eventsGroup, DISPATCH_TIME_FOREVER)
        settitleLabelForCell(cell, indexPath: indexPath)
        setDateForCell(cell, indexPath: indexPath)
        setDescriptionForCell(cell, indexPath: indexPath)
        return cell
    }
    
    
        
    func settitleLabelForCell(cell: BasicCell, indexPath:NSIndexPath) {
        
        if self.schedule.isEmpty{
            cell.titleLabel.text = ""
        }
        else{
            let item = self.schedule[indexPath.row]["title"]
            cell.titleLabel.text = item as String!
        }
    }
    func setDateForCell(cell: BasicCell, indexPath:NSIndexPath) {
        if self.schedule.isEmpty{
            cell.Date.text = ""
        }
        else{
            let item = self.schedule[indexPath.row]["startTime"]
            cell.Date.text = item as String!
        }
    }
    
    func setDescriptionForCell(cell: BasicCell, indexPath:NSIndexPath) {
        
        
        
        //if subtitle != " " {
            
            // Some subtitles are really long, so only display the first 200 characters
            //if subtitle.characters.count > 200 {
               // cell.Description.text = "\(subtitle.substringToIndex(200))..."
                
            //} else {
        if self.schedule.isEmpty{
            cell.Description.text = ""
        }
        else{
            let item = self.schedule[indexPath.row]["description"]
            cell.Description.text = item as String!
        }
            //}
            
        //} else {
            //cell.Description.text = ""
        //}
    }
    
}