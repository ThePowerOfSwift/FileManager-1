//
//  ViewController.swift
//  FileManager
//
//  Created by JOSEPH KERR on 3/4/16.
//  Copyright © 2016 JOSEPH KERR. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var downloadButton: UIButton!

    let downloadController = JKFileDownloader()
    
    let documentsDirectory = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        downloadButton.setTitle("Download", forState: .Normal)
        downloadButton.setTitle("Cancel", forState: .Selected)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: options to download
    
    func downloadWithCompletion(downloadURL: NSURL) {
        
        downloadController.dowloadFileWithURL(downloadURL) {
            (url: NSURL, dbkey: String) -> Void in
            
            print( __FUNCTION__ + " complete\n")
            
            dispatch_async(dispatch_get_main_queue(),{
                self.downloadButton.selected = false
            })
            
            if let fname = downloadURL.lastPathComponent {
                let targetURL = self.documentsDirectory.URLByAppendingPathComponent(fname)
                do {
                    try NSFileManager.defaultManager().copyItemAtURL(url, toURL: targetURL)
                } catch {
                    print("error \(error)")
                }
                
                //  try! NSFileManager.defaultManager().copyItemAtURL(url, toURL: targetURL)
            }
        }

    }

    
    func downloadWithProgressAndCompletion(downloadURL: NSURL) {
        
        downloadController.dowloadFileWithURL(downloadURL, progress: { (progress: Float) -> Void in
            dispatch_async(dispatch_get_main_queue(),{
                self.progressView.setProgress(progress, animated: true)
            })
            })
            {
                (url: NSURL, dbkey: String) -> Void in
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.downloadButton.selected = false
                    self.progressView.setProgress(0.0, animated: true)
                })
                
                if let fname = downloadURL.lastPathComponent {
                    
                    let targetURL = self.documentsDirectory.URLByAppendingPathComponent(fname)
                    
                    //    try! NSFileManager.defaultManager().copyItemAtURL(url, toURL: targetURL)
                    
                    do {
                        try NSFileManager.defaultManager().copyItemAtURL(url, toURL: targetURL)
                    } catch {
                        print("error \(error)")
                    }
                }
        }
    }
    

    // MARK: Button Actions

    @IBAction func buttonPressed(sender: UIButton) {
        
        if sender.selected == false {
            let downloadURL = NSURL(string: "https://upload.wikimedia.org/wikipedia/commons/5/58/Sunset_2007-1.jpg")!

            sender.selected = true
            
            let option = 3

            if option == 1 {
                downloadController.dowloadFileWithURL(downloadURL)
            } else if option == 2 {
                downloadWithCompletion(downloadURL)
            } else {
                // with progress
                progressView.progress = 0.0

                downloadWithProgressAndCompletion(downloadURL)
            }
            
        } else {
            downloadController.cancel()
            sender.selected = false
        }
    }
    
}

// https ://upload.wikimedia.org/wikipedia/commons/5/58/Sunset_2007-1.jpg
// http ://www.nasa.gov/sites/default/files/thumbnails/image/nh-psychedelic-pluto_pca.png
// http ://www.hd-wallpapersdownload.com/upload/bulk-upload/desktop-nature-pictures-high-resolution-dowload.jpg




