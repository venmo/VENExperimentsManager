## VENExperimentsManager<img src="http://f.cl.ly/items/2Y1o3X3s3X2Q1w2h0U10/AutoUpdates.png" align="right" width="260" align="right" style="padding-top:-20px; padding-left:20px;" />

VENExperimentsManager enables easy definition, management and control of experiments within an iOS app including the following:
- Define experiments and 'experiment flag' code
- Allow users to turn experiments on and off
- Force turn-on or off experiments
- Make experiments user-editable or fixed
- Let users know whether experiments are 'stable' or 'unstable'

### Usage

```
[VENExperimentsManager startExperimentsManagerWithPlistName:@"testExperiments"];
```

Then you can access experiments as follows..
```
VENExperiment *experiment = [VENExperimentsManager experimentWithIdentifier:VEN_EXPERIMENT_SOME_EXPERIMENT];

// Or if you just want to know if it's enabled
[VENExperimentsManager experimentIsEnabled:VEN_EXPERIMENT_SOME_EXPERIMENT];
```

The plist file defining experiments is a dictionary of experiment-identifier : experiment-definition dictionaries. It can be easily configured in XCode.

<img src="http://f.cl.ly/items/2Q2g0B2R1v0J322q1534/ExperimentsXCode.png" align="middle" width="500" />

The plist will look like this..
```
<plist version="1.0">
<dict>
	<key>VEN_EXPERIMENT_SOME_EXPERIMENT</key>
	<dict>
		<key>VEN_EXPERIMENT_NAME</key>
		<string>Some Experiment Title</string>
		<key>VEN_EXPERIMENT_ENABLED</key>
		<false/>
		<key>VEN_EXPERIMENT_USER_EDITABLE</key>
		<true/>
	</dict>
</dict>
</plist>
```

A sample `experiments.plist` file can be found in the Sample Application.

### Experiment Settings

The library also contains a basic Experiment Settings View Controller which you can present to allow users to enable and disable experiments.

```
#import "VENExperimentsSettingsTVC.h"

...

VENExperimentsSettingsTVC *settingsTVC = [[VENExperimentsSettingsTVC alloc] init];
[self.navigationController pushViewController:settingsTVC animated:YES];
```
This will give an Experiment Settings screen that looks like this...

<img src="http://f.cl.ly/items/0z202o3w1V2I3Q0J0r2y/ExperimentsTop.png" align="middle" width="320" />
### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
