require 'yaml'
require 'erb'
require 'fileutils'
require 'nd/util'
require 'nd/serializable'
require 'nd/allergy'
require 'nd/medication'
require 'nd/problem'

# tab-completions
#   patient=>
#
# first_name:
# last_name:
# dob:
# gender:
#
# alert:
#

module Nd

  class Patient < Nd::Serializable

    ND_PATIENTS_DIR = ENV["ND_PATIENTS_DIR"]

    attr_accessor :first_name, :last_name, :date_of_birth, :dir_path, :gender
    attr_reader :problems, :medications, :allergies
    attr_accessor :alert

    def allergies=(values)
      values = [] if values.nil?
      @allergies = values_with_type(values,Nd::Allergy)
    end

    def problems=(values)
      values = [] if values.nil?
      @problems = values_with_type(values,Nd::Problem)
    end

    def medications=(values)
      values = [] if values.nil?
      @medications = values_with_type(values,Nd::Medication)
    end

    def name
      "#{first_name} #{last_name}"
    end

    def name=(value)
      if value =~ /(.*)\, (.*)/
        self.last_name = $1.strip.capitalize
        self.first_name = $2.strip.capitalize
      end
    end

    def age
      age_on_date(Date.today) rescue nil
    end

    def dob
      self.date_of_birth.strftime "%Y_%m_%d" rescue nil
    end

    def dob=(value)
      self.date_of_birth = Nd.parse_date value
    end

    def age_on_date(date)
      bd_on_date_year = Date.strptime("#{date.year}_#{date_of_birth.strftime '%m_%d'}", "%Y_%m_%d")
      date.year - date_of_birth.year - (bd_on_date_year > date ? 1 : 0)
    end

    def patient_file_exists?
      File.exist? patient_yml_path
    end

    def initialize_files_if_absent
      create_dir_if_absent
      initialize_file_with_template_if_absent patient_yml_path, "patient.yml"
      initialize_file_with_template_if_absent medications_yml_path, "medications.yml"
      initialize_file_with_template_if_absent problems_yml_path, "problems.yml"
    end

    def dir_path
      @dir_path ||= File.expand_path("#{last_name}, #{first_name}",ND_PATIENTS_DIR)
    end

    def visits_dir_path
      File.expand_path("visits",dir_path)
    end

    def visit_dates
      Dir[visits_dir_path + "/*_*_*/"].map do |s|
        Date.strptime s.gsub(/.*\/(.*)\//,'\1'), "%Y_%m_%d"
      end
    end

    def create_dir_if_absent
      FileUtils.mkdir_p dir_path unless Dir.exists? dir_path
      FileUtils.mkdir_p visits_dir_path unless Dir.exists? visits_dir_path
    end

    def patient_yml_path
      File.expand_path("patient.yml",dir_path)
    end

    def medications_yml_path
      File.expand_path("medications.yml",dir_path)
    end

    def problems_yml_path
      File.expand_path("problems.yml",dir_path)
    end

    def self.patient_for_dir(dir)
      patient_dir = self.patient_dir_containing_path(dir)
      if patient_dir
        self.initialize_from_dir(patient_dir)
      end
    end

    def self.patient_dir_containing_path(dir)
      while dir != "/"
        if File.exists? File.expand_path("patient.yml", dir)
          return dir
        end
        dir = File.expand_path "..", dir
      end
    end

    def self.initialize_from_dir(dir_path)

      dir_path = patient_dir_containing_path(dir_path)

      patient = self.from_hash self.load_yaml_from_path File.expand_path("patient.yml", dir_path)
      patient.dir_path = dir_path

      patient.load_medications
      patient.load_problems

      patient
    end

    def load_medications
      medications = load_yaml_from_path medications_yml_path
      self.medications = medications if medications.kind_of? Array
    end

    def load_problems
      problems = load_yaml_from_path problems_yml_path
      self.problems = problems if problems.kind_of? Array
    end

    protected

    def template_path(filename)
      File.expand_path("templates/patient/"+filename,BUNDLE_PATH)
    end

    def values_with_type(values,klass)
      values.map do |v|
        if v.kind_of? klass
          v
        elsif v.kind_of? Hash
          klass.from_hash v
        end
      end
    end

  end

end