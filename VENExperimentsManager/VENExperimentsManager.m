#import "VENExperimentsManager.h"
#import "VENExperiment.h"

#define VEN_KEY_LOCAL_EXPERIMENT_VALUES @"com.venmo.experiments.manager.overrides"

NSString *const VENExperimentEnabledNotificationUserInfoKey = @"VENExperimentEnabledNotificationUserInfoKey";
NSString *const VENExperimentOptionNotificationUserInfoKey  = @"VENExperimentOptionNotificationUserInfoKey";

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
        if (![experimentsManager startExperimentsManagerWithPlistName:plistName]) {
            experimentsManager = nil;
        }
    });
}


+ (VENExperimentsManager *)sharedExperimentsManager {
    return experimentsManager;
}


- (BOOL)startExperimentsManagerWithPlistName:(NSString *)plistName {
    self.initialized    = NO;
    self.configurationFileName  = plistName;
    
    self.experiments = [self initialStateForPlist:plistName];
    
    if (!self.experiments || ![self.experiments count]) {
        return NO;
    }
    
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    NSArray *localExperiments   = [defaults objectForKey:[self persistenceKeyForCurrentConfigurationFile]];
    
    for (NSDictionary *experimentDictionary in localExperiments) {
        VENExperiment *experiment = [[VENExperiment alloc] initWithIdentifier:nil
                                                   andConfigurationDictionary:experimentDictionary];
        VENExperiment *baseExp = self.experiments[experiment.identifier];
        
        if (baseExp) {
            
            // Always update some basic fields
            experiment.userEditable = baseExp.userEditable;
            experiment.details      = baseExp.details;
            experiment.options      = baseExp.options;
            
            if (baseExp.forceUpdate) {
                experiment.forceUpdate = YES;
                experiment.enabled = baseExp.enabled;
                experiment.userEditable = baseExp.userEditable;
                experiment.selectedOption = baseExp.selectedOption;
                experiment.stable   = baseExp.stable;
            }
            // If the new options make the previous selection invalid
            else if (!experiment.options[experiment.selectedOption]) {
                experiment.selectedOption = baseExp.selectedOption;
            }
            
            self.experiments[experiment.identifier] = experiment;
        }
        else {
            // Do not add experiments in UserDefaults which are not in the plist
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
        VENExperiment *experiment = [[VENExperiment alloc] initWithIdentifier:experimentIdentifier andConfigurationDictionary:experimentsDictionary[experimentIdentifier]];
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
        VENExperiment *experiment = self.experiments[experimentIdentifier];
        [experimentDictionaries addObject:[experiment dictionaryRepresentation]];
    }
    
    [defaults setObject:experimentDictionaries forKey:[self persistenceKeyForCurrentConfigurationFile]];
    [defaults synchronize];
}


- (NSArray *)allExperiments {
    return [self.experiments allValues];
}


- (VENExperiment *)experimentWithIdentifier:(NSString *)experimentIdentifier {
    if (![[self class] experimentationEnabled]) {
        return NO;
    }
    
    VENExperiment *experiment = self.experiments[experimentIdentifier];
    return experiment;
}


- (BOOL)experimentIsEnabled:(NSString *)experimentIdentifier {
    if (![[self class] experimentationEnabled]) {
        return NO;
    }
    
    return [[self experimentWithIdentifier:experimentIdentifier] enabled];
}


- (void)setExperimentWithIdentifier:(NSString *)experimentIdentifier isEnabled:(BOOL)enabled {
    VENExperiment *experiment = [self experimentWithIdentifier:experimentIdentifier];
    [experiment setEnabled:enabled];
    self.experiments[experiment.identifier] = experiment;
    
    [self persistExperimentStates];
}


- (void)setSelectdOptionForExperimentWithIdentifier:(NSString *)experimentIdentifier
                                    selectedOptions:(NSString *)selectedOption {
    VENExperiment *experiment = [self experimentWithIdentifier:experimentIdentifier];
    experiment.selectedOption = selectedOption;
    self.experiments[experiment.identifier] = experiment;
    
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
    return [[[self sharedExperimentsManager] experimentWithIdentifier:experimentIdentifier] enabled] ?: NO;
}

+ (NSString *)selectedOptionForExperiment:(NSString *)experimentIdentifier {
    return [[[self sharedExperimentsManager] experimentWithIdentifier:experimentIdentifier] selectedOption];
}


+ (void)setExperimentWithIdentifier:(NSString *)experimentIdentifier isEnabled:(BOOL)enabled {
    [[self sharedExperimentsManager] setExperimentWithIdentifier:experimentIdentifier isEnabled:enabled];
}

+ (void)setSelectdOptionForExperimentWithIdentifier:(NSString *)experimentIdentifier
                                    selectedOption:(NSString *)selectedOption {
    [[self sharedExperimentsManager] setSelectdOptionForExperimentWithIdentifier:experimentIdentifier
                                                                 selectedOptions:selectedOption];
}


+ (void)deleteAllUserSettings {
    [[self sharedExperimentsManager] deleteAllUserSettings];
}


+ (NSArray *)allExperiments {
    return [[self sharedExperimentsManager] allExperiments];
}


+ (BOOL)experimentationEnabled {
    return [[VENExperimentsManager sharedExperimentsManager] initialized];
}


+ (NSString *)experimentEnabledChangedNotificationsKeyForIdentifier:(NSString *)identifier {
    return [identifier stringByAppendingString:@"_ENABLED_CHANGED_NOTIFICATION_KEY"];
}


+ (NSString *)experimentOptionChangedNotificationsKeyForIdentifier:(NSString *)identifier {
    return [identifier stringByAppendingString:@"_OPTION_CHANGED_NOTIFICATION_KEY"];
}

@end
