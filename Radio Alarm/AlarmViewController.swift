//
//  AlarmViewController.swift
//  Radio Alarm
//
//  Created by Ricky Morse on 9/30/15.
//  Copyright © 2015 Ricky Morse. All rights reserved.
//

import UIKit;
import AVFoundation;

class AlarmViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var powerView: UIView!
    @IBOutlet weak var volumeView: UIView!
    
    var alarmSettings: RadioAlarmSettings?;

    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (alarmSettings != nil) {
            timeLabel.text = NSDateFormatter.localizedStringFromDate(alarmSettings!.date, dateStyle: .NoStyle, timeStyle: .ShortStyle);
            stationLabel.text = alarmSettings!.station;
            
            // power managing
            UIDevice.currentDevice().batteryMonitoringEnabled = true;
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "batteryChanged:", name:UIDeviceBatteryLevelDidChangeNotification, object: nil);
            
            let vol = AVAudioSession.sharedInstance().outputVolume;
            print("\(vol)");
        }
    }

    // MARK: Actions
    
    @IBAction func stopPressed(sender: UIButton) {
        print("stop!");
    }
    
    // MARK: Notification center
    
    func batteryChanged(notification: NSNotification) {
        print("\(notification)");
    }

}
