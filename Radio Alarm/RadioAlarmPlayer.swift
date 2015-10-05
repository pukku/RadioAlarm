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
    var station: Int;
}

class RAP {
    
    // MARK: singleton pattern
    static let si : RAP = RAP();
    
    // MARK: data items
    
    lazy var stations: [NamedAudioItem] = RAP.si.restore_stations();
    lazy var station_to_station_name: [String:Int] = {
        var name_to_index: [String:Int] = [:];
        for (index, item) in RAP.si.stations.enumerate() {
            name_to_index[item.name!] = index;
        }
        return name_to_index;
    }();
    
    let silences = [
          1: NamedAudioItem(name: "1 minute", url: NSBundle.mainBundle().URLForResource("1", withExtension: "aiff")),
          5: NamedAudioItem(name: "5 minutes", url: NSBundle.mainBundle().URLForResource("5", withExtension: "aiff")),
         15: NamedAudioItem(name: "15 minutes", url: NSBundle.mainBundle().URLForResource("15", withExtension: "aiff")),
         30: NamedAudioItem(name: "30 minutes", url: NSBundle.mainBundle().URLForResource("30", withExtension: "aiff")),
         60: NamedAudioItem(name: "1 hour", url: NSBundle.mainBundle().URLForResource("60", withExtension: "aiff")),
        120: NamedAudioItem(name: "2 hours", url: NSBundle.mainBundle().URLForResource("120", withExtension: "aiff")),
    ];
    
    var player = AudioPlayer();

    // MARK: player interaction
    
    func playStation(station: Int) {
        player.stop(); // also clears the queue
        if (station < stations.count) {
            player.playItem(stations[station]);
        }
    }
    
    func stop() {
        player.stop();
    }

    /* build an array of silence sounds for the number of minutes specified, then
       add in a station, and then play */
    func playSilenceForMinutes(min: Int, thenStation station: Int) {
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
        
        if (station < stations.count) {
            items.append(stations[station]);
        }
        else {
            // @TODO: add an alarm sound to bundle, add it here as a fallback
        }
        
        player.stop();
        player.playItems(items);
    }
    
    // MARK: NSUserDefaults interactions
    
    func restore_stations() -> [NamedAudioItem] {
        var items = [NamedAudioItem]();
        
        let defaultsData = NSUserDefaults.standardUserDefaults().dictionaryForKey("stations");
        if defaultsData != nil {
            for (station, url) in defaultsData as! [String: String] {
                items.append(NamedAudioItem(name: station, string: url)!);
            }
        }
        
        items.sortInPlace { $0.name < $1.name };
        
        return items;
    }
    func save_stations() {
        var items = [String: String]();
        
        for station in stations {
            items[station.name!] = String(station.highestQualityURL.URL) ?? "";
        }
        
        NSUserDefaults.standardUserDefaults().setObject(items, forKey: "stations");
    }

    func read_alarm_settings() -> RadioAlarmSettings {
        var settings = NSUserDefaults.standardUserDefaults().dictionaryForKey("settings") as! [String : String];
        
        // retrieve the station name and convert into the station number
        let stationName = settings["station"] ?? RAP.si.stations[0].name;
        let station = RAP.si.station_to_station_name[stationName!]!;
        
        // use a date formatter to take the time string, append it to today's date
        // and then turn it back into a date; if that doesn't work, just use the current date
        // yes, this sucks; iOS doesn't do "time" really well
        let formatter = NSDateFormatter();
        formatter.dateFormat = "YYYY'-'MM'-'dd";
        let dateString = formatter.stringFromDate(NSDate());
        let timeString = settings["time"]!;
        let dateTimeString = dateString + "T" + timeString;
        formatter.dateFormat = "YYYY'-'MM'-'dd'T'HH':'mm";
        let date = formatter.dateFromString(dateTimeString) ?? NSDate();
        
        return RadioAlarmSettings(date: date, station: station);
    }
    func save_alarm_settings(settings: RadioAlarmSettings) {
        // turn the station number into a station name
        let stationName = stations[settings.station].name;
        
        // turn the date into a time string
        let formatter = NSDateFormatter();
        formatter.dateFormat = "HH':'mm";
        let timeString = formatter.stringFromDate(settings.date);
        
        var settings = [String: String]();
        settings["station"] = stationName;
        settings["time"] = timeString;
        
        NSUserDefaults.standardUserDefaults().setObject(settings, forKey: "settings");
    }
}
