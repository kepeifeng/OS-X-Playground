//
//  ScreenRecodeViewController.m
//  OS X Playground
//
//  Created by Kent Peifeng Ke on 14/11/5.
//  Copyright (c) 2014年 Kent Peifeng Ke. All rights reserved.
//

#import "ScreenRecodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ScreenRecodeViewController ()<AVCaptureFileOutputRecordingDelegate>
@property (strong) AVAssetImageGenerator *imageGenerator;
@end

@implementation ScreenRecodeViewController{
    AVCaptureSession *mSession;
    AVCaptureMovieFileOutput *mMovieFileOutput;
    NSTimer *mTimer;
    
    BOOL isRecording;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


- (IBAction)toggleRecording:(id)sender {
    
    if (isRecording) {
        [self finishRecord:mTimer];
        [self.statuLabel setStringValue:@""];
        
    }else{
        NSString * path = @"/Users/apple/Movies/screen.mov";
        [self screenRecording:[[NSURL alloc] initFileURLWithPath:path]];
        self.statuLabel.stringValue = @"Recording...";
    }
    
    isRecording = !isRecording;
    
}


#pragma mark - AV Foundation

-(void)screenRecording:(NSURL *)destPath
{
    // Create a capture session
    mSession = [[AVCaptureSession alloc] init];
    
    // Set the session preset as you wish
//    mSession.sessionPreset = AVCaptureSessionPresetMedium;
    mSession.sessionPreset = AVCaptureSessionPreset1280x720;
    
    // If you're on a multi-display system and you want to capture a secondary display,
    // you can call CGGetActiveDisplayList() to get the list of all active displays.
    // For this example, we just specify the main display.
    CGDirectDisplayID displayId = kCGDirectMainDisplay;
    
    // Create a ScreenInput with the display and add it to the session
    AVCaptureScreenInput *input = [[AVCaptureScreenInput alloc] initWithDisplayID:displayId];
    if (!input) {
        mSession = nil;
        return;
    }
    if ([mSession canAddInput:input])
        [mSession addInput:input];
    
    // Create a MovieFileOutput and add it to the session
    mMovieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
    if ([mSession canAddOutput:mMovieFileOutput])
        [mSession addOutput:mMovieFileOutput];
    
    // Start running the session
    [mSession startRunning];
    
    // Delete any existing movie file first
    if ([[NSFileManager defaultManager] fileExistsAtPath:[destPath path]])
    {
        NSError *err;
        if (![[NSFileManager defaultManager] removeItemAtPath:[destPath path] error:&err])
        {
            NSLog(@"Error deleting existing movie %@",[err localizedDescription]);
        }
    }
    
    // Start recording to the destination movie file
    // The destination path is assumed to end with ".mov", for example, @"/users/master/desktop/capture.mov"
    // Set the recording delegate to self
    [mMovieFileOutput startRecordingToOutputFileURL:destPath recordingDelegate:self];
    
    // Fire a timer in 5 seconds
//    mTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(finishRecord:) userInfo:nil repeats:NO] ;
}

-(void)finishRecord:(NSTimer *)timer
{
    // Stop recording to the destination movie file
    [mMovieFileOutput stopRecording];
    
    mTimer = nil;
}

// AVCaptureFileOutputRecordingDelegate methods

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    NSLog(@"Did finish recording to %@ due to error %@", [outputFileURL description], [error description]);
    
    // Stop running the session
    [mSession stopRunning];
    
    // Release the session
    mSession = nil;
}
- (IBAction)gifButtonClicked:(id)sender {
    
    [self convertToGif];
}

-(void)convertToGif{
    NSURL *url = [[NSURL alloc] initFileURLWithPath:@"/Users/apple/Movies/screen.mov"];
    AVURLAsset *anAsset = [[AVURLAsset alloc] initWithURL:url options:nil];

    AVAsset *myAsset = anAsset;
    // Assume: @property (strong) AVAssetImageGenerator *imageGenerator;
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:myAsset];
    
    Float64 durationSeconds = CMTimeGetSeconds([myAsset duration]);
    CMTime firstThird = CMTimeMakeWithSeconds(durationSeconds/3.0, 600);
    CMTime secondThird = CMTimeMakeWithSeconds(durationSeconds*2.0/3.0, 600);
    CMTime end = CMTimeMakeWithSeconds(durationSeconds, 600);
    NSArray *times = @[[NSValue valueWithCMTime:kCMTimeZero],
    [NSValue valueWithCMTime:firstThird], [NSValue valueWithCMTime:secondThird],
    [NSValue valueWithCMTime:end]];
    
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times
                                         completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime,
                                                             AVAssetImageGeneratorResult result, NSError *error) {
                                             
                                             NSString *requestedTimeString = (NSString *)
                                             CFBridgingRelease(CMTimeCopyDescription(NULL, requestedTime));
                                             NSString *actualTimeString = (NSString *)
                                             CFBridgingRelease(CMTimeCopyDescription(NULL, actualTime));
                                             NSLog(@"Requested: %@; actual %@", requestedTimeString, actualTimeString);
                                             
                                             if (result == AVAssetImageGeneratorSucceeded) {
                                                 // Do something interesting with the image.
                                             }
                                             
                                             if (result == AVAssetImageGeneratorFailed) {
                                                 NSLog(@"Failed with error: %@", [error localizedDescription]);
                                             }
                                             if (result == AVAssetImageGeneratorCancelled) {
                                                 NSLog(@"Canceled");
                                             }
                                         }];
}

@end
