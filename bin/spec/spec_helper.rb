tmpdir = File.expand_path(File.join(__FILE__,'../tmp/'))
ENV["ND_PATIENTS_DIR"] = tmpdir + '/patients'

require 'rspec'
require_relative '../nd.rb'


Dir.mkdir(tmpdir) unless Dir.exists? tmpdir

def clear_patients
  FileUtils.rm_rf ENV["ND_PATIENTS_DIR"]
  Dir.mkdir(ENV["ND_PATIENTS_DIR"])
end

RSpec.configure do |config|

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = "random"

  config.after(:each) do
    clear_patients
  end

end



