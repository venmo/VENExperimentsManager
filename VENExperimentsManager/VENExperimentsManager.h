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


/**
 Determines whether an experiment with a specified identifier is currently enabled
 @return BOOL representing whether the experiment is enabled
 @note This is a convenience method for [[[VENExperimentsManager sharedExperimentsManager] experimentWithIdentifier:experimentIdentifier] enabled]
 **/
+ (BOOL)experimentIsEnabled:(NSString *)experimentIdentifier;


/**
 Returns the selected option for an experiment which supports options. Returns nil otherwise.
 @return NSString with the key for the selected option for this experiment
 @note This will return a selectedOption whether or not the experiment is enabled
 **/
+ (NSString *)selectedOptionForExperiment:(NSString *)experimentIdentifier;


/**
 Resets all experiment states to those in the plist file in the bundle discarding any user overrides
 @warning This cannot be undone
 **/
+ (void)deleteAllUserSettings;


/**
 Determines whether experimentation is enabled
 @return BOOL indicating whether experimentation is enabled
 @note when experimentation is not enabled, experimentIsEnabled: will return NO for all experiments
**/
+ (BOOL)experimentationEnabled;


/**
 Determines whether experimentation is enabled
 @param experimentIdentifier The experiment to set the enabled state for
 @param enabled The new state for the designated experiment
 **/
+ (void)setExperimentWithIdentifier:(NSString *)experimentIdentifier isEnabled:(BOOL)enabled;


/**
 Sets the selected option for an experiment that supports options. Does nothing if not.
 @param experimentIdentifier The experiment to set the enabled state for
 @param selectedOption The key for the selected experiment option
 **/
+ (void)setSelectedOptionForExperimentWithIdentifier:(NSString *)experimentIdentifier
                                    selectedOption:(NSString *)selectedOption;

@end
