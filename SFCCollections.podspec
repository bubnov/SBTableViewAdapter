Pod::Spec.new do |s|
  s.name            = "SFCCollections"
  s.version         = "0.1.0"
  s.summary         = "Tables/collections mini framework"
  s.homepage        = "https://github.com/bubnov/SFCCollections"
  s.license         = 'MIT'
  s.author          = { "Bubnov Slavik" => "bubnovslavik@gmail.com" }
  s.source          = { :git => "https://github.com/bubnov/SFCCollections.git", :tag => s.version.to_s }
  s.platform        = :ios, '7.0'
  s.requires_arc    = true
  s.source_files    = 'SFCCollections'
  s.public_header_files = 'SFCCollections/**/*.{h}'
  s.source_files = 'SFCCollections/**/*.{h,m}'
end
