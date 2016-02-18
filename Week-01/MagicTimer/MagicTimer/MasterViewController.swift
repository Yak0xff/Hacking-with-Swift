//
//  MasterViewController.swift
//  MagicTimer
//
//  Created by Robin on 2/17/16.
//  Copyright © 2016 Robin. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    var detailViewController: DetailViewController? = nil

    let titles = [
        "Using existing UILabel, stopwatch",
        "Self as label, free styling just like usual",
        "Countdown Timer",
        "Stopwatch with controls and time format",
        "Countdown timer with controls",
        "Countdown finish callback with Delegate",
        "Countdown finish callback with block",
        "Change color when time > 10 sec",
        "Custom Text return from delegate",
        "Modify Stopwatch time",
        "Modify Timer time",
        "Count beyond 23 hour limit of HH",
        "Countdown timer in text"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        self.title = "MagicTimer"
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
 

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  titles.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
 
        cell.textLabel?.text = "\(indexPath.row). " + titles[indexPath.row]
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let object = titles[indexPath.row]
        let controller = DetailViewController()
        controller.detailItem = object
        controller.timerIndex = indexPath.row
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

