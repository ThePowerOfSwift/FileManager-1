//
//  JamMasterTableViewController.swift
//  FileManager
//
//  Created by JOSEPH KERR on 3/21/16.
//  Copyright © 2016 JOSEPH KERR. All rights reserved.
//

import UIKit

class JamMasterTableViewController: UITableViewController {

    
    enum JamTrackMenuCategory {
        case JWCatgeoryOther
        case JWCategoryPreloaded
        case JWCategoryDownloaded
        case JWCategoryYoutube
        case JWCategoryAudioFiles
    }

    
    // MARK: Properties

    // MARK: tableData model

    var tableData = [[JamTrack]]()
    
    static let DocumentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    let archiveURL = DocumentsDirectory.URLByAppendingPathComponent("JamTracksMaster")

    let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }

    func loadData() {
        
        
        FileController.sharedManager.activate()
        
        testFileUrls()
        
        if let tableDataFromFile = loadJamTracks() {
            tableData = tableDataFromFile
        } else {
            newHomeMenuLists()
            saveJamTracks()
        }
        
        addNewJamTrackObject()

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: - Table view data
    
    func newJamTrack() {
        
    }
    
    func newTrackObject() {
        
    }
    
    func newJamTrackObject() -> JamTrack  {
        
        let resultJamTrack = JamTrack()
        
        resultJamTrack.key = NSUUID().UUIDString
        resultJamTrack.date = NSDate()
        
        let trackObject1 = TrackObject(.Player)
        let trackObject2 = TrackObject(.PlayerRecorder)

        resultJamTrack.tracks = [trackObject1, trackObject2]
        
        return resultJamTrack
    }

    

    func newJamTracksPreLoaded() -> [JamTrack] {
        
        var jamTracks = [JamTrack]()

        //  Create Jam Track

        let jamTrack = JamTrack()
        
        jamTrack.title = "TheKillers"

        let trackObject1 = TrackObject(.Player, fileURL: self.documentsDirectory.URLByAppendingPathComponent("TheKillersTrimmedMP3-30.m4a"))
        trackObject1.title = "TheKillers"
        
        jamTrack.tracks += [trackObject1];  // ADD Track
        
        // ADD JamTrack to result
        jamTracks += [jamTrack]

        // Create Another Jam Track ...
        
        
        
        
        return jamTracks
    }
    
    
    func newJamTracksSamples() -> [JamTrack] {
        
        var jamTracks = [JamTrack]()
        
        //  Create Jam Track
        
        let jamTrack = JamTrack()
        
        jamTrack.title = "Brendans Mix"
        
        
        
        let trackObject1 = TrackObject(.Player,
            fileURL: self.documentsDirectory.URLByAppendingPathComponent("TheKillersTrimmedMP3-30.m4a"))
        
        trackObject1.title = "TheKillers"
        
        jamTrack.tracks += [trackObject1];  // ADD
        
        let trackObject2 = TrackObject(.PlayerRecorder, fileURL:self.documentsDirectory.URLByAppendingPathComponent("clipRecording_aminor1.caf"))
        
        trackObject2.title = "AminorBackingtrack"
        
        jamTrack.tracks += [trackObject2];  // ADD

        // ADD JamTrack to result
        
        jamTracks += [jamTrack]

        // Create Another Jam Track ...
        
        
        
        return jamTracks
    }

    
    
    
//    func newHomeMenuLists() -> [[JamTrack]] {
        
    func newHomeMenuLists() {
        
//        var result: [[JamTrack]]
//        var jamTracks: [JamTrack]
        
        tableData = [[JamTrack]]()
        
        tableData += [[JamTrack]()]
        tableData[0] = newJamTracksPreLoaded()

        tableData += [[JamTrack]()]
        tableData[1] = newJamTracksSamples()
        
    }
    
    func addNewJamTrackObject() {
        
        let trackSection = 1  // My Jam Tracks

        let jamTrack = newJamTrackObject()
        jamTrack.title = "new jam track"
        
        tableData[trackSection].insert(jamTrack, atIndex: 0)
        
    }
 

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "JamTrackCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)

        // Configure the cell...
        
        // Get the data
        let jamTrack = tableData[indexPath.section][indexPath.row]
        
        cell.textLabel!.text = jamTrack.title
        let trackCount = jamTrack.tracks.count
        
        cell.detailTextLabel!.text = "number of tracks \(trackCount)"
        

        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        // Get the data
        let jamTrack = tableData[indexPath.section][indexPath.row]
        
        print("\(jamTrack.title) \n  \(jamTrack.tracks.description)")
        
        for i in 0..<jamTrack.tracks.count {
            
            print("\(jamTrack.tracks[i].title) ")
            
//            if let fileURL = jamTrack.tracks[i].fileURL {
//
//                let baseURL = fileURL.baseURL
//                let relativeURL = fileURL.relativePath
//                let fileP = fileURL
//            }
            
        }
        

    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    override func tableView(tableView: UITableView,titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "PreLoaded"
        } else if section == 1 {
            return "My Jam Tracks"
        }
        return nil
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    // MARK: Helpers

    func testFileUrls () {
    
        let url = documentsDirectory.URLByAppendingPathComponent("TheKillersTrimmedMP3-30.m4a")

        print("\nPath \(url.path)\n\(url.baseURL?.path)\n\(url.relativePath)")

        
        let url2 = documentsDirectory.URLByAppendingPathComponent("Source").URLByAppendingPathComponent("joker.m4a")

        print("\nPath \(url2.path)\n\(url2.baseURL?.path)\n\(url2.relativePath)")

        
        let url3 = NSURL.DocumentFileURLFromFileURL(url2)
        
        print("\nPath \(url3!.absoluteURL)\n\(url3?.baseURL?.path)\n\(url3?.relativePath)")
        
        
        let url4 = NSURL.DocumentFileURLWithFileName("joker2.m4a", inPath: ["Source","subdir"])
        
        print("\nPath \(url4!.absoluteString)\n\(url4?.baseURL?.path)\n\(url4?.relativePath)")
        
        
        let url5 = NSURL.DocumentFileURLWithRelativePathName("joker2.m4a")
        
        print("\nPath \(url5!.path)\n\(url5?.baseURL?.path)\n\(url5?.relativePath)")
        
        
        let url6 = NSURL.DocumentFileURLWithFileName("joker2.m4a")
        
        print("\nPath \(url6!.path)\n\(url6?.baseURL?.path)\n\(url6?.relativePath)")

//        let url3 = fileURLFromFileURL(url2)
//        print("\nPath \(url3!.absoluteURL)\n\(url3?.baseURL?.path)\n\(url3?.relativePath)")
//        let url4 = fileURLWithFileName("joker2.m4a", inPath: ["Source","subdir"])
//        print("\nPath \(url4!.absoluteString)\n\(url4?.baseURL?.path)\n\(url4?.relativePath)")
//        let url5 = fileURLWithRelativePathName("joker2.m4a")
//        print("\nPath \(url5!.path)\n\(url5?.baseURL?.path)\n\(url5?.relativePath)")
//        let url6 = fileURLWithFileName("joker2.m4a")
//        print("\nPath \(url6!.path)\n\(url6?.baseURL?.path)\n\(url6?.relativePath)")

    }
    
    
       // MARK: NSCoding
    
    func saveJamTracks() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(tableData, toFile: archiveURL.path!)
        
        if !isSuccessfulSave {
            print("failed to save")
        }
    }
    
    func loadJamTracks() -> [[JamTrack]]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(archiveURL.path!) as? [[JamTrack]]
    }

    
}




//    NSMutableArray *result =
//    [@[
//    [@{
//    @"title":@"Settings And Files",
//    @"type":@(JWHomeSectionTypeOther),
//    } mutableCopy],
//    [@{
//    @"title":@"Provided JamTracks",
//    @"type":@(JWHomeSectionTypePreloaded),
//    @"trackobjectset":[self newProvidedJamTracks],
//    } mutableCopy],
//    [@{
//    @"title":@"Downloaded JamTracks",
//    @"type":@(JWHomeSectionTypeDownloaded),
//    @"trackobjectset":[self newDownloadedJamTracks],
//    } mutableCopy],
//    [@{
//    @"title":@"Source Audio",
//    @"type":@(JWHomeSectionTypeYoutube)
//    } mutableCopy],
//    [@{
//    @"title":@"Audio Files",
//    @"type":@(JWHomeSectionTypeAudioFiles),
//    @"trackobjectset":[self newJamTracks],
//    } mutableCopy],
//    ] mutableCopy
//    ];
//    return result;
//    }


//    NSMutableDictionary *result = nil;
//
//    id track1 = [self newTrackObjectOfType:JWMixerNodeTypePlayer];
//    id track2 = [self newTrackObjectOfType:JWMixerNodeTypePlayerRecorder];
//
//    NSMutableArray *trackObjects = [@[track1, track2] mutableCopy];
//
//    result =
//    [@{@"key":[[NSUUID UUID] UUIDString],
//    @"titletype":@"jamtrack",
//    @"title":@"jam Track",
//    @"trackobjectset":trackObjects,
//    @"date":[NSDate date],
//    } mutableCopy];
//    return result;



//        let trackObject1 = TrackObject()
//        trackObject1.title = "TheKillers"
//        trackObject1.fileURL = self.documentsDirectory.URLByAppendingPathComponent("TheKillersTrimmedMP3-30.m4a")
//        let trackObject2 = TrackObject()
//        trackObject2.title = "AminorBackingtrack"
//        trackObject2.fileURL = self.documentsDirectory.URLByAppendingPathComponent("clipRecording_aminor1.caf")

// ObjC
//        jamTrack1[@"title"] = @"Brendans mix The killers";
//
//        track1 = jamTrack1[@"trackobjectset"][0];
//        fileURL = [self fileURLWithFileName:@"TheKillersTrimmedMP3-30.m4a" inPath:@[]];
//        track1[@"fileURL"] = fileURL;
//
//        track2 = jamTrack1[@"trackobjectset"][1];
//        fileURL = [self fileURLWithFileName:@"clipRecording_killers1.caf" inPath:@[]];
//        track2[@"fileURL"] = fileURL;
//
//
//        // JAMTRACK 2
//        NSMutableDictionary *jamTrack2 = [self newJamTrackObject];
//        jamTrack2[@"title"] = @"Brendans mix Aminor1";
//
//        track1 = jamTrack2[@"trackobjectset"][0];
//        fileURL = [self fileURLWithFileName:@"AminorBackingtrackTrimmedMP3-45.m4a" inPath:@[]];
//        track1[@"fileURL"] = fileURL;
//
//        track2 = jamTrack2[@"trackobjectset"][1];
//        fileURL = [self fileURLWithFileName:@"clipRecording_aminor1.caf" inPath:@[]];
//        track2[@"fileURL"] = fileURL;
//
//        [jamTracks insertObject:jamTrack2 atIndex:0];
//        [jamTracks insertObject:jamTrack1 atIndex:0];
//

/*
-(NSMutableDictionary*)newTrackObjectOfType:(JWMixerNodeTypes)mixNodeType andFileURL:(NSURL*)fileURL withAudioFileKey:(NSString *)key {

NSMutableDictionary *result = nil;
if (mixNodeType == JWMixerNodeTypePlayer) {
result =
[@{@"key":[[NSUUID UUID] UUIDString],
@"title":@"track",
@"starttime":@(0.0),
@"date":[NSDate date],
@"type":@(JWMixerNodeTypePlayer)
} mutableCopy];
} else if (mixNodeType == JWMixerNodeTypePlayerRecorder) {
result =
[@{@"key":[[NSUUID UUID] UUIDString],
@"title":@"track recorder",
@"starttime":@(0.0),
@"date":[NSDate date],
@"type":@(JWMixerNodeTypePlayerRecorder)
} mutableCopy];
}

if (fileURL)
result[@"fileURL"] = fileURL;

if (key)
result[@"audiofilekey"] = key;


return result;
}



-(NSMutableDictionary*)newJamTrackObjectWithRecorderFileURL:(NSURL*)fileURL {
NSMutableDictionary *result = nil;

id track = [self newTrackObjectOfType:JWMixerNodeTypePlayerRecorder andFileURL:nil withAudioFileKey:nil];

NSMutableArray *trackObjects = [@[track] mutableCopy];

result =
[@{@"key":[[NSUUID UUID] UUIDString],
@"titletype":@"jamtrack",
@"title":@"jam Track",
@"trackobjectset":trackObjects,
@"date":[NSDate date],
} mutableCopy];
return result;
}

-(NSMutableArray*)newDownloadedJamTracks {

NSMutableArray *result = [NSMutableArray new];
for (id fileInfo in [[JWFileController sharedInstance] downloadedJamTrackFiles]) {
NSLog(@"%s %@",__func__,[fileInfo[@"furl"] lastPathComponent]);

NSURL *fileURL = [self fileURLWithFileFlatFileURL:fileInfo[@"furl"]];

//TODO: not sure if the key parameter is needed here
[result addObject:[self newJamTrackObjectWithFileURL:fileURL audioFileKey:nil]];
}

return result;
}

-(NSMutableArray*)newHomeMenuLists {
NSMutableArray *result =
[@[
[@{
@"title":@"Settings And Files",
@"type":@(JWHomeSectionTypeOther),
} mutableCopy],
[@{
@"title":@"Provided JamTracks",
@"type":@(JWHomeSectionTypePreloaded),
@"trackobjectset":[self newProvidedJamTracks],
} mutableCopy],
[@{
@"title":@"Downloaded JamTracks",
@"type":@(JWHomeSectionTypeDownloaded),
@"trackobjectset":[self newDownloadedJamTracks],
} mutableCopy],
[@{
@"title":@"Source Audio",
@"type":@(JWHomeSectionTypeYoutube)
} mutableCopy],
[@{
@"title":@"Audio Files",
@"type":@(JWHomeSectionTypeAudioFiles),
@"trackobjectset":[self newJamTracks],
} mutableCopy],
] mutableCopy
];
return result;
}

// --------------
NSMutableArray *result = nil;
NSMutableArray *jamTracks = [NSMutableArray new];
NSURL *fileURL;
NSMutableDictionary *track1;
NSMutableDictionary *track2;

// JAMTRACK 1
NSMutableDictionary *jamTrack1 = [self newJamTrackObject];
jamTrack1[@"title"] = @"Brendans mix The killers";

track1 = jamTrack1[@"trackobjectset"][0];
fileURL = [self fileURLWithFileName:@"TheKillersTrimmedMP3-30.m4a" inPath:@[]];
track1[@"fileURL"] = fileURL;

track2 = jamTrack1[@"trackobjectset"][1];
fileURL = [self fileURLWithFileName:@"clipRecording_killers1.caf" inPath:@[]];
track2[@"fileURL"] = fileURL;


// JAMTRACK 2
NSMutableDictionary *jamTrack2 = [self newJamTrackObject];
jamTrack2[@"title"] = @"Brendans mix Aminor1";

track1 = jamTrack2[@"trackobjectset"][0];
fileURL = [self fileURLWithFileName:@"AminorBackingtrackTrimmedMP3-45.m4a" inPath:@[]];
track1[@"fileURL"] = fileURL;

track2 = jamTrack2[@"trackobjectset"][1];
fileURL = [self fileURLWithFileName:@"clipRecording_aminor1.caf" inPath:@[]];
track2[@"fileURL"] = fileURL;


[jamTracks insertObject:jamTrack2 atIndex:0];
[jamTracks insertObject:jamTrack1 atIndex:0];

result = jamTracks;



*/

