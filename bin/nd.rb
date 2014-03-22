
module Nd
  BUNDLE_PATH = File.expand_path("../../",__FILE__)

end

$:.unshift File.expand_path("../",__FILE__)
require 'nd/opt_parser'
require 'nd/patient'
require 'nd/visit'
require 'nd/dictionary'
