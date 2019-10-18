Pod::Spec.new do |s|

s.name         = "BKPickerView"
s.version      = "1.1.1"
s.summary      = "a simple picker"
s.homepage     = "https://github.com/MMDDZ/BKPickerView"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.authors      = { "MMDDZ" => "694092596@qq.com" }
s.source       = { :git => "https://github.com/MMDDZ/BKPickerView.git", :tag => s.version.to_s }

s.ios.deployment_target = '8.0'

s.source_files = 'BKPickerView/*.{h,m}'
s.public_header_files = 'BKPickerView/BKPickerView.h'
s.private_header_files = 'BKPickerView/BKPickerConstant.h' , 'BKPickerView/BKPickerReusingModel.h', 'BKPickerView/BKPickerSelectDateTools.h', 'BKPickerView/BKPickerToolsView.h', 'BKPickerView/NSDate+BKPickerView.h', 'BKPickerView/UIView+BKPickerView.h'

s.framework  = "UIKit"

end
