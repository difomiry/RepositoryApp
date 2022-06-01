platform:ios, '13.0'
use_frameworks!

target 'App' do
  pod 'Texture'
  pod 'Texture/IGListKit'
  pod 'KeychainAccess'
end

post_install do |installer|
  installer.pods_project.frameworks_group['iOS']['AssetsLibrary.framework'].remove_from_project
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end
