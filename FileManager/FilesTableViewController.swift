//
//  FilesTableViewController.swift
//  FileManager
//
//  Created by JOSEPH KERR on 3/4/16.
//  Copyright © 2016 JOSEPH KERR. All rights reserved.
//

import UIKit

class FilesTableViewController: UITableViewController {
    
    struct CellFileInfo {
        var title: String
        var detailTitle: String
    }

    // MARK: Archiving paths
    
    let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
//    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")
    
    let df = NSDateFormatter()

    // MARK: Properties
    
    var fileSections: [[FileInfo]] = []
    var filesData: [FileInfo] = []
    var cellData: [CellFileInfo] = []
    

    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        
        FileController.sharedManager.activate()
        
        if let audioFiles = FileController.sharedManager.audioFilesSourceFiles {
        
            filesData = audioFiles
        }
    }
    
    // MARK: load data
    
    func loadDataFromLocalEnumerator() {
        
        let fm = NSFileManager.defaultManager()
        
        let resourceKeys = [NSURLNameKey, NSURLIsDirectoryKey, NSURLCreationDateKey,NSURLContentAccessDateKey]
        let docsDirectory = DocumentsDirectory as NSURL
        let directoryEnumerator = fm.enumeratorAtURL(docsDirectory, includingPropertiesForKeys: resourceKeys, options: [.SkipsHiddenFiles], errorHandler: nil)!
        
//        var fileURLs: [NSURL] = []
        var fileInfos: [FileInfo] = []

        for case let fileURL as NSURL in directoryEnumerator {
            guard let resourceValues = try? fileURL.resourceValuesForKeys(resourceKeys),
                let isDirectory = resourceValues[NSURLIsDirectoryKey] as? Bool,
                let name = resourceValues[NSURLNameKey] as? String,
                let createDate = resourceValues[NSURLCreationDateKey] as? NSDate
                else {
                    continue
            }
            
            if isDirectory {
                if name == "_extras" {
                    directoryEnumerator.skipDescendants()
                }
            } else {
                
                if name.hasPrefix("mp3") {
                    //print("\(name)\n")
                } else if name.hasPrefix("clip") {
                    continue
                }

                
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
                fileInfos.append(fileData)
            }
        }
        
        filesData = fileInfos
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filesData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FileTableViewCell", forIndexPath: indexPath)

        // Configure the cell...

        df.dateStyle = .MediumStyle
        df.timeStyle = .ShortStyle
        
        let fileInfo = filesData[indexPath.row]
        
        var fileSizeStr : String
        
        if (fileInfo.size > (1024 * 1024)) {
            //let sizeNumber = fileInfo.size/(1024 * 1024)
            //fileSizeStr = "\(sizeNumber) mb"

            fileSizeStr = String(format: "%.2f mb",Double(fileInfo.size)/(1024 * 1024) )
            
        } else if (fileInfo.size > 1024) {
//            let sizeNumber = fileInfo.size/1024
//            fileSizeStr = "\(sizeNumber) kb"
            
            fileSizeStr = String(format: "%.2f kb",Double(fileInfo.size)/1024 )
            
        } else {
            let sizeNumber = fileInfo.size
            fileSizeStr = "\(sizeNumber) bytes"
        }
        
//        fileSizeStr += " \(fileInfo.duration) secs"
        let durationString = String(format: "  %.3f secs", fileInfo.duration)

        fileSizeStr += durationString

        cell.textLabel!.text = fileInfo.name
        
        let dateStr = df.stringFromDate(fileInfo.date)
        cell.detailTextLabel!.text = dateStr + " " + fileSizeStr
        
        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
