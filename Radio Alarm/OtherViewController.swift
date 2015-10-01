//
//  OtherViewController.swift
//  Radio Alarm
//
//  Created by Ricky Morse on 9/30/15.
//  Copyright © 2015 Ricky Morse. All rights reserved.
//

import UIKit

class OtherViewController: UIViewController {

    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    /* This is highly frowned upon by Apple. */
    @IBAction func quitPressed(sender: UIButton) {
        
        /*
         * the UIApplication shared instance will respond to some private selectors.
         * this is using a private API, and can never appear on the App Store.
         * See: http://stackoverflow.com/questions/355168/proper-way-to-exit-iphone-application
         * in particular:
         *      http://stackoverflow.com/a/17802404
         *      http://stackoverflow.com/a/1681100
         * because it is a private API, the UIApplication.terminateWithSuccess selector isn't
         * available via the type directly. Thus, we need to send it via the "performSelector" call.
         */
        
        RAP.si.stop();
        
        let app = UIApplication.sharedApplication();
        app.performSelector(Selector("suspend"));
        NSThread.sleepForTimeInterval(2.0);
        app.performSelector(Selector("terminateWithSuccess"));
    }

}
