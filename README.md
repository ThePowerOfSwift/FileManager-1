# FileManager
Read disk files (Swift)
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

