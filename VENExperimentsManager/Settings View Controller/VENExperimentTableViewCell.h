#import <UIKit/UIKit.h>
#import "VENExperimentsManager.h"

@interface VENExperimentTableViewCell : UITableViewCell <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) VENExperiment *experiment;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailsLabel;
@property (nonatomic, strong) IBOutlet UISwitch *enabledSwitch;

@property (nonatomic, strong) IBOutlet UILabel *optionsLabel;
@property (nonatomic, strong) IBOutlet UITextField *optionsField;

- (void)configureWithExperiment:(VENExperiment *)experiment;

@end
