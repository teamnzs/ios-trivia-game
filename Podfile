# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ios-trivia-game' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

# Pods for ios-trivia-game
  pod 'Alamofire', '~> 4.0'
  pod 'AFNetworking', '~> 3.0.0'
  pod 'MBProgressHUD', '~> 0.9.1'
  pod 'BDBOAuth1Manager', '~> 2.0.0'
  pod 'SwiftIconFont'
  pod 'FirebaseAuth'
  pod 'Firebase/Database'
  pod 'Firebase'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'EMPageViewController'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['SWIFT_VERSION'] = '3.0'
          end
      end
  end
end
