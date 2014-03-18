#!/usr/bin/ruby
$:.unshift "~/Library/Application\ Support/Avian/Bundles/ND\ Chart.tmbundle/bin"
require 'nd/opt_parser'
require 'nd/patient'

def main

  if ARGV[0] == "new" and ARGV[1] == "patient"

    options = Nd::NewPatientOptParser.parse(ARGV)
    patient = Nd::Patient.new_with_options options
    if patient.persisted?
      message = "Patient directory #{patient.dir_path} already exists! Exiting."
    else
      patient.save
      message = "Created new patient file for #{patient.first_name} #{patient.last_name} at #{patient.dir_path}."
    end

  elsif ARGV[0] == "new" and ARGV[1] == "visit"
    options = Nd::NewVisitParser.parse(ARGV)


  else

    options = Nd::OptParser.parse(ARGV)
  end

  puts message

end

if __FILE__ == $0
  main
end