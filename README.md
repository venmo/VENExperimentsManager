## VENExperimentsManager<img src="http://f.cl.ly/items/2Y1o3X3s3X2Q1w2h0U10/AutoUpdates.png" align="right" width="260" align="right" style="padding-top:-20px; padding-left:20px;" />

VENExperimentsManager enables easy definition, management and control of experiments within an iOS app including the following:
- Define experiments and 'experiment flag' code
- Allow users to turn experiments on and off
- Force turn-on or off experiments
- Make experiments user-editable or fixed
- Let users know whether experiments are 'stable' or 'unstable'

### Usage

```objc
[VENExperimentsManager startExperimentsManagerWithPlistName:@"testExperiments"];
```

Then you can access experiments as follows..
```objc
VENExperiment *experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];

// Or if you just want to know if it's enabled
[VENExperimentsManager experimentIsEnabled:VEN_EXPERIMENT_SOME_EXPERIMENT];
```

Multi-option experiments (new in `v0.2.0`) can be used as follows..

```objc
NSString *selectedOptionForExperiment = [VENExperimentsManager selectedOptionForExperiment:VEN_EXPERIMENT_SOME_EXPERIMENT];

// Or you can get the experiment and inspect it..
VENExperiment *experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];

// Determine if the experiment has options
BOOL hasOptions = [experiment supportsOptions];

// Get the selected option
NSString *selectedOption = [experiment selectedOption];

// Get the readable description of the selected option
[experiment selectedOptionDescription];

```

The plist file defining experiments is a dictionary of experiment-identifier : experiment-definition dictionaries. It can be easily configured in XCode.

<img src="http://f.cl.ly/items/2Q2g0B2R1v0J322q1534/ExperimentsXCode.png" align="middle" width="500" />


A sample `experiments.plist` file can be found in the Sample Application.

### Key descriptions
`VEN_EXPERIMENT_NAME`          : `String`  - The name of the experiment as it will appear in the Settings view

`VEN_EXPERIMENT_STABLE`        : `Boolean` - Whether the experiment is stable or not (grouped in Settings view)

`VEN_EXPERIMENT_ENABLED`       : `Boolean` - The default enabled state for the experiment

`VEN_EXPERIMENT_USER_EDITABLE` : `Boolean` - Whether the user can change the state of the experiment

`VEN_EXPERIMENT_FORCE_UPDATE`  : `Boolean` - If this is YES, the experiment will be force-moved to it's default state every open.

`VEN_EXPERIMENT_OPTIONS`       : `Dictionary` - Key-Value pairs of `KEY` : `Readable description` for options for this experiment.

`VEN_EXPERIMENT_DEFAULT_OPTION`: `String` - The key of the default option in the dictionary of options

### Experiment Settings View Controller

The library also contains a basic Experiment Settings View Controller which you can present to allow users to enable and disable experiments.

```objc
#import "VENExperimentsSettingsTVC.h"

...

VENExperimentsSettingsTVC *settingsTVC = [[VENExperimentsSettingsTVC alloc] init];
[self.navigationController pushViewController:settingsTVC animated:YES];
```
This will give an Experiment Settings screen that looks like this...

<img src="http://f.cl.ly/items/0Z3R2H1f1z3t1H3R3g3q/experiments.png" align="middle" width="320" />
### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
