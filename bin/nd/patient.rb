require 'optparse'
require 'fileutils'
require 'yaml'
require 'nd/util'

class String
  def unindent
    gsub(/^#{scan(/^\s*/).min_by{|l|l.length}}/, "")
  end
end

module Nd
  ND_PATIENT_DIR = File.expand_path("~/projects/laura/patients")

  class Patient
    attr_accessor :first_name, :last_name, :dob, :dir_path
    attr_reader :problems, :medications

    def self.patient_for_dir(dir)
      dir ||= Dir.pwd
      while(dir != "/")
        if File.exists? dir + "/patient.yml"
          return self.new_from_dir dir
        end
        dir = File.expand_path("..",dir)
      end
      nil
    end

    def initialize
      @problems = []
      @medications = []
    end

    def self.new_from_dir(dir)
      patient = self.new
      patient.dir_path = dir
      h = YAML.load_file(dir + "/patient.yml")
      patient.first_name = h["first_name"]
      patient.last_name = h["last_name"]
      patient.dob = Nd.parse_date(dob)
      patient
    end

    def self.new_with_options(options)
      patient = self.new
      patient.first_name = options.first_name
      patient.last_name = options.last_name
      patient.dob = options.dob
      patient
    end

    def save
      [dir_path,visits_dir_path,labs_dir_path].each do |path|
        FileUtils.mkdir_p(path) unless File.directory?(path)
      end

      write_patient_file patient_file_path
      write_medications_file medications_file_path
      write_problems_file problems_file_path
    end

    def dir_path
      @dir_path || ND_PATIENT_DIR + "/#{last_name}, #{first_name}"
    end

    def persisted?
      File.directory?(dir_path)
    end

    def patient_file_path(dir=nil)
      File.expand_path(dir || dir_path) + "/patient.yml"
    end

    def medications_file_path(dir=nil)
      File.expand_path(dir || dir_path) + "/medications.yml"
    end

    def problems_file_path(dir=nil)
      File.expand_path(dir || dir_path) + "/problems.yml"
    end

    def visits_dir_path
      dir_path + "/visits"
    end

    def labs_dir_path
      dir_path + "/labs"
    end

    def write_patient_file(path)
      File.open(path, 'w') do |f|
        f.puts "#    #{last_name}, #{first_name} : Patient information"
        f.puts "#    #{path}"
        f.puts ""
        f.puts self.to_yaml_without_problems_or_medications
      end
    end

    def to_yaml_without_problems_or_medications
      <<-yaml.unindent
        first_name: #{first_name}
        last_name: #{last_name}
        dob: #{dob.strftime("%Y_%m_%d") rescue nil}
      yaml
    end

    def write_medications_file(path)
      File.open(path, 'w') do |f|
        f.puts "#    #{last_name}, #{first_name} : Medication list"
        f.puts "#    #{path}"
        f.puts ""
        # f.puts YAML::Dump self.medications
      end
    end

    def write_problems_file(path)
      File.open(path, 'w') do |f|
        f.puts "#    #{last_name}, #{first_name} : Problem list"
        f.puts "#    #{path}"
        f.puts ""
        # f.puts YAML::Dump self.problems
      end
    end

  end

  class PatientOptParser < Nd::OptParser

    def self.parse(argv)
      argv.shift
      argv.shift

      options = super
      name = argv.shift + " " + argv.shift

      if name =~ /^(\w+)\, (\w+)$/
        options.first_name = $2
        options.last_name = $1
      elsif name =~ /^(\w+) (\w+)$/
        options.first_name = $1
        options.last_name = $2
      end

      options
    end

    def self.set_options(opts,options)
      super(opts,options)
      # Optional argument;
      opts.on("-b", "--birthdate [yyyy_mm_dd]","Date of birth") do |dob|
        options.dob = Nd.parse_date(dob)
      end

    end

  end

  class NewPatientOptParser < PatientOptParser
    def self.banner
      <<-banner
      NAME
        nd-new-patient

      SYNOPSIS
        nd new patient [name]

      DESCRIPTION
        Creates a new patient with the given name.

      OPTIONS
      banner
    end

  end

end