//
//  AppDelegate.m
//  Dash
//
//  Created by Sidney on 8/18/17.
//  Copyright © 2017 Sidney San Martín. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface FullScreenWindow: NSWindow
@end

@implementation FullScreenWindow
- (NSRect)constrainFrameRect:(NSRect)frameRect toScreen:(NSScreen *)screen {
    return NSScreen.mainScreen.frame;
}
@end

@interface AppDelegate ()

@end

@implementation AppDelegate {
    ViewController* _vc;
    FullScreenWindow* _window;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    _vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
    _window = [[FullScreenWindow alloc] initWithContentRect:NSZeroRect
                                                  styleMask:NSWindowStyleMaskBorderless
                                                    backing:NSBackingStoreBuffered
                                                      defer:YES];
    _window.backgroundColor = NSColor.clearColor;
    _window.opaque = NO;
    _window.level = kCGDesktopWindowLevel;
    _window.ignoresMouseEvents = YES;
    _window.collectionBehavior =  NSWindowCollectionBehaviorStationary;
    _window.contentView = _vc.view;
    _window.contentView.wantsLayer = YES;
    [_window orderBack:nil];
}
@end
