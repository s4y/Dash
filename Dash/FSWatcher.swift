import Foundation

class FSWatcher {
    private let cb: () -> ()
    private var stream: FSEventStreamRef = nil
    
    init(paths: [String], cb: () -> ()) {
        self.cb = cb
        
        var context = FSEventStreamContext()
        context.info = UnsafeMutablePointer(unsafeAddressOf(self))
        
        stream = FSEventStreamCreate(nil,
            { (_, context, _, _, _, _) in
                unsafeBitCast(context, FSWatcher.self).cb()
            }, &context, paths,
            FSEventStreamEventId(kFSEventStreamEventIdSinceNow), 0.1,
            FSEventStreamCreateFlags(kFSEventStreamCreateFlagNone)
        )
        
        FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetMain(), kCFRunLoopCommonModes)
        FSEventStreamStart(stream)
    }
    
    deinit { FSEventStreamRelease(stream) }
}