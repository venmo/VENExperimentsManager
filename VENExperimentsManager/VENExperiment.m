//
//  VENExperiment.m
//  VENExperimentsManager
//
//  Created by Chris Maddern on 12/21/13.
//  Copyright (c) 2013 Venmo. All rights reserved.
//

#import "VENExperiment.h"

#define VEN_KEY_EXPERIMENT_IDENTIFIER       @"VEN_EXPERIMENT_IDENTIFIER"
#define VEN_KEY_EXPERIMENT_NAME             @"VEN_EXPERIMENT_NAME"
#define VEN_KEY_EXPERIMENT_ENABLED_VALUE    @"VEN_EXPERIMENT_ENABLED"
#define VEN_KEY_EXPERIMENT_USER_EDITABLE    @"VEN_EXPERIMENT_USER_EDITABLE"
#define VEN_KEY_EXPERIMENT_FORCE_UPDATE     @"VEN_EXPERIMENT_FORCE_UPDATE"
#define VEN_KEY_EXPERIMENT_STABLE           @"VEN_EXPERIMENT_STABLE"

@implementation VENExperiment

- (instancetype)initWithIdentifier:(NSString *)identifier andConfigurationDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        
        if (identifier) {
            self.identifier = identifier;
        }
        else if ([dictionary objectForKey:VEN_KEY_EXPERIMENT_IDENTIFIER]) {
            self.identifier = [dictionary objectForKey:VEN_KEY_EXPERIMENT_IDENTIFIER];
        }
        
        self.name       = [dictionary objectForKey:VEN_KEY_EXPERIMENT_NAME] ?: @"Unknown";
        
        NSNumber *boolNumber = [dictionary objectForKey:VEN_KEY_EXPERIMENT_ENABLED_VALUE];
        if (boolNumber != nil) {
            self.enabled = [boolNumber boolValue];
        }
        
        boolNumber = [dictionary objectForKey:VEN_KEY_EXPERIMENT_USER_EDITABLE];
        if (boolNumber != nil) {
            self.userEditable = [boolNumber boolValue];
        }
        
        boolNumber = [dictionary objectForKey:VEN_KEY_EXPERIMENT_FORCE_UPDATE];
        if (boolNumber != nil) {
            self.forceUpdate = [boolNumber boolValue];
        }
        
        boolNumber = [dictionary objectForKey:VEN_KEY_EXPERIMENT_STABLE];
        if (boolNumber != nil) {
            self.stable = [boolNumber boolValue];
        }
    }
    return self;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:[NSNumber numberWithBool:self.enabled] forKey:VEN_KEY_EXPERIMENT_ENABLED_VALUE];
    [dictionary setObject:[NSNumber numberWithBool:self.userEditable] forKey:VEN_KEY_EXPERIMENT_USER_EDITABLE];
    [dictionary setObject:[NSNumber numberWithBool:self.forceUpdate] forKey:VEN_KEY_EXPERIMENT_FORCE_UPDATE];
    [dictionary setObject:[NSNumber numberWithBool:self.stable] forKey:VEN_KEY_EXPERIMENT_STABLE];
    [dictionary setObject:self.identifier forKey:VEN_KEY_EXPERIMENT_IDENTIFIER];
    [dictionary setObject:self.name forKey:VEN_KEY_EXPERIMENT_NAME];
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

@end
