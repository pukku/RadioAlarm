//
//  RadioAlarmPlayer.swift
//  Radio Alarm
//
//  Created by Ricky Morse on 9/30/15.
//  Copyright © 2015 Ricky Morse. All rights reserved.
//

import Foundation;
import KDEAudioPlayer;

let kONE_DAY : NSTimeInterval = 60 * 60 * 24; // secs * mins * hours

struct RadioAlarmSettings {
    var date: NSDate;
    var station: String;
}

class RAP {
    static let si : RAP = RAP();
    
    let stations = [
        "WERS" : AudioItem(string:"http://www.wers.org/wers.pls"),
        "Classical New England" : AudioItem(string: "http://audio.wgbh.org/otherWaysToListen/classicalNewEngland.m3u"),
    ];
    var stations_order: [String] {
        return [String](stations.keys.sort());
    };
    
    let silences = [
        1: NSBundle.mainBundle().URLForResource("1", withExtension: "aiff"),
        5: NSBundle.mainBundle().URLForResource("5", withExtension: "aiff"),
        15: NSBundle.mainBundle().URLForResource("15", withExtension: "aiff"),
        30: NSBundle.mainBundle().URLForResource("30", withExtension: "aiff"),
        60: NSBundle.mainBundle().URLForResource("60", withExtension: "aiff"),
        120: NSBundle.mainBundle().URLForResource("120", withExtension: "aiff"),
    ];
    
    let player = AudioPlayer();
    var current: String?;
    
    func playStation(station: String) {
        player.stop(); // also clears the queue
        if let s = stations[station]! {
            player.playItem(s);
            current = station;
        }
    }
    
    func stop() {
        player.stop();
        current = nil;
    }
    
    func playSilenceForMinutes(min: Int, thenStation: String) {
        print("Play for \(min) minutes, then station \(thenStation)");
    }
}
