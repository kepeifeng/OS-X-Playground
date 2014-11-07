//
//  ScreenRecodeViewController.h
//  OS X Playground
//
//  Created by Kent Peifeng Ke on 14/11/5.
//  Copyright (c) 2014年 Kent Peifeng Ke. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ScreenRecodeViewController : NSWindowController
- (IBAction)toggleRecording:(id)sender;

@property (weak) IBOutlet NSTextField *statuLabel;

@end
