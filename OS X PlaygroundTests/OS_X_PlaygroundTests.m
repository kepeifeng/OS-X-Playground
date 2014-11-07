//
//  OS_X_PlaygroundTests.m
//  OS X PlaygroundTests
//
//  Created by Kent Peifeng Ke on 14/11/3.
//  Copyright (c) 2014年 Kent Peifeng Ke. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

@interface OS_X_PlaygroundTests : XCTestCase

@end

@implementation OS_X_PlaygroundTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        NSString * path = @"123.png";
        NSLog(@"last path component = %@",[path lastPathComponent]);
    }];
}

@end
