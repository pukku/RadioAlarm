//
//  StationsViewController.swift
//  Radio Alarm
//
//  Created by Ricky Morse on 9/26/15.
//  Copyright © 2015 Ricky Morse. All rights reserved.
//

import UIKit;
import KDEAudioPlayer;

class StationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AudioPlayerDelegate {

    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var statusLabel: UILabel!
    
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // we know there's only one section:
        return "Stations";
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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let station_name = RAP.si.stations_order[indexPath.row];
        let cell = tableView.cellForRowAtIndexPath(indexPath);
        
        if station_name == RAP.si.current {
            // if the station is currently playing, stop it.
            RAP.si.stop();
            RAP.si.player.delegate = nil;
            
            cell?.imageView!.image = UIImage(named: "play");
            tableView.deselectRowAtIndexPath(indexPath, animated: false);
        }
        else {
            // else, start it
            RAP.si.stop();
            RAP.si.player.delegate = self;
            RAP.si.playStation(station_name);
            
            cell?.imageView!.image = UIImage(named: "stop");
        }
    }
    
    // MARK: AudioPlayerDelegate
    
    func audioPlayer(audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, toState to: AudioPlayerState) {
        if to == .Stopped {
            statusLabel.text = "\(to)";
        }
        else if let currItem = audioPlayer.currentItem as? NamedAudioItem {
            statusLabel.text = "\(to): \(currItem.name!)";
        }
        else {
            statusLabel.text = "\(to)";
        }
    }
    func audioPlayer(audioPlayer: AudioPlayer, willStartPlayingItem item: AudioItem) {}
    func audioPlayer(audioPlayer: AudioPlayer, didFindDuration duration: NSTimeInterval, forItem item: AudioItem) {}
    func audioPlayer(audioPlayer: AudioPlayer, didUpdateProgressionToTime time: NSTimeInterval, percentageRead: Float) {}

}

