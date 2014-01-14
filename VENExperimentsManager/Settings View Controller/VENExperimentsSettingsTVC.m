#import "VENExperimentsSettingsTVC.h"
#import "VENExperimentsManager.h"
#import "VENExperimentTableViewCell.h"

@interface VENExperimentsSettingsTVC ()

@end

@implementation VENExperimentsSettingsTVC

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"VENExperimentTableViewCell" bundle:nil] forCellReuseIdentifier:@"VENExperimentTableViewCell"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSString *)title {
    return @"Experiments";
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[tableView indexPathForSelectedRow] isEqual:indexPath]) {
        return 100;
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
    [tableView beginUpdates];
    [tableView endUpdates];
}

@end
