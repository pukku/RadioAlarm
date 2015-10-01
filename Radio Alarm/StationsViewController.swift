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

        // hide the extra separator lines from extra rows
        self.tableView.tableFooterView = UIView();
    }

    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RAP.si.stations_order.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "StationsTableViewCell");
        //let station = globalStations[indexPath.row];
        
        let station_name = RAP.si.stations_order[indexPath.row];
        let station_url = String(RAP.si.stations[station_name]!!.mediumQualityURL.URL);
        
        cell.textLabel!.text = station_name;
        cell.detailTextLabel!.text = station_url;
        cell.imageView!.image = UIImage(named: "play");
        cell.selectionStyle = .Blue;
        
        return cell;
    }
    
    // MARK: UITableViewDelegate


}

