//
//  VENExperiment.h
//  VENExperimentsManager
//
//  Created by Chris Maddern on 12/21/13.
//  Copyright (c) 2013 Venmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VENExperiment : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSDictionary *properties;
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL userEditable;
@property (nonatomic) BOOL stable;
@property (nonatomic) BOOL forceUpdate;


- (instancetype)initWithIdentifier:(NSString *)identifier andConfigurationDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)dictionaryRepresentation;

@end
