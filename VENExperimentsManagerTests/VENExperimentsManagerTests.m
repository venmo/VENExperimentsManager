//
//  VENExperimentsManagerTests.m
//  VENExperimentsManagerTests
//
//  Created by Chris Maddern on 12/21/13.
//  Copyright (c) 2013 Venmo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VENExperimentsManager.h"
#import "VENTestExperiments.h"

@interface VENExperimentsManagerTests : XCTestCase

@end

@implementation VENExperimentsManagerTests

- (void)setUp
{
    [VENExperimentsManager startExperimentsManagerWithPlistName:@"testExperiments"];
    [VENExperimentsManager deleteAllUserSettings];
    [super setUp];
}

- (void)tearDown
{
    
    [VENExperimentsManager deleteAllUserSettings];
    
    [super tearDown];
}

- (void)testExperimentManagerCreation
{
    VENExperiment *experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertFalse([experiment enabled], @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.name, @"Some Experiment Title", @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.identifier, @"VEN_EXPERIMENT_SOME_EXPERIMENT", @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.details, @"Some details 2", @"Incorrectly loaded base state");
    
}


- (void)testChangingExperimentValue {
    VENExperiment *experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertFalse([experiment enabled], @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.name, @"Some Experiment Title", @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.identifier, @"VEN_EXPERIMENT_SOME_EXPERIMENT", @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.details, @"Some details 2", @"Incorrectly loaded base state");
    
    [VENExperimentsManager setExperimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT isEnabled:YES];
    experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertTrue([experiment enabled], @"Changing experiment state was not reflected correctly");
    [VENExperimentsManager deleteAllUserSettings];
}


- (void)testDeletingUserData {
    
    VENExperiment *experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertFalse([experiment enabled], @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.name, @"Some Experiment Title", @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.identifier, @"VEN_EXPERIMENT_SOME_EXPERIMENT", @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.details, @"Some details 2", @"Incorrectly loaded base state");
    
    [VENExperimentsManager setExperimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT isEnabled:YES];
    experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertTrue([experiment enabled], @"Changing experiment state was not reflected correctly");
    [VENExperimentsManager deleteAllUserSettings];
    
    experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertFalse([experiment enabled], @"Incorrectly loaded base state");
}

@end
