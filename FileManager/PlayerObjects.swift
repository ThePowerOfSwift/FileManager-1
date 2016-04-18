//
//  PlayerObjects.swift
//  FileManager
//
//  Created by JOSEPH KERR on 3/23/16.
//  Copyright © 2016 JOSEPH KERR. All rights reserved.
//

import Foundation


enum PlayerType {
    case Player
    case PlayerRecorder
}


// MARK: Jam Track Object

/**
A jam track is composed of 0 or more trackObjects
It has a key, to be used for cross reference to other containers, a title and date

*/

class JamTrack: NSObject, NSCoding {
    var key: String?
    var title: String?
    var date: NSDate?
    var tracks = [TrackObject]()
    
    override init () {
        
    }
    
    
    // MARK: Types
    
    struct propertyKey {
        static let key = "key"
        static let titleKey = "title"
        static let dateKey = "date"
        static let tracksKey = "tracks"
        
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(key, forKey: propertyKey.key)
        aCoder.encodeObject(title, forKey: propertyKey.titleKey)
        aCoder.encodeObject(date, forKey: propertyKey.dateKey)
        aCoder.encodeObject(tracks, forKey: propertyKey.tracksKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        if let jamKey = aDecoder.decodeObjectForKey(propertyKey.key) as? String {
            self.key = jamKey
        }
        
        if let jamTitle = aDecoder.decodeObjectForKey(propertyKey.titleKey) as? String {
            title = jamTitle
        }
        
        if let jamDate = aDecoder.decodeObjectForKey(propertyKey.dateKey) as? NSDate {
            date = jamDate
        }
        
        if let jamTracks = aDecoder.decodeObjectForKey(propertyKey.tracksKey) as? [TrackObject] {
            tracks = jamTracks
        }
    }
    
}

// MARK: Track Object

/**
 A track object is a playable audio track from a URL
 It has a key, to be used for cross reference to other containers, a title and date
 It has a fileURL
 
 */

class TrackObject: NSObject, NSCoding {
    var key: String?
    var title: String?
    var startTime: Double? = 0.0
    var date: NSDate?
    var type: PlayerType?
    var fileURL: NSURL?
    var effects = [String]()
    
    
    override init () {
        self.type = .Player
        //            self.key = NSUUID().UUIDString
    }
    
    init (_ playerType: PlayerType) {
        self.type = playerType
        //            self.key = NSUUID().UUIDString
        
    }
    
    convenience init (_ playerType: PlayerType, fileURL: NSURL) {
        self.init(playerType)
        self.fileURL = fileURL
    }
    
    // MARK: Types
    
    struct propertyKey {
        static let key = "key"
        static let titleKey = "title"
        static let starTimeKey = "startTime"
        static let dateKey = "date"
        static let typeKey = "type"
        static let fileURLKey = "fileURL"
        static let effectsKey = "effects"
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(key, forKey: propertyKey.key)
        aCoder.encodeObject(title, forKey: propertyKey.titleKey)
        aCoder.encodeDouble(startTime!, forKey: propertyKey.starTimeKey)
        aCoder.encodeObject(date, forKey: propertyKey.dateKey)
        aCoder.encodeObject(fileURL, forKey: propertyKey.fileURLKey)
        aCoder.encodeObject(effects, forKey: propertyKey.effectsKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        self.init()
        
        if let trackKey = aDecoder.decodeObjectForKey(propertyKey.key) as? String {
            key = trackKey
        }
        
        if let trackTitle = aDecoder.decodeObjectForKey(propertyKey.titleKey) as? String {
            title = trackTitle
        }
        
        let trackStartTime = aDecoder.decodeDoubleForKey(propertyKey.starTimeKey)
        startTime = trackStartTime
        
        if let trackDate = aDecoder.decodeObjectForKey(propertyKey.dateKey) as? NSDate {
            date = trackDate
        }
        
        if let trackFileURL = aDecoder.decodeObjectForKey(propertyKey.fileURLKey) as? NSURL {
            // TODO: reconnect to documents
            
            
            fileURL = trackFileURL
        }
        
        if let effectsForTrack = aDecoder.decodeObjectForKey(propertyKey.dateKey) as? [String] {
            effects = effectsForTrack
        }
        
    }
    
}

