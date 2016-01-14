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
    
    var schedule=[["Jan 13th","name","description"],["Jan 13th","name","description"],["Jan 13th","name","description"],["Jan 13th","name","description"],["Jan 13th","name","description"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        

        
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
        settitleLabelForCell(cell, indexPath: indexPath)
        setDescriptionForCell(cell, indexPath: indexPath)
        return cell
    }
    
    func settitleLabelForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let item = schedule[indexPath.row][1]
        cell.titleLabel.text = item
    }
    func setDateForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let item = schedule[indexPath.row][0]
        cell.titleLabel.text = item
    }
    
    func setDescriptionForCell(cell:BasicCell, indexPath:NSIndexPath) {
        let subtitle = schedule[indexPath.row][2]
        
        
        //if subtitle != " " {
            
            // Some subtitles are really long, so only display the first 200 characters
            //if subtitle.characters.count > 200 {
               // cell.Description.text = "\(subtitle.substringToIndex(200))..."
                
            //} else {
        cell.Description.text = subtitle as String
            //}
            
        //} else {
            //cell.Description.text = ""
        //}
    }
    
}