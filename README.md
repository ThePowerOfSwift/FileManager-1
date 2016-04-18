# FileManager
Read disk files (Swift)
This project has been expanded to include more work done in porting JamWith from Objective-C to Swift
A Filemanager that processes files on disk and can readily sort them byDate and Size
A FileDownloader to download mp3 file
A Master table listing all User JamTracks with 
A ViewController that demonstrates use of animation with constraints, as well as UIDynamic behavior (SnapBehavior)

*description*

Uses NSFileManager to enumerate files on disk


extension NSURL {

An extension to NSURL that builds file URLS consistently with baseURL and relative URL
 Other URLs created by other means can be converted to base:relative: format
 Relative URL is used when persisted as the Documents path changes on each run from Xcode


In kit.swift

   audioFilesSourceFiles =
            collectOtherFiles.filter {
                if $0.name.hasSuffix(".mp3") || $0.name.hasSuffix(".caf") || $0.name.hasSuffix(".m4a") {
                    return true
                } else {
                    return false
                }
                }
                .sort { 


FILEDownloader
class JKFileDownloader: NSObject, NSURLSessionDelegate {

