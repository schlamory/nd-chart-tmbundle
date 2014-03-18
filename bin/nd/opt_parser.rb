require 'optparse'
require 'ostruct'
require 'date'

module Nd
  class OptParser
    def self.parse(args)
      options = OpenStruct.new
      opt_parser = OptionParser.new do |opts|

        opts.banner = banner
        set_options opts, options

      end
      opt_parser.parse!
      options
    end

    def self.set_options(opts,options)

      # Optional argument;
      opts.on("-d", "--date [yyyy_mm_dd]","date") do |s|
        options.date = Date.strptime(s, "%Y_%m_%d")
      end

    end

    def self.banner
      <<-banner
      NAME
        nd

      SYNOPSIS
        nd new patient ...
        nd new note ...
        nd finalize note ...

      DESCRIPTION
        Scripts for working with ND patient charts.

      OPTIONS
      banner
    end
  end
end