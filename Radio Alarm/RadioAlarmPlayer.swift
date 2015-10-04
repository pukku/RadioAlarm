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
        "WERS" : NamedAudioItem(name: "WERS", string:"http://www.wers.org/wers.pls"),
        "Classical New England" : NamedAudioItem(name: "Classical New England", string: "http://audio.wgbh.org/otherWaysToListen/classicalNewEngland.m3u"),
    ];
    var stations_order: [String] {
        return [String](stations.keys.sort());
    };
    
    let silences = [
        1: NamedAudioItem(name: "1 minute", url: NSBundle.mainBundle().URLForResource("1", withExtension: "aiff")),
        5: NamedAudioItem(name: "5 minutes", url: NSBundle.mainBundle().URLForResource("5", withExtension: "aiff")),
        15: NamedAudioItem(name: "15 minutes", url: NSBundle.mainBundle().URLForResource("15", withExtension: "aiff")),
        30: NamedAudioItem(name: "30 minutes", url: NSBundle.mainBundle().URLForResource("30", withExtension: "aiff")),
        60: NamedAudioItem(name: "1 hour", url: NSBundle.mainBundle().URLForResource("60", withExtension: "aiff")),
        120: NamedAudioItem(name: "2 hours", url: NSBundle.mainBundle().URLForResource("120", withExtension: "aiff")),
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

    /* build an array of silence sounds for the number of minutes specified, then
       add in a station, and then play */
    func playSilenceForMinutes(min: Int, thenStation station: String) {
        var avail = silences.keys.sort(>);
        var items = [NamedAudioItem]();
        var remaining = min;
        
        BUILD_SILENCE_ARRAY:
        while (remaining > 0) {
            while ((avail.count > 0) && (remaining < avail[0])) { avail.removeFirst(); }
            if (avail.isEmpty) { break BUILD_SILENCE_ARRAY; }
            items.append(silences[avail[0]]!!);
            remaining -= avail[0];
        }
        items.append(stations[station]!!);
        
        player.stop();
        player.playItems(items);
    }
}
