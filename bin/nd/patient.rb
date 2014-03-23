require 'optparse'
require 'fileutils'
require 'yaml'
require 'nd/util'

module Nd

  class Patient

    ND_PATIENTS_DIR = ENV["ND_PATIENTS_DIR"] || File.expand_path("~/projects/laura/patients")

    attr_accessor :first_name, :last_name, :date_of_birth
    attr_reader :problems, :medications

    def name
      "#{last_name}, #{first_name}"
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

  end

end