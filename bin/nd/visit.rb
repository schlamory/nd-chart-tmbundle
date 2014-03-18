require 'optparse'
require 'fileutils'
require 'yaml'
require 'nd/util'
require 'nd/patient'

module Nd

  class Visit
    attr_accessor :date, :patient
  end

  class NewVisitOptParser < VisitOptParser

    def self.parse(argv)
      argv.shift
      argv.shift

      options = super
      begin
        options.date
      rescue
        begin
          d = argv.shift
          options.date = Nd.parse_date(d)
        rescue
          options.date = Date.today
        end
      end

      options
    end

    def self.set_options(opts,options)
      super(opts,options)
    end

    def self.banner
      <<-banner
      NAME
        nd-new-visit

      SYNOPSIS
        nd new visit [date]

      DESCRIPTION
        Creates a new patient visit the given date.

      OPTIONS
      banner
    end

  end

end