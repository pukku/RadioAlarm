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
    
    var playingRow: NSIndexPath? = nil;
    
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
        return RAP.si.stations.count;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // we know there's only one section:
        return "Stations";
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "StationsTableViewCell");
        let station = RAP.si.stations[indexPath.row];
        
        cell.textLabel!.text = station.name;
        cell.detailTextLabel!.text = String(station.mediumQualityURL.URL);
        cell.imageView!.image = UIImage(named: "play");
        cell.selectionStyle = .Blue;
        
        return cell;
    }
    
    // MARK: UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath == playingRow) {
            // selected the already playing row, so stop it
            RAP.si.stop();
            RAP.si.player.delegate = nil;
            
            // reset the image and deselect the row
            let cell = tableView.cellForRowAtIndexPath(indexPath);
            cell?.imageView!.image = UIImage(named: "play");
            tableView.deselectRowAtIndexPath(indexPath, animated: false);
            
            // set the playing row to -1
            self.playingRow = nil;
        }
        else {
            // we're selecting a new row, so stop anything
            RAP.si.stop();
            
            // if there was a previously playing row, change its icon
            if (playingRow != nil) {
                let prevCell = tableView.cellForRowAtIndexPath(playingRow!);
                prevCell?.imageView!.image = UIImage(named: "play");
            }
            
            // start the new station
            RAP.si.player.delegate = self;
            RAP.si.playStation(indexPath.row);
            
            // set the new icon
            let cell = tableView.cellForRowAtIndexPath(indexPath);
            cell?.imageView!.image = UIImage(named: "stop");
            
            // update the playing row
            playingRow = indexPath;
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

