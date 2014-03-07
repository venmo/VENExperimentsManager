#import <Foundation/Foundation.h>

@interface VENExperiment : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) NSDictionary *properties;
@property (nonatomic, strong) NSDictionary *options;
@property (nonatomic, strong) NSString *selectedOption;

@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL userEditable;
@property (nonatomic) BOOL stable;
@property (nonatomic) BOOL forceUpdate;


- (instancetype)initWithIdentifier:(NSString *)identifier andConfigurationDictionary:(NSDictionary *)dictionary;


- (NSDictionary *)dictionaryRepresentation;


/**
 Get the human readable description of the currently selected options
 @return NSString of the description for the selected option. nil if there are no options or none are selected
 **/
- (NSString *)selectedOptionDescription;


/**
 Determine whether the experiment supports options
 @return BOOL whether the experiment supports options
 **/
- (BOOL)supportsOptions;

@end
