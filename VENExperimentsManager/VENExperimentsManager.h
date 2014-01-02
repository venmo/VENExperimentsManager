//
//  VENExperimentsManager.h
//  VenmoClient
//
//  Created by Chris Maddern on 9/29/13.
//  Copyright (c) 2013 Venmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VENExperiment.h"

@interface VENExperimentsManager : NSObject

@property (nonatomic) BOOL initialized;
@property (nonatomic, strong) NSString *configurationFileName;

#pragma mark - Initializers -
+ (void)startExperimentsManagerWithPlistName:(NSString *)plistName;

#pragma mark - Experiment Management -

+ (NSArray *)allExperiments;
+ (VENExperiment *)experimentWithIdentifier:(NSString *)experimentIdentifier;
+ (BOOL)experimentIsEnabled:(NSString *)experimentIdentifier;
+ (void)deleteAllUserSettings;

+ (void)setExperimentWithIdentifier:(NSString *)experimentIdentifier isEnabled:(BOOL)enabled;

@end
