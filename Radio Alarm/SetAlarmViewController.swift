//
//  SecondViewController.swift
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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1;
    }
    
    // MARK: UIPickerViewDelegate

}

