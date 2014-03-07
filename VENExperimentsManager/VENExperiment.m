#import "VENExperiment.h"

#define VEN_KEY_EXPERIMENT_IDENTIFIER       @"VEN_EXPERIMENT_IDENTIFIER"
#define VEN_KEY_EXPERIMENT_NAME             @"VEN_EXPERIMENT_NAME"
#define VEN_KEY_EXPERIMENT_ENABLED_VALUE    @"VEN_EXPERIMENT_ENABLED"
#define VEN_KEY_EXPERIMENT_USER_EDITABLE    @"VEN_EXPERIMENT_USER_EDITABLE"
#define VEN_KEY_EXPERIMENT_FORCE_UPDATE     @"VEN_EXPERIMENT_FORCE_UPDATE"
#define VEN_KEY_EXPERIMENT_STABLE           @"VEN_EXPERIMENT_STABLE"
#define VEN_KEY_EXPERIMENT_DETAILS          @"VEN_EXPERIMENT_DETAILS"
#define VEN_KEY_EXPERIMENT_DEFAULT_OPTION   @"VEN_EXPERIMENT_DEFAULT_OPTION"
#define VEN_KEY_EXPERIMENT_OPTIONS          @"VEN_EXPERIMENT_OPTIONS"

@implementation VENExperiment

- (instancetype)initWithIdentifier:(NSString *)identifier andConfigurationDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        
        if (identifier) {
            self.identifier = identifier;
        }
        else if (dictionary[VEN_KEY_EXPERIMENT_IDENTIFIER]) {
            self.identifier = dictionary[VEN_KEY_EXPERIMENT_IDENTIFIER];
        }
        
        self.name           = dictionary[VEN_KEY_EXPERIMENT_NAME] ?: @"Unknown";
        self.details        = dictionary[VEN_KEY_EXPERIMENT_DETAILS] ?: @"No experiment details";
        self.options        = dictionary[VEN_KEY_EXPERIMENT_OPTIONS] ?: @{};
        
        NSString *selectedOption = dictionary[VEN_KEY_EXPERIMENT_DEFAULT_OPTION];
        if (selectedOption && [self.options count] && self.options[selectedOption]) {
            self.selectedOption = selectedOption;
        }
        
        NSNumber *boolNumber = dictionary[VEN_KEY_EXPERIMENT_ENABLED_VALUE];
        if (boolNumber != nil) {
            self.enabled = [boolNumber boolValue];
        }
        
        boolNumber = dictionary[VEN_KEY_EXPERIMENT_USER_EDITABLE];
        if (boolNumber != nil) {
            self.userEditable = [boolNumber boolValue];
        }
        
        boolNumber = dictionary[VEN_KEY_EXPERIMENT_FORCE_UPDATE];
        if (boolNumber != nil) {
            self.forceUpdate = [boolNumber boolValue];
        }
        
        boolNumber = dictionary[VEN_KEY_EXPERIMENT_STABLE];
        if (boolNumber != nil) {
            self.stable = [boolNumber boolValue];
        }
    }
    return self;
}


- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    dictionary[VEN_KEY_EXPERIMENT_NAME]             = self.name;
    dictionary[VEN_KEY_EXPERIMENT_IDENTIFIER]       = self.identifier;
    dictionary[VEN_KEY_EXPERIMENT_STABLE]           = [NSNumber numberWithBool:self.stable];
    dictionary[VEN_KEY_EXPERIMENT_FORCE_UPDATE]     = [NSNumber numberWithBool:self.forceUpdate];
    dictionary[VEN_KEY_EXPERIMENT_USER_EDITABLE]    = [NSNumber numberWithBool:self.userEditable];
    dictionary[VEN_KEY_EXPERIMENT_ENABLED_VALUE]    = [NSNumber numberWithBool:self.enabled];
    
    
    if (self.details) {
        dictionary[VEN_KEY_EXPERIMENT_DETAILS]      = self.details;
    }
    if (self.options) {
        dictionary[VEN_KEY_EXPERIMENT_OPTIONS]      = self.options;
    }
    if (self.selectedOption) {
        dictionary[VEN_KEY_EXPERIMENT_DEFAULT_OPTION] = self.selectedOption;
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}


- (NSString *)selectedOptionDescription {
    if (self.selectedOption && [self.options count]) {
        return self.options[self.selectedOption];
    }
    return nil;
}


- (void)setSelectedOption:(NSString *)selectedOption {
    if (selectedOption && [self.options count] && self.options[selectedOption]) {
        _selectedOption = selectedOption;
    }
}


- (BOOL)supportsOptions {
    return [self.options count] > 0 ? YES : NO;
}

@end
