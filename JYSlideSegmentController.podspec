Pod::Spec.new do |s|
  s.name     = 'JYSlideSegmentController'
  s.version  = '2.1.0'
  s.license  = 'MIT'
  s.summary  = 'JYSlideSegmentController is a view controllers container, just like the UITabBarController, with smooth gesture.'
  s.homepage = 'https://github.com/HisaMasa/JYSlideSegmentController'
  s.authors  = { 'jinyu' => 'goldfish.jinyu@gmail.com' }
  s.source   = { :git => 'https://github.com/HisaMasa/JYSlideSegmentController.git',
                 :tag => s.version.to_s
               }
  s.requires_arc = true
  s.source_files = 'JYSlideSegmentController/Source/**/*.{h,m}'
  s.platform     = :ios, '8.0'
end

