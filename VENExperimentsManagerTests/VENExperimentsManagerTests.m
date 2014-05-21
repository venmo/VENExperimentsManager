#import <XCTest/XCTest.h>
#import "VENExperimentsManager.h"
#import "VENTestExperiments.h"

@interface VENExperimentsManager (Private)

- (BOOL)startExperimentsManagerWithPlistName:(NSString *)plistName;
- (VENExperiment *)experimentWithIdentifier:(NSString *)experimentIdentifier;
- (BOOL)experimentIsEnabled:(NSString *)experimentIdentifier;
- (void)setExperimentWithIdentifier:(NSString *)experimentIdentifier isEnabled:(BOOL)enabled;
- (void)setSelectedOptionForExperimentWithIdentifier:(NSString *)experimentIdentifier
                                     selectedOptions:(NSString *)selectedOption;

@end

@interface VENExperimentsManagerTests : XCTestCase

@end

@implementation VENExperimentsManagerTests

- (void)setUp {
    [VENExperimentsManager startExperimentsManagerWithPlistName:@"testExperiments"];
    [VENExperimentsManager deleteAllUserSettings];
    [super setUp];
}

- (void)tearDown {

    [VENExperimentsManager deleteAllUserSettings];

    [super tearDown];
}


- (void)testExperimentManagerCreation {
    VENExperiment *experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertFalse([experiment enabled], @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.name, @"Some Experiment Title", @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.identifier, @"VEN_EXPERIMENT_SOME_EXPERIMENT", @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.details, @"Some details 2", @"Incorrectly loaded base state");

    experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_AUTO_UPDATE];
    XCTAssertNotNil(experiment, @"Should return an experiment that exists");
    XCTAssertTrue([experiment enabled], @"Should load correctly with correct test file");
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


- (void)testNoConfigurationCausesNoTests {
    VENExperimentsManager *experimentsManager = [[VENExperimentsManager alloc] init];
    BOOL configured = [experimentsManager startExperimentsManagerWithPlistName:@"testExperiments"];

    XCTAssertTrue(configured, @"Could not configure new experiments manager");

    VENExperiment *experiment = [experimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertFalse([experiment enabled], @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.name, @"Some Experiment Title", @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.identifier, @"VEN_EXPERIMENT_SOME_EXPERIMENT", @"Incorrectly loaded base state");
    experiment = [experimentsManager experimentWithIdentifier:VEN_EXPERIMENT_AUTO_UPDATE];
    XCTAssertNotNil(experiment, @"Should return an experiment that exists");
    XCTAssertTrue([experiment enabled], @"Should load correctly with correct test file");

    experimentsManager = [[VENExperimentsManager alloc] init];
    configured = [experimentsManager startExperimentsManagerWithPlistName:@"testExperimentsFAKE"];

    XCTAssertFalse(configured, @"Could not configure new experiments manager");
    experiment = [experimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertNil(experiment, @"Should not return an experiment that does not exist");
    XCTAssertFalse([experiment enabled], @"enabled on nil should return FALSE");
    XCTAssertFalse([experimentsManager experimentIsEnabled:VEN_EXPERIMENT_AUTO_UPDATE], @"Should not enable a non-existant experiment");

}


- (void)testNoConfigurationCausesFalseResponseToAllTests {

    VENExperimentsManager *experimentsManager = [[VENExperimentsManager alloc] init];
    BOOL configured = [experimentsManager startExperimentsManagerWithPlistName:@"testExperiments"];

    XCTAssertTrue(configured, @"Could not configure new experiments manager");

    VENExperiment *experiment = [experimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];
    XCTAssertFalse([experiment enabled], @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.name, @"Some Experiment Title", @"Incorrectly loaded base state");
    XCTAssertEqualObjects(experiment.identifier, @"VEN_EXPERIMENT_SOME_EXPERIMENT", @"Incorrectly loaded base state");

    experimentsManager = [[VENExperimentsManager alloc] init];
    configured = [experimentsManager startExperimentsManagerWithPlistName:@"testExperimentsFAKE"];

    XCTAssertFalse(configured, @"Could not configure new experiments manager");

    XCTAssertFalse([experimentsManager experimentIsEnabled:VEN_EXPERIMENT_SOME_EXPERIMENT], @"Should not enable a non-existant experiment");
    XCTAssertFalse([experimentsManager experimentIsEnabled:VEN_EXPERIMENT_AUTO_UPDATE], @"Should not enable an experiment when there is no config file");
}


- (void)testOptionsAreLoadedIntoExperiments {
    VENExperimentsManager *experimentsManager = [[VENExperimentsManager alloc] init];
    [experimentsManager startExperimentsManagerWithPlistName:@"testExperiments"];

    VENExperiment *experiment = [experimentsManager experimentWithIdentifier:VEN_EXPERIMENT_PAYMENT_SCREEN];
    XCTAssertTrue([experiment.options count] == 3, @"Incorrectly loaded options");
    XCTAssertEqualObjects(experiment.selectedOption, VEN_EXPERIMENT_PAYMENT_SCREEN_PROTO_1, @"Incorrectly loaded selectedOption");

    XCTAssertEqualObjects([experiment selectedOptionDescription], @"Prototype 1", @"Incorrectly loaded or calculated selected option description");

    [experimentsManager setSelectedOptionForExperimentWithIdentifier:VEN_EXPERIMENT_PAYMENT_SCREEN selectedOptions:VEN_EXPERIMENT_PAYMENT_SCREEN_PROTO_2];

    experimentsManager = [[VENExperimentsManager alloc] init];
    [experimentsManager startExperimentsManagerWithPlistName:@"testExperiments"];

    experiment = [experimentsManager experimentWithIdentifier:VEN_EXPERIMENT_PAYMENT_SCREEN];

    XCTAssertEqualObjects(experiment.selectedOption, VEN_EXPERIMENT_PAYMENT_SCREEN_PROTO_2, @"Incorrectly loaded selectedOption after saving");
    XCTAssertEqualObjects([experiment selectedOptionDescription], @"Prototype 2", @"Incorrectly loaded or calculated selected option description after saving");

    [experimentsManager setSelectedOptionForExperimentWithIdentifier:VEN_EXPERIMENT_PAYMENT_SCREEN selectedOptions:VEN_EXPERIMENT_PAYMENT_SCREEN_PROTO_1];

    experiment = [experimentsManager experimentWithIdentifier:VEN_EXPERIMENT_PAYMENT_SCREEN];

    XCTAssertEqualObjects(experiment.selectedOption, VEN_EXPERIMENT_PAYMENT_SCREEN_PROTO_1, @"Incorrectly loaded selectedOption");
    XCTAssertEqualObjects([experiment selectedOptionDescription], @"Prototype 1", @"Incorrectly loaded or calculated selected option description");

}


- (void)testASelectedOptionCannotBeSetIfItDoesntExistInOptions {
    VENExperimentsManager * experimentsManager = [[VENExperimentsManager alloc] init];
    [experimentsManager startExperimentsManagerWithPlistName:@"testExperiments"];

    [experimentsManager setSelectedOptionForExperimentWithIdentifier:VEN_EXPERIMENT_PAYMENT_SCREEN selectedOptions:VEN_EXPERIMENT_PAYMENT_SCREEN_PROTO_3_DOESNT_EXIST];

    VENExperiment *experiment = [experimentsManager experimentWithIdentifier:VEN_EXPERIMENT_PAYMENT_SCREEN];

    XCTAssertEqualObjects(experiment.selectedOption, VEN_EXPERIMENT_PAYMENT_SCREEN_PROTO_1, @"Incorrectly loaded selectedOption");
    XCTAssertEqualObjects([experiment selectedOptionDescription], @"Prototype 1", @"Incorrectly loaded or calculated selected option description");
}


- (void)testSupportsOptionsCorrectlyDeterminesWhetherOptionsAreSupported {
    VENExperimentsManager * experimentsManager = [[VENExperimentsManager alloc] init];
    [experimentsManager startExperimentsManagerWithPlistName:@"testExperiments"];

    VENExperiment *experiment = [experimentsManager experimentWithIdentifier:VEN_EXPERIMENT_PAYMENT_SCREEN];

    XCTAssertTrue([experiment supportsOptions], @"An experiment with options should support options");

    experiment = [experimentsManager experimentWithIdentifier:VEN_EXPERIMENT_AUTO_UPDATE];
    XCTAssertFalse([experiment supportsOptions], @"An experiment with no options should not support options");

}

@end
