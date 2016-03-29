//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


enum PlayerType {
    case Player
    case PlayerRecorder
}


// MARK: Jam Track Object

/**
 A jam track is composed of 0 or more trackObjects
 It has a key, to be used for cross reference to other containers, a title and date
  */

class JamTrack {
    var key: String?
    var title: String?
    var date: NSDate?
    var tracks = [TrackObject]()
}


/**
 A track object is a playable audio track from a URL
 It has a key, to be used for cross reference to other containers, a title and date
 It has a fileURL
 
 *startTime* where the track should start playing in the jam track
 */

class TrackObject {
    var key: String?
    var title: String?
    var date: NSDate?
    var startTime: Double? = 0.0
    var type: PlayerType?
    var fileURL: NSURL?
    var effects = [String]()
}


/**
 A JamSession is the active manipulation of a jamtrack
 */

class JamSession {
    var key: String?
    var title: String?
}

/**
 A TracksInsets contains information about insets to a full length audio
 This version of the Insets uses location from start and location from end
 
 */

struct TracksInsetsA {
    var startInset: Double = 0.0
    var endInset: Double = 0.0
    
}

/**
 A TracksInsets contains information about insets to a full length audio
 This version of the Insets uses location and Length
 
 */

struct TracksInsetsB {
    var startLocation: Double = 0.0 // in seconds
    var length: Double = 0.0  // in seconds
    
    
    
}

struct JWEffects {
    var title: String?
    
}

extension JWEffects {
    
}


protocol Playable {
    func play()
}


struct JamTrackP: Playable {
    
    func play() {
        
    }
    
}

