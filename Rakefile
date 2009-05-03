require 'rake'

desc "Install missing iPhoneSimulator libraries"
task :install_dependencies do
  Dir["/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator*.sdk/usr/lib/"].each do |target_dir|
    [
      '/Developer/SDKs/MacOSX10.5.sdk/usr/lib/libtidy.dylib',
      '/Developer/SDKs/MacOSX10.5.sdk/usr/lib/libtidy.A.dylib'
    ].each do |file|
      unless File.exists?(File.join(target_dir, File.basename(file)))
        sh "sudo cp #{file} #{target_dir}"
      end
    end
  end
end