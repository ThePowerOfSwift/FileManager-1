//
//  NSExtensions.swift
//  FileManager
//
//  Created by JOSEPH KERR on 3/24/16.
//  Copyright © 2016 JOSEPH KERR. All rights reserved.
//

import Foundation

extension NSURL {
    
    /**
     A typical URL for a file without a base and relative is converted to one with a base a relative
     by finding the path component to Documents
     */
    class func DocumentFileURLFromFileURL(fileUrl: NSURL) -> NSURL? {
        
        var resultFileURL: NSURL?
        var relativePathComponents = [String]()
        
        var indexToDocuments = 0
        if let pathComponents = fileUrl.pathComponents {
            
            for path in pathComponents {
                if path == "Documents" {
                    break;
                }
                
                indexToDocuments += 1
            }
            
            let indexPastDocuments = indexToDocuments + 1
            let lastIndex = pathComponents.count - 1
            
            for index in indexPastDocuments..<lastIndex {
                relativePathComponents += [pathComponents[index]]
            }
        }
        
        if let fileName = fileUrl.lastPathComponent {
            resultFileURL = DocumentFileURLWithFileName(fileName, inPath:relativePathComponents)
        }
        
        
        return resultFileURL
    }
    
    /**
     A fileURL is created given a fileName and array of path components
     A URL is created using a baseURL at Documents and relative path
     */
    class func DocumentFileURLWithFileName(fileName: String, inPath:[String]?) -> NSURL? {
        
        var resultFileURL: NSURL?
        var urlPath: NSURL
        
        if let pathComponents = inPath  {
            if pathComponents.count > 0 {
                // Create the path with first component append remaining components
                urlPath = NSURL(string: pathComponents[0])!
                for index in 1..<pathComponents.count {
                    urlPath = urlPath.URLByAppendingPathComponent(pathComponents[index])
                }
                // and append the file name
                urlPath = urlPath.URLByAppendingPathComponent(fileName)
            } else {
                urlPath = NSURL(string: fileName)!
            }
            
        } else {
            urlPath = NSURL(string: fileName)!
        }
        
        if let pathString = urlPath.path {
            resultFileURL = DocumentFileURLWithRelativePathName(pathString)
        }
        
        return resultFileURL
    }
    
    /**
     A fileURL is created given a relative pathWithFileName
     A URL is created using a baseURL at Documents and this relative path
     */
    class func DocumentFileURLWithRelativePathName(pathName: String) -> NSURL? {
        var resultFileURL: NSURL?
        
        let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        
        if let url = NSURL(string:pathName, relativeToURL:documentsDirectory) {
            resultFileURL = url
        }
        
        return resultFileURL
    }
    
    /**
     A fileURL is created given a fileName
     A URL is created using a baseURL at Documents and relative path, this file name
     */
    class func DocumentFileURLWithFileName(fileName: String) -> NSURL? {
        return DocumentFileURLWithFileName(fileName, inPath:nil);
    }
    
}

