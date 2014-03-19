require 'optparse'
require 'fileutils'
require 'yaml'
require 'nd/util'
require 'nd/patient'

module Nd

  class Visit
    attr_accessor :date, :patient

    def self.new_from_struct(options)
      visit = self.new
      visit.date = options.date
      visit.patient = options.patient rescue nil
      visit
    end

    def date_string
      date.strftime '%Y_%m_%d'
    end

    def patient_dir_path
      patient.dir_path
    end

    def dir_path
      patient.visits_dir_path + "/" + date_string
    end

    def snapshot_dir_path
      dir_path + "/.snapshot"
    end

    def progress_note_md_path
      dir_path + "/progress_note.md"
    end

    def save
      [dir_path,snapshot_dir_path].each do |dir|
        FileUtils.mkdir_p(dir) unless File.directory?(dir)
      end

      initialize_progress_note unless File.exist? progress_note_md_path
    end

    def initialize_progress_note
      File.open(progress_note_md_path,'w')
    end

  end

  class NewVisitOptParser < Nd::OptParser

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