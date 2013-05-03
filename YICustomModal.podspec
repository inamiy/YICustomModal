Pod::Spec.new do |s|
  s.name     = 'YICustomModal'
  s.version  = '0.1'
  s.license  = { :type => 'Beerware', :text => 'If we meet some day, and you think this stuff is worth it, you can buy me a beer in return.' }
  s.homepage = 'https://github.com/inamiy/YICustomModal'
  s.author   = { 'Yasuhiro Inami' => 'inamiy@gmail.com' }
  s.summary  = "Custom modal, mainly for iOS5 youtube-fullscreen-dismiss bug (see also: https://github.com/inamiy/ModalYoutubeIOS5Bug)."
  s.source   = { :git => 'https://github.com/inamiy/YICustomModal.git', :tag => "#{s.version}" }
  s.source_files = 'YICustomModal/*.{h,m}'
  s.requires_arc = true
  s.platform = :ios, '5.0'
end
