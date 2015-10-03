//
//  KDEAudioPlayerExtension.swift
//  Radio Alarm
//
//  Created by Ricky Morse on 9/30/15.
//  Copyright © 2015 Ricky Morse. All rights reserved.
//

import Foundation;
import KDEAudioPlayer;

extension AudioItem {
    convenience init?(url: NSURL? = nil) {
        self.init(mediumQualitySoundURL: url);
    }
    
    convenience init?(string: String? = nil) {
        self.init(url: NSURL(string: string!));
    }
}

// allow me to create an AudioItem with a proper name
public class NamedAudioItem: AudioItem {
    public var name: String?
    
    public init?(name: String, url: NSURL?) {
        var URLs = [AudioQuality: NSURL]()
        URLs[.Medium] = url;
        super.init(soundURLs: URLs);
        
        self.name = name;
    }
    public convenience init?(name: String, string: String) {
        self.init(name: name, url: NSURL(string: string));
    }
}