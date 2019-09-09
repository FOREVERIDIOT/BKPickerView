Pod::Spec.new do |spec|

spec.name         = "BKPickerView"
spec.version      = "1.1.0"
spec.summary      = "a simple picker"
spec.homepage     = "https://github.com/MMDDZ/BKPickerView"
spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
spec.authors      = { "MMDDZ" => "694092596@qq.com" }
spec.source       = { :git => "http://github.com/MMDDZ/BKPickerView.git", :tag => spec.version.to_s }

spec.ios.deployment_target = '8.0'

spec.source_files = 'BKPickerView/*.{h,m}'
spec.public_header_files = 'BKPickerView/BKPickerView.h'
spec.private_header_files = 'BKPickerView/BKPickerConstant.h' , 'BKPickerView/BKPickerReusingModel.h', 'BKPickerView/BKPickerSelectDateTools.h', 'BKPickerView/BKPickerToolsView.h', 'BKPickerView/NSDate+BKPickerView.h', 'BKPickerView/UIView+BKPickerView.h'

spec.framework  = "UIKit"

end
