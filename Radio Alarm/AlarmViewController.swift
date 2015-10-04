//
//  AlarmViewController.swift
//  Radio Alarm
//
//  Created by Ricky Morse on 9/30/15.
//  Copyright © 2015 Ricky Morse. All rights reserved.
//

import UIKit;
import AVFoundation;
import KDEAudioPlayer;

class AlarmViewController: UIViewController, AudioPlayerDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var powerImage: UIImageView!
    @IBOutlet weak var volumeImage: UIImageView!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var alarmSettings: RadioAlarmSettings?;
    
    let volumeObserverContext = UnsafeMutablePointer<Void>();
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (alarmSettings != nil) {
            // save the current settings
            RAP.si.save_alarm_settings(alarmSettings!);
            
            // set the labels appropriately
            timeLabel.text = NSDateFormatter.localizedStringFromDate(alarmSettings!.date, dateStyle: .NoStyle, timeStyle: .ShortStyle);
            stationLabel.text = RAP.si.stations[alarmSettings!.station].name;
            
            // register for notifications on battery changes
            UIDevice.currentDevice().batteryMonitoringEnabled = true;
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "batteryChanged:", name:UIDeviceBatteryLevelDidChangeNotification, object: nil);
            self.batteryChanged(nil);
            
            // observe volume changes; we can't use notification center, we need to do "kvo".
            // why can't they both have the same interface!
            AVAudioSession.sharedInstance().addObserver(self, forKeyPath: "outputVolume", options: .New, context: volumeObserverContext);

            // set the delegate so we get notifications of what we're playing
            RAP.si.player.delegate = self;
            
            // start the alarm playing
            let minsToAlarm = Int(alarmSettings!.date.timeIntervalSinceNow / 60); // seconds returned, need mins
            RAP.si.playSilenceForMinutes(minsToAlarm, thenStation: alarmSettings!.station);
        }
        else {
            timeLabel.text = "Error";
            stationLabel.text = "Error";
        }
    }

    // MARK: Actions
    
    @IBAction func stopPressed(sender: UIButton) {
        RAP.si.stop();
        RAP.si.player.delegate = nil;
        
        // @TODO: check to see if still observing anything and stop it
    }
    
    // MARK: Notifications
    
    func batteryChanged(notification: NSNotification?) {
        let currBattery = UIDevice.currentDevice().batteryState;
        if (currBattery == .Unplugged) {
            powerImage.backgroundColor = UIColor.redColor();
        }
        else {
            powerImage.backgroundColor = nil;
            UIDevice.currentDevice().batteryMonitoringEnabled = false;
            NSNotificationCenter.defaultCenter().removeObserver(self, name: UIDeviceBatteryLevelDidChangeNotification, object: nil);
        }
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == volumeObserverContext {
            if keyPath == "objectVolume" {
                let audioSession = AVAudioSession.sharedInstance();
                if (audioSession.outputVolume != 1.0) {
                    volumeImage.backgroundColor = UIColor.redColor();
                }
                else {
                    volumeImage.backgroundColor = nil;
                    audioSession.removeObserver(self, forKeyPath: "objectVolume");
                }
            }
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
