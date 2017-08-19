//
//  ViewController.m
//  Dash
//
//  Created by Sidney on 8/18/17.
//  Copyright © 2017 Sidney San Martín. All rights reserved.
//

#import "ViewController.h"
#import "FSWatcher.h"

@import WebKit;

NSURL* supportDirectory;
NSURL* page;

/*
private let supportDirectory = try! defaultFileManager
.URLForDirectory(
                 .ApplicationSupportDirectory,
                 inDomain: .UserDomainMask,
                 appropriateForURL: nil,
                 create: true
                 )
.URLByAppendingPathComponent(NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleNameKey as String) as! String)
private let page = supportDirectory.URLByAppendingPathComponent("index.html")
*/

@implementation ViewController {
    WebView* _webView;
    FSWatcher* _fsWatcher;
}

+ (void)initialize {
    NSFileManager* fileManager = NSFileManager.defaultManager;
    NSError* err = nil;
    supportDirectory = [[fileManager URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&err] URLByAppendingPathComponent:[NSBundle.mainBundle objectForInfoDictionaryKey:(NSString*)kCFBundleNameKey]];
    if (err) {
        [[NSAlert alertWithError:err] runModal];
        [NSApp terminate:nil];
    }
    page = [supportDirectory URLByAppendingPathComponent:@"index.html"];
    
}

- (void)loadView {
    _webView = [[WebView alloc] initWithFrame:NSZeroRect];
    _webView.drawsBackground = NO;
    self.view = _webView;
    __weak ViewController* weakSelf = self;
    _fsWatcher = [[FSWatcher alloc] initWithPaths:@[supportDirectory.path] cb:^{
        [weakSelf reload];
    }];
    [self reload];
}

- (void)reload {
    NSFileManager* fileManager = NSFileManager.defaultManager;
    if (![fileManager fileExistsAtPath:page.path]) {
        [fileManager createDirectoryAtURL:supportDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        [NSApp activateIgnoringOtherApps:YES];
        NSAlert* alert = [[NSAlert alloc] init];
        alert.messageText = @"Missing index.html";
        alert.informativeText = @"Dash needs a file called “index.html”.";
        [alert addButtonWithTitle:@"Quit"];
        [alert addButtonWithTitle:@"Show Folder"];
        if ([alert runModal] == NSAlertSecondButtonReturn) {
            [NSWorkspace.sharedWorkspace openURL:supportDirectory];
        }
        [NSApp terminate:nil];
    }
    [_webView.mainFrame loadRequest:[NSURLRequest requestWithURL:page]];
}
@end
