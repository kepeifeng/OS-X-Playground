//
//  AppDelegate.m
//  OS X Playground
//
//  Created by Kent Peifeng Ke on 14/11/3.
//  Copyright (c) 2014年 Kent Peifeng Ke. All rights reserved.
//

#import "AppDelegate.h"
#import "ScreenRecodeViewController.h"


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate{
    ScreenRecodeViewController * screenRecordViewController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)screenRecordButtonClicked:(id)sender {
    
    screenRecordViewController = [[ScreenRecodeViewController alloc] initWithWindowNibName:@"ScreenRecodeViewController"];
    [screenRecordViewController showWindow:nil];
}

@end
