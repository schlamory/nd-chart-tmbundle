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
#
# allergies:
#
# caregivers:

module Nd

  class Patient < Nd::Serializable

    ND_PATIENTS_DIR = ENV["ND_PATIENTS_DIR"]

    attr_accessor :first_name, :last_name, :date_of_birth, :dir_path
    attr_reader :problems, :medications, :allergies

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
      "#{last_name}, #{first_name}"
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
      @dir_path ||= File.expand_path(name,ND_PATIENTS_DIR)
    end

    def visits_dir_path
      File.expand_path("visits",dir_path)
    end

    def visit_dates
      Dir[visits_dir_path + "/*_*_*/"].map do |s|
        Date.strptime Pathname.new(s).basename.to_s, "%Y_%m_%d"
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

    def self.patient_dir_containing_dir(dir)
      while dir != "/"
        if File.exists? File.expand_path("patient.yml", dir)
          return dir
        end
        dir = File.expand_path "..", dir
      end
    end

    def self.initialize_from_dir(dir_path)
      patient_hash = YAML.load(File.read(File.expand_path("patient.yml",dir_path)))
      patient = self.from_hash patient_hash
      patient.dir_path = dir_path

      medications = YAML.load(File.read(patient.medications_yml_path))
      patient.medications = medications if medications.kind_of? Array

      problems = YAML.load(File.read(patient.problems_yml_path))
      patient.problems = problems if problems.kind_of? Array

      patient
    end

    private

    def template_path(filename)
      File.expand_path("templates/patient/"+filename,BUNDLE_PATH)
    end

    def render_file(path)
      ERB.new(File.open(path,'r').read,nil,'<>').result binding
    end

    def initialize_file_with_template_if_absent(file_path,template_name)
      unless File.exists? file_path
        text = render_file template_path template_name
        File.write(file_path, text)
      end
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