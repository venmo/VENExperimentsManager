## VENExperimentsManager

VENExperimentsManager enables easy definition, management and control of experiments within an iOS app including the following:
- Define experiments and 'experiment flag' code
- Allow users to turn experiments on and off
- Force turn-on or off experiments
- Make experiments user editable or not
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

The plist file defining experiments follows this format. It can also be easily configured in XCode.
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

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request