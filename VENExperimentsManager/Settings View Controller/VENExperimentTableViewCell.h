#import <UIKit/UIKit.h>
#import "VENExperimentsManager.h"

@interface VENExperimentTableViewCell : UITableViewCell

@property (nonatomic, strong) VENExperiment *experiment;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailsLabel;
@property (nonatomic, strong) IBOutlet UISwitch *enabledSwitch;

- (void)configureWithExperiment:(VENExperiment *)experiment;

@end
