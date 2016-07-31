//
//  SSAppDelegate.m
//  Dash
//
//  Created by Sidney San Martín on 12/10/13.
//  Copyright (c) 2013 s4y. All rights reserved.
//

#import "SSAppDelegate.h"

void fsCallback (
                 ConstFSEventStreamRef streamRef,
                 void *clientCallBackInfo,
                 size_t numEvents,
                 void *eventPaths,
                 const FSEventStreamEventFlags eventFlags[],
                 const FSEventStreamEventId eventIds[]
                 )
{
	NSLog(@"Got FS event");
    [(__bridge SSAppDelegate*)clientCallBackInfo reload];
}

@implementation SSAppDelegate


- (void)awakeFromNib
{
	[self.window setFrame:[self.window frameRectForContentRect:[[self.window screen] frame]] display:YES animate:NO];
    [self.window setBackgroundColor:[NSColor clearColor]];
    [self.window setOpaque:NO];
    [self.window setLevel:kCGDesktopWindowLevel];
    [self.window setIgnoresMouseEvents:YES];
    
	[self.webView setDrawsBackground:NO];
	[self.webView setMaintainsBackForwardList:NO];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.supportDirectory = [[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Dash"];

    self.stream = FSEventStreamCreate(
        NULL,
        fsCallback,
        &((FSEventStreamContext){0, (__bridge void*)self}),
        (__bridge CFArrayRef)@[self.supportDirectory],
        kFSEventStreamEventIdSinceNow,
        0.1,
        kFSEventStreamCreateFlagNone
    );
    
	FSEventStreamScheduleWithRunLoop(
        self.stream,
        CFRunLoopGetCurrent(),
        kCFRunLoopCommonModes
    );
    
	FSEventStreamStart(self.stream);
    
    [self reload];
}

- (void)reload {
    
    NSError *error;
    
    [[NSFileManager defaultManager] createDirectoryAtPath:self.supportDirectory
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&error];
    
    NSString *page = [self.supportDirectory stringByAppendingPathComponent:@"index.html"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:page]) {
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        [NSApp activateIgnoringOtherApps:YES];
        if ([[NSAlert alertWithMessageText:@"Missing index.html" defaultButton:@"Quit" alternateButton:@"Show Folder" otherButton:nil informativeTextWithFormat:@"Dash needs a file called “index.html”."] runModal] == NSAlertAlternateReturn)
        {
            [[NSWorkspace sharedWorkspace] openFile:self.supportDirectory];
        }
        [NSApp terminate:self];
    }
    
	[[self.webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:page]]];
}

@end
