//
//  VENExperimentsManager.m
//  VenmoClient
//
//  Created by Chris Maddern on 9/29/13.
//  Copyright (c) 2013 Venmo. All rights reserved.
//

#import "VENExperimentsManager.h"
#import "VENExperiment.h"

#define VEN_KEY_LOCAL_EXPERIMENT_VALUES @"com.venmo.experiments.manager.overrides"

static VENExperimentsManager *experimentsManager = nil;

@interface VENExperimentsManager () {}

@property (nonatomic, strong) NSMutableDictionary *experiments;

- (VENExperiment *)experimentWithIdentifier:(NSString *)experimentIdentifier;
- (BOOL)experimentIsEnabled:(NSString *)experimentIdentifier;

@end

@implementation VENExperimentsManager


+ (void)startExperimentsManagerWithPlistName:(NSString *)plistName {
    
    static dispatch_once_t once;
    
    dispatch_once(&once, ^ {
        experimentsManager = [[self alloc] init];
        [experimentsManager loadLocalConfigurationWithDefault:plistName];
    });
}


+ (VENExperimentsManager *)sharedExperimentsManager {
    return experimentsManager;
}


- (BOOL)loadLocalConfigurationWithDefault:(NSString *)plistName {
    self.initialized    = NO;
    self.configurationFileName  = plistName;
    
    self.experiments = [self initialStateForPlist:plistName];
    
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    NSArray *localExperiments   = [defaults objectForKey:[self persistenceKeyForCurrentConfigurationFile]];
    
    for (NSDictionary *experimentDictionary in localExperiments) {
        VENExperiment *experiment = [[VENExperiment alloc] initWithIdentifier:nil
                                                   andConfigurationDictionary:experimentDictionary];
        
        if (![self experimentWithIdentifier:experiment.identifier]) {
            [self.experiments setObject:experiment forKey:experiment.identifier];
        }
    }
    
    [self persistExperimentStates];
    self.initialized = YES;
    
    return YES;
}


- (NSMutableDictionary *)initialStateForPlist:(NSString *)plistName {
    NSBundle *bundle = [NSBundle mainBundle];
    bundle = [NSBundle bundleForClass:[self class]];
    
    NSString *plistPath = [bundle pathForResource:plistName ofType:@"plist"];
    NSDictionary *experimentsDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    NSMutableDictionary *experimentObjects = [NSMutableDictionary dictionary];
    for (NSString *experimentIdentifier in experimentsDictionary) {
        VENExperiment *experiment = [[VENExperiment alloc] initWithIdentifier:experimentIdentifier andConfigurationDictionary:[experimentsDictionary objectForKey:experimentIdentifier]];
        if (experiment) {
            [experimentObjects setObject:experiment forKey:experimentIdentifier];
        }
    }
    
    if (![experimentObjects count]) {
        return nil;
    }
    return experimentObjects;
}


- (void)persistExperimentStates {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *experimentDictionaries = [NSMutableArray array];
    
    for (NSString *experimentIdentifier in [self.experiments allKeys]) {
        VENExperiment *experiment = [self.experiments objectForKey:experimentIdentifier];
        [experimentDictionaries addObject:[experiment dictionaryRepresentation]];
    }
    
    [defaults setObject:experimentDictionaries forKey:[self persistenceKeyForCurrentConfigurationFile]];
    [defaults synchronize];
}


- (NSArray *)allExperiments {
    return [self.experiments allValues];
}


- (VENExperiment *)experimentWithIdentifier:(NSString *)experimentIdentifier {
    if (!self.initialized) {
        return nil;
    }
    
    VENExperiment *experiment = [self.experiments objectForKey:experimentIdentifier];
    return experiment;
}


- (BOOL)experimentIsEnabled:(NSString *)experimentIdentifier {
    return [[self experimentWithIdentifier:experimentIdentifier] enabled];
}


- (void)setExperimentWithIdentifier:(NSString *)experimentIdentifier isEnabled:(BOOL)enabled {
    VENExperiment *experiment = [self experimentWithIdentifier:experimentIdentifier];
    [experiment setEnabled:enabled];
    [self.experiments setObject:experiment forKey:experiment.identifier];
    
    [self persistExperimentStates];
}


- (void)deleteAllUserSettings {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:[self persistenceKeyForCurrentConfigurationFile]];
    [userDefaults synchronize];
    
    self.experiments = [self initialStateForPlist:self.configurationFileName];
}

#pragma mark - Helper methods

- (NSString *)persistenceKeyForCurrentConfigurationFile {
    return [NSString stringWithFormat:@"%@-%@", VEN_KEY_LOCAL_EXPERIMENT_VALUES, self.configurationFileName];
}


#pragma mark - Static Accessors

+ (VENExperiment *)experimentWithIdentifier:(NSString *)experimentIdentifier {
    return [[self sharedExperimentsManager] experimentWithIdentifier:experimentIdentifier];
}


+ (BOOL)experimentIsEnabled:(NSString *)experimentIdentifier {
    return [[[self sharedExperimentsManager] experimentWithIdentifier:experimentIdentifier] enabled];
}


+ (void)setExperimentWithIdentifier:(NSString *)experimentIdentifier isEnabled:(BOOL)enabled {
    [[self sharedExperimentsManager] setExperimentWithIdentifier:experimentIdentifier isEnabled:enabled];
}


+ (void)deleteAllUserSettings {
    [[self sharedExperimentsManager] deleteAllUserSettings];
}


+ (NSArray *)allExperiments {
    return [[self sharedExperimentsManager] allExperiments];
}


@end
