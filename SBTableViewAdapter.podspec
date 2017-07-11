Pod::Spec.new do |s|
  s.name            = "SBTableViewAdapter"
  s.version         = "0.1.10"
  s.summary         = "Simple table view wrapper"
  s.homepage        = "https://github.com/bubnov/SFCTableViewAdapter"
  s.license         = 'MIT'
  s.author          = { "Bubnov Slavik" => "bubnovslavik@gmail.com" }
  s.source          = { :git => "https://github.com/bubnov/SBTableViewAdapter.git", :tag => s.version.to_s }
  s.platform        = :ios, '8.0'
  s.requires_arc    = true
  s.source_files = 'TableViewAdapter/**/*.{swift}'
end
