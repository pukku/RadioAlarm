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