platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

target 'Whitelabel' do
    pod 'AlamofireObjectMapper', '~> 4.0'
    pod 'Kingfisher'
    pod 'SwiftGen'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        puts "#{target.name}"
    end
end
