#import "VENExperimentsSettingsTVC.h"
#import "VENExperimentsManager.h"
#import "VENExperimentTableViewCell.h"

@interface VENExperimentsSettingsTVC ()

@property (nonatomic, strong) NSIndexPath *lastSelectedIndexPath;

@end

@implementation VENExperimentsSettingsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Experiments", nil);

    NSArray *experiments = [VENExperimentsManager allExperiments];
    self.stableExperiments = [NSMutableArray array];
    self.unstableExperiments = [NSMutableArray array];
    
    for (VENExperiment *experiment in experiments) {
        if (experiment.stable) {
            [self.stableExperiments addObject:experiment];
        }
        else {
            [self.unstableExperiments addObject:experiment];
        }
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENExperimentTableViewCell" bundle:nil] forCellReuseIdentifier:@"VENExperimentTableViewCell"];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.numberOfLines = 0;
    label.frame = CGRectMake(20, 10, 280, 60);
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"Most experiments will not take effect until application restart.";
    [footerView addSubview:label];
    
    self.tableView.tableFooterView = footerView;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView indexPathForSelectedRow] isEqual:indexPath]) {
        VENExperiment *experiment;
        if (indexPath.section == 0) {
            experiment = self.stableExperiments[indexPath.row];
        }
        else if (indexPath.section == 1) {
            experiment = self.unstableExperiments[indexPath.row];
        }
        
        return 100 + ([experiment supportsOptions] ? 50 : 0);
    }
    return 44;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.stableExperiments count] + [self.unstableExperiments count] > 0 ? 2 : 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [self.stableExperiments count];
            break;
        case 1:
            return [self.unstableExperiments count];
            break;
        default:
            return 0;
            break;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Stable";
    }
    return @"Unstable";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"VENExperimentTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    VENExperiment *experiment;
    
    switch ([indexPath section]) {
        case 0:
            experiment = [self.stableExperiments objectAtIndex:[indexPath row]];
            break;
        case 1:
            experiment = [self.unstableExperiments objectAtIndex:[indexPath row]];
            break;
        default:
            break;
    }
    
    [((VENExperimentTableViewCell *) cell) configureWithExperiment:experiment];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([indexPath isEqual:self.lastSelectedIndexPath]) {
        [self.view endEditing:YES];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.lastSelectedIndexPath = nil;
    }
    else {
        self.lastSelectedIndexPath = indexPath;
    }
    
    [tableView beginUpdates];
    [tableView endUpdates];
}

@end
