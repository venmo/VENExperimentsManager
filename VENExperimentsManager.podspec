Pod::Spec.new do |s|
  s.name         = "VENExperimentsManager"
  s.version      = "0.1.1"
  s.summary      = "Definition, management and control of experiments within an iOS app."
  s.description  = <<-DESC
                   VENExperimentsManager enables easy definition, management and control of experiments within an iOS app including the following:
                    - Define experiments and 'experiment flag' code
                    - Allow users to turn experiments on and off
                    - Force turn-on or off experiments
                    - Make experiments user editable or not
                    - Let users know whether experiments are 'stable' or 'unstable'
                   DESC

  s.homepage     = "https://github.braintreeps.com/chrismaddern/VENExperimentsManager"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Chris Maddern" => "chris@venmo.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "git@github.braintreeps.com:chrismaddern/VENExperimentsManager.git", :tag => "v#{s.version}" }
  s.source_files = 'VENExperimentsManager/**/*.{h,m}'
  s.requires_arc = true
end
