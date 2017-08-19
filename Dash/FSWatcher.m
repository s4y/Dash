//
//  FSWatcher.m
//  Dash
//
//  Created by Sidney on 8/18/17.
//  Copyright © 2017 Sidney San Martín. All rights reserved.
//

#import "FSWatcher.h"

@implementation FSWatcher {
    void(^_cb)(void);
    FSEventStreamRef _stream;
}

void fsCallback(ConstFSEventStreamRef streamRef, void * clientCallBackInfo, size_t numEvents, void *eventPaths,  const FSEventStreamEventFlags  * eventFlags, const FSEventStreamEventId * eventIds) {
    ((__bridge FSWatcher*)clientCallBackInfo)->_cb();
}

- (instancetype)initWithPaths:(NSArray<NSString*>*)paths cb:(void(^)(void))cb {
    if ((self = [super init])) {
        _cb = cb;
        FSEventStreamContext context = {0};
        context.info = (__bridge void*)self;
        _stream = FSEventStreamCreate(nil, &fsCallback, &context, (__bridge CFArrayRef)paths, kFSEventStreamEventIdSinceNow, 0.1, kFSEventStreamCreateFlagNone);
        FSEventStreamScheduleWithRunLoop(_stream, CFRunLoopGetMain(), kCFRunLoopCommonModes);
        FSEventStreamStart(_stream);
    }
    return self;
}

- (void)dealloc {
    FSEventStreamRelease(_stream);
}
@end
