//
//  SSAppDelegate.h
//  Dash
//
//  Created by Sidney San Martín on 12/10/13.
//  Copyright (c) 2013 s4y. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface SSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet WebView *webView;
@property (retain) NSString *supportDirectory;
@property (assign) FSEventStreamRef stream;

- (void)reload;

@end
