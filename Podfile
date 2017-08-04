platform :ios, '10.0'
use_frameworks!

target 'LickAndStick' do
    pod 'EasyTipView', '~> 1.0.2'
    pod 'SwiftLint'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.2'
        end
    end
end
