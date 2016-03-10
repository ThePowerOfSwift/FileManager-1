//
//  JKFileDownloadController.swift
//  FileManager
//
//  Created by JOSEPH KERR on 3/6/16.
//  Copyright © 2016 JOSEPH KERR. All rights reserved.
//

import UIKit


class JKFileDownloader: NSObject, NSURLSessionDelegate {
    
    typealias completionMethod = (url:NSURL, dbKey:String) -> Void

    // MARK: Properties

    private var completionHandler: completionMethod?

//    private var completionHandler: ((url:NSURL, dbKey:String) -> Void)?
    private var progressHandler: ((progress:Float) -> Void)?
    private var downloadTask: NSURLSessionDownloadTask?

    func dowloadFileWithURL(url: NSURL) {

        print("download file...")

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: self, delegateQueue: nil)
        
        downloadTask = session.downloadTaskWithURL(url)
        downloadTask!.resume()
    }

    func dowloadFileWithURL(url: NSURL, completion: completionMethod) {

//    func dowloadFileWithURL(url: NSURL, completion: (url:NSURL, dbKey:String)->Void) {
        
        completionHandler = completion
        dowloadFileWithURL(url)
    }
    
    func dowloadFileWithURL(url: NSURL, progress:(progress:Float)->Void, completion: completionMethod) {
        completionHandler = completion
        progressHandler = progress
        dowloadFileWithURL(url)
    }

    func cancel() {
        if let dt = downloadTask {
            dt.cancel()
        }
    }
    
    // MARK: session delegate
    
    func URLSession(session: NSURLSession,
        downloadTask: NSURLSessionDownloadTask,
        didFinishDownloadingToURL location: NSURL) {
            
            print("finished \n\(location)")
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            if let completion = completionHandler {
                completion(url: location,dbKey:"key")
            }
            
    }
    
    
    func URLSession(session: NSURLSession,
         downloadTask: NSURLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
         totalBytesWritten: Int64,
         totalBytesExpectedToWrite: Int64)
    {

        var percentComplete = 0.0
        
        if totalBytesExpectedToWrite > 0 {
            percentComplete = Double(totalBytesWritten)/Double(totalBytesExpectedToWrite);
        }
        
        if let progress = progressHandler {
            progress(progress: Float(percentComplete))
            
        }
    }
    
}


