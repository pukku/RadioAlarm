//
//  StationsViewController.swift
//  Radio Alarm
//
//  Created by Ricky Morse on 9/26/15.
//  Copyright © 2015 Ricky Morse. All rights reserved.
//

import UIKit

class StationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "StationTableViewCell");
        //let station = globalStations[indexPath.row];
        
        cell.textLabel!.text = "Test";
        cell.detailTextLabel!.text = "Bar";
        cell.selectionStyle = .Blue;
        
        return cell;
    }
    
    // MARK: UITableViewDelegate


}

