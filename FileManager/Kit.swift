//
//  Kit.swift
//  FileManager
//
//  Created by JOSEPH KERR on 3/24/16.
//  Copyright © 2016 JOSEPH KERR. All rights reserved.
//

import UIKit
import AVFoundation

// http: //stackoverflow.com/questions/26742138/singleton-in-swift

class ImageCache : NSCache {
    static let sharedManager = ImageCache()
    
    private var observer: NSObjectProtocol!
    
    override init() {
        super.init()
        
        observer = NSNotificationCenter.defaultCenter().addObserverForName(
        UIApplicationDidReceiveMemoryWarningNotification, object: nil, queue: nil) { [unowned self] notification in
            self.removeAllObjects()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(observer)
    }
}




struct FileInfo {
    var name: String
    var date: NSDate
    var url: NSURL
    var size: UInt64
    var duration: Double // length in seconds
}

//use it as follows:
//ImageCache.sharedManager.setObject(image, forKey: "foo")
//let image = ImageCache.sharedManager.objectForKey("foo") as? UIImage


/**
 A Singleton, Reads contents of specified directories
 Stores results in arrays
 */

class FileController {
    private static let sharedInstance = FileController()
    class var sharedManager : FileController {
        return sharedInstance
    }
    
    
    // MARK: Types
    
    enum SortType {
        case SortNone
        case SortRecentsFirst
        case SortRecentsLast
        case SortSizeAscending
        case SortSizeDescending
    }
    
    // MARK: Properties

    let sortType: SortType = .SortRecentsFirst
    
    var audioFilesMP3Files: [FileInfo]?
    var audioFilesSourceFiles: [FileInfo]?
    var audioFilesTrimmedFiles: [FileInfo]?
    var audioFilesRecordedFiles: [FileInfo]?

    let sourceAudioFilesDirectoryPath = DocumentsDirectory.URLByAppendingPathComponent("Source")
    let jamTracksDirectoryPath = DocumentsDirectory.URLByAppendingPathComponent("JamTracks")
    let jamTracksDownloadedDirectoryPath = DocumentsDirectory.URLByAppendingPathComponent("JamTrackDownloads")
    let downloadsDirectoryPath = DocumentsDirectory.URLByAppendingPathComponent("Downloads")
    let trashDirectoryPath = DocumentsDirectory.URLByAppendingPathComponent(".trash")
    let inBoxDirectoryPath = DocumentsDirectory.URLByAppendingPathComponent("InBox")
    
    let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let DocumentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!

    // MARK: Methods

    /**
     Activates the file controller and initializes the db
     */
    func activate() {
        // TODO: initialize if needed
        
        initdb()
        copyResources()
        loadData()
    }
    
    
    // MARK: load data

    /**
     Gets file data for target Directory
     */

    private func loadData() {
        
        let fm = NSFileManager()
        
        let tragetDirectory = documentsDirectory as NSURL
        
        let resourceKeys = [NSURLNameKey, NSURLIsDirectoryKey, NSURLCreationDateKey,NSURLContentAccessDateKey]
        
        let directoryEnumerator = fm.enumeratorAtURL(tragetDirectory, includingPropertiesForKeys: resourceKeys, options: [.SkipsHiddenFiles], errorHandler: nil)!
        
        //        var fileURLs: [NSURL] = []
        
        var fileInfos: [FileInfo] = []
        
        var collectTrimmedFiles = [FileInfo]()
        var collectMP3Files = [FileInfo]()
        var collectClipFiles = [FileInfo]()
        var collectOtherFiles = [FileInfo]()
        var collectRecordingFiles = [FileInfo]()
        
        for case let fileURL as NSURL in directoryEnumerator {
            
            guard let resourceValues = try? fileURL.resourceValuesForKeys(resourceKeys),
                let isDirectory = resourceValues[NSURLIsDirectoryKey] as? Bool,
                let name = resourceValues[NSURLNameKey] as? String,
                let createDate = resourceValues[NSURLCreationDateKey] as? NSDate
                else {
                    continue
            }
            
            if isDirectory {
//                if name == "_extras" {
//                    directoryEnumerator.skipDescendants()
//                }
                directoryEnumerator.skipDescendants()

                
            } else {
                
                // Skip files
                if name.hasPrefix("mp3file_") {
                    //continue
                } else if name.hasPrefix("mp3") {
                    // continue
                } else if name.hasPrefix("recording_")  || name.hasPrefix("avrec_") {
                    // continue
                } else if name.hasPrefix("trimmed") {
                    //continue
                } else if name.hasPrefix("final") {
                    //continue
                } else if name.hasPrefix("clip") {
                    //continue
                }

                // Proceed to collect file information
                
                var fileSize : UInt64 = 0
                
                do {
                    let attr : NSDictionary? = try NSFileManager.defaultManager().attributesOfItemAtPath(fileURL.path!)
                    
                    if let _attr = attr {
                        fileSize = _attr.fileSize()
                    }
                } catch {
                    print("Error: \(error)")
                }
                
                
                let fileData = FileInfo(name: name, date: createDate, url: fileURL, size: fileSize, duration: 0.0)
                
                if name.hasPrefix("mp3file_") {
                    collectMP3Files += [fileData]
                } else if name.hasPrefix("mp3") {
                    collectMP3Files += [fileData]
                } else if name.hasPrefix("recording_")  || name.hasPrefix("avrec_") {
                    collectRecordingFiles += [fileData]
                } else if name.hasPrefix("trimmed") {
                    collectTrimmedFiles += [fileData]
                } else if name.hasPrefix("final") {
                    collectOtherFiles += [fileData]
                } else if name.hasPrefix("clip") {
                    collectClipFiles += [fileData]
                } else {
                    collectOtherFiles += [fileData]
                }
                
                fileInfos.append(fileData)
                
            }
        }
        
        // Critical Section - all files have been read and are ready for sort and filter
        // Possibly background

        
        // All files in Directory processed
        
        // FileData Assignments
        
        audioFilesTrimmedFiles = collectTrimmedFiles
        
        audioFilesMP3Files = collectMP3Files
        
        
        // Other files includes source files
        // Source files are ones with audio extensions

        //audioFilesSourceFiles = collectOtherFiles
        //collectOtherFiles.filter(<#T##includeElement: (FileController.FileInfo) throws -> Bool##(FileController.FileInfo) throws -> Bool#>)
        
        // FILTER
        
//        audioFilesSourceFiles = collectOtherFiles.filter(){
//            if $0.name.hasSuffix(".mp3") || $0.name.hasSuffix(".caf") || $0.name.hasSuffix(".m4a") {
//                return true
//            } else {
//                return false
//            }
//        }

//        // FILTER and Sort
//        audioFilesSourceFiles =
//            collectOtherFiles.filter( {
//                
//                if $0.name.hasSuffix(".mp3") || $0.name.hasSuffix(".caf") || $0.name.hasSuffix(".m4a") {
//                    return true
//                } else {
//                    return false
//                }
//                }
//                ).sort({ (finfoFirst: FileInfo, finfoSecond: FileInfo) -> Bool in
//                  
//                    let cresult: NSComparisonResult = finfoFirst.date.compare(finfoSecond.date)
//                    
//                    // simple date compare cause recents last
//                    // recents first, Descending
//                    if cresult == .OrderedDescending {
//                        // first is later in time than second, isOrdered Before
//                        // left is greater
//                        return true
//                    }
////                    // recents last
////                    if cresult == .OrderedAscending {
////                        // first is earlier in time than second, isOrdered Before
////                        // left is smaller
////                        return true
////                    }
//
//                    // is NOT Ordered Before
//                    return false
//                })
        
        
        
        audioFilesSourceFiles =
            collectOtherFiles.filter {
                if $0.name.hasSuffix(".mp3") || $0.name.hasSuffix(".caf") || $0.name.hasSuffix(".m4a") {
                    return true
                } else {
                    return false
                }
                }
                .sort { (finfoFirst: FileInfo, finfoSecond: FileInfo) -> Bool in
                    
                    let cresult: NSComparisonResult = finfoFirst.date.compare(finfoSecond.date)
                    // recents first, Descending
                    if sortType == .SortRecentsFirst {
                        if cresult == .OrderedDescending {
                            // first is later in time than second, isOrdered Before
                            // left is greater
                            return true
                        }
                    } else if sortType == .SortRecentsLast {
                        if cresult == .OrderedAscending {
                            //  first is earlier in time than second, isOrdered Before
                            //  left is smaller
                            return true
                        }
                    }
                    
                    // is NOT Ordered Before
                    return false
        }
                
//                .map(<#T##transform: (FileInfo) throws -> T##(FileInfo) throws -> T#>)
//                .map {
//                    $0.duration = audioLengthForFile($0.url)
//                    return $0
//                }
        
        for index in 0..<audioFilesSourceFiles!.count {
            var file = audioFilesSourceFiles![index]
            
            file.duration = audioLengthForFile(file.url)
            
            audioFilesSourceFiles![index]=file
        }
        

        // RECORDED AUDIO FILES
        
        //collectClipFiles.sort(<#T##isOrderedBefore: (FileController.FileInfo, FileController.FileInfo) -> Bool##(FileController.FileInfo, FileController.FileInfo) -> Bool#>)
        
//        collectClipFiles.sort { (<#FileController.FileInfo#>, <#FileController.FileInfo#>) -> Bool in
//            <#code#>
//        }
        

        // SORT Date
        audioFilesRecordedFiles = collectClipFiles.sort { (finfoFirst: FileInfo, finfoSecond: FileInfo) -> Bool in
            
            let cresult: NSComparisonResult = finfoFirst.date.compare(finfoSecond.date)
            
            // simple date compare cause recents last
//            // recents first
//            if cresult == .OrderedDescending {
//                // first is later in time than second, isOrdered Before
//                // left is greater
//                return true
//            } else {
//                // first IS larger later in time, is NOT Ordered Before
//                return false
//            }

            // recents last
            if cresult == .OrderedAscending {
                // first is earlier in time than second, isOrdered Before
                // left is smaller
                return true
            } else {
                // first IS larger later in time, is NOT Ordered Before
                return false
            }
            
        }
        
        
//        audioFilesRecordedFiles = collectClipFiles.sort { (finfoFirst: FileInfo, finfoSecond: FileInfo) -> Bool in
//
////            // Ascending
////            if finfoFirst.size < finfoSecond.size {
////                // left is smaller, isOrdered Before
////                return true
////            } else {
////                return false // is NOT Ordered Before
////            }
//
//            // Descending
//            if finfoFirst.size > finfoSecond.size {
//                // left is smaller, is NOT Ordered Before
//                return false
//            } else {
//                // left is larger, is Ordered Before
//                // isOrdered Before
//                return true
//            }
//        }
        
        
//        filesData = fileInfos
        
    }
    
      /**
     Initialize the db, creating directory structure
     */
    func initdb() {
        
        var isDir: ObjCBool = false

        if let path = jamTracksDirectoryPath.path {
            if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir) {
            } else {
                do {
                    try NSFileManager.defaultManager().createDirectoryAtURL(
                        jamTracksDirectoryPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        
        if let path = inBoxDirectoryPath.path {
            
            if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir) {
            } else {
                do {
                    try NSFileManager.defaultManager().createDirectoryAtURL(
                        inBoxDirectoryPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        
        if let path = sourceAudioFilesDirectoryPath.path {
            
            if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir) {
            } else {
                do {
                    try NSFileManager.defaultManager().createDirectoryAtURL(
                        sourceAudioFilesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        
        if let path = downloadsDirectoryPath.path {
            
            if NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDir) {
            } else {
                do {
                    try NSFileManager.defaultManager().createDirectoryAtURL(
                        sourceAudioFilesDirectoryPath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error: \(error)")
                }
            }
        }
        
    }
    
    
    /**
     Copies data from Bundle to user directory
     
    */
    func copyResources() {
     
        // TODO: copy only if needed
        
        if let fileURL = NSBundle.mainBundle().URLForResource("TheKillersTrimmedMP3-30", withExtension: ".m4a") {
            do {
                try NSFileManager.defaultManager().copyItemAtURL(
                    fileURL, toURL: NSURL.DocumentFileURLWithFileName(fileURL.lastPathComponent!)!
                )
            } catch {
                print("Error: \(error)")
            }
        }
        
        if let fileURL = NSBundle.mainBundle().URLForResource("AminorBackingtrackTrimmedMP3-45", withExtension: ".m4a") {
            do {
                try NSFileManager.defaultManager().copyItemAtURL(
                    fileURL, toURL: NSURL.DocumentFileURLWithFileName(fileURL.lastPathComponent!)!
                )
            } catch {
                print("Error: \(error)")
            }
        }
        
        if let fileURL = NSBundle.mainBundle().URLForResource("clipRecording_aminor1", withExtension: ".caf") {
            do {
                try NSFileManager.defaultManager().copyItemAtURL(
                    fileURL, toURL: NSURL.DocumentFileURLWithFileName(fileURL.lastPathComponent!)!
                )
            } catch {
                print("Error: \(error)")
            }
        }
        
        if let fileURL = NSBundle.mainBundle().URLForResource("clipRecording_killers1", withExtension: ".caf") {
            do {
                try NSFileManager.defaultManager().copyItemAtURL(
                    fileURL, toURL: NSURL.DocumentFileURLWithFileName(fileURL.lastPathComponent!)!
                )
            } catch {
                print("Error: \(error)")
            }
        }
        
        if let fileURL = NSBundle.mainBundle().URLForResource("clipRecording_killers2", withExtension: ".caf") {
            do {
                try NSFileManager.defaultManager().copyItemAtURL(
                    fileURL, toURL: NSURL.DocumentFileURLWithFileName(fileURL.lastPathComponent!)!
                )
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    
    
    func audioLengthForFile(fileURL: NSURL) -> Double {
        
        var result: Double = 0.0
        
        do {
            let audioFile = try AVAudioFile(forReading: fileURL)
            //let processingFormat = audioFile.processingFormat
            let processingFormat = audioFile.fileFormat
            
            result = Double(audioFile.length) / processingFormat.sampleRate;
        } catch {
            print("Error: \(error) \n\(fileURL)")
        }
        
        return result;
    }
    
//    double result = 0;
//    NSError *error = nil;
//    AVAudioFile *audioFile = [[AVAudioFile alloc] initForReading:fileURL error:&error];
//    if (audioFile && error == nil) {
//    AVAudioFormat *processingFormat = [audioFile processingFormat];
//    result = audioFile.length / processingFormat.sampleRate;
//    } else {
//    NSLog(@"error in audio file %@",[fileURL lastPathComponent]);
//    }
//    return result;
//    }
    
}


//        if let type = ($0 as PFObject)["Type"] as String {
//            return type.rangeOfString("Sushi") != nil
//        } else {
//            return false
//        }


/*
 typedef void (^JWFileImageCompletionHandler)(UIImage *image); //  block (^JWClipExportAudioCompletionHandler)(void);
 
 @interface JWFileController : NSObject
 + (JWFileController *)sharedInstance;
 -(void)update;
 -(void)reload;
 -(void)readFsData;
 -(void)saveMeta;
 -(void)saveUserList;
 
 -(double)audioLengthForFileWithName:(NSString*)fileName;
 
 -(NSString*)dbKeyForFileName:(NSString*)fileName;
 
 // returns records URLs and size for Files arrays
 @property (nonatomic,readonly) NSArray *downloadedJamTrackFiles;
 @property (nonatomic,readonly) NSArray *jamTrackFiles;
 @property (nonatomic,readonly) NSArray *mp3Files;
 @property (nonatomic,readonly) NSArray *recordingFiles;
 @property (nonatomic,readonly) NSArray *trimmedFiles;
 @property (nonatomic,readonly) NSArray *sourceFiles;
 
 @property (strong, nonatomic) NSMutableDictionary *linksDirector;
 @property (strong, nonatomic) NSMutableDictionary *mp3FilesInfo;
 @property (strong, nonatomic) NSMutableDictionary *mp3FilesDescriptions;
 @property (strong, nonatomic) NSMutableArray *userOrderList;  // dbkey
 
 -(NSURL *)fileURLForCacheItem:(NSString*)dbkey;
 
 -(NSURL *)processInBoxItem:(NSURL*)fileURL options:(id)options;
 
 -(NSString*)audioFileFormatStringForFile:(NSURL*)fileURL;
 -(NSString*)audioFileProcessingFormatStringForFile:(NSURL*)fileURL;
 
 
 @end
*/
