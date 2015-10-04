//
//  SetAlarmViewController.swift
//  Radio Alarm
//
//  Created by Ricky Morse on 9/26/15.
//  Copyright © 2015 Ricky Morse. All rights reserved.
//

import UIKit

class SetAlarmViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: Properties
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var stationPicker: UIPickerView!
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StartAlarm") {
            // determine the date by finding the next positive offset
            // corresponding to the time entered
            var date = timePicker.date;
            while(date.timeIntervalSinceNow > kONE_DAY) {
                // make sure the date isn't more than one day in the future
                date = date.dateByAddingTimeInterval(-kONE_DAY);
            }
            while(date.timeIntervalSinceNow < 0) {
                // make sure the date isn't in the past
                date = date.dateByAddingTimeInterval(kONE_DAY);
            }
            
            // get the current station
            let station = stationPicker.selectedRowInComponent(0);
            
            if let c = segue.destinationViewController as? AlarmViewController {
                c.alarmSettings = RadioAlarmSettings(date: date, station: station);
            }
        }
    }
    
    // the actual actions are handled in the AlarmViewController via a stop button action
    @IBAction func unwindFromAlarm(unwindSegue: UIStoryboardSegue) {}

    // MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return RAP.si.stations.count;
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // there is only one component, so we ignore that
        return RAP.si.stations[row]!.name;
    }

}

