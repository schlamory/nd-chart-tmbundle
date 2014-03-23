require 'yaml'
require 'nd/util'
require 'nd/serializable'
require 'nd/allergy'
require 'nd/medication'
require 'nd/problem'

module Nd

  class Patient < Nd::Serializable

    ND_PATIENTS_DIR = ENV["ND_PATIENTS_DIR"] || File.expand_path("~/projects/laura/patients")

    attr_accessor :first_name, :last_name, :date_of_birth
    attr_reader :problems, :medications, :allergies

    def allergies=(values)
      if values.first.kind_of? Hash
        @allergies = values.map {|v| Nd::Allergy.from_hash v}
      else
        @allergies = values
      end
    end

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