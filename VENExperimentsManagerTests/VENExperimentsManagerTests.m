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

@interface VENExperimentsManager (Private)

- (BOOL)loadLocalConfigurationWithDefault:(NSString *)plistName;
- (VENExperiment *)experimentWithIdentifier:(NSString *)experimentIdentifier;
- (BOOL)experimentIsEnabled:(NSString *)experimentIdentifier;

@end

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
    
    experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_AUTO_UPDATE];
    XCTAssertNotNil(experiment, @"Should return an experiment that exists");
    XCTAssertTrue([experiment enabled], @"Should load correctly with correct test file");
}


- (void)testChangingExperimentValue {
    VENExperiment *experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertFalse([experiment enabled], @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.name, @"Some Experiment Title", @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.identifier, @"VEN_EXPERIMENT_SOME_EXPERIMENT", @"Incorrectly loaded base state");
    
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
    
    [VENExperimentsManager setExperimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT isEnabled:YES];
    experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertTrue([experiment enabled], @"Changing experiment state was not reflected correctly");
    [VENExperimentsManager deleteAllUserSettings];
    
    experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertFalse([experiment enabled], @"Incorrectly loaded base state");
}


- (void)testNoConfigurationCausesNoTests {
    VENExperimentsManager *experimentsManager = [[VENExperimentsManager alloc] init];
    BOOL configured = [experimentsManager loadLocalConfigurationWithDefault:@"testExperiments"];
    
    XCTAssertTrue(configured, @"Could not configure new experiments manager");
    
    VENExperiment *experiment = [experimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertFalse([experiment enabled], @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.name, @"Some Experiment Title", @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.identifier, @"VEN_EXPERIMENT_SOME_EXPERIMENT", @"Incorrectly loaded base state");
    experiment = [experimentsManager experimentWithIdentifier:VEN_EXPERIMENT_AUTO_UPDATE];
    XCTAssertNotNil(experiment, @"Should return an experiment that exists");
    XCTAssertTrue([experiment enabled], @"Should load correctly with correct test file");
    
    experimentsManager = [[VENExperimentsManager alloc] init];
    configured = [experimentsManager loadLocalConfigurationWithDefault:@"testExperimentsFAKE"];
    
    XCTAssertFalse(configured, @"Could not configure new experiments manager");
    experiment = [experimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertNil(experiment, @"Should not return an experiment that does not exist");
    XCTAssertFalse([experiment enabled], @"enabled on nil should return FALSE");
    XCTAssertFalse([experimentsManager experimentIsEnabled:VEN_EXPERIMENT_AUTO_UPDATE], @"Should not enable a non-existant experiment");
    
}
@end
