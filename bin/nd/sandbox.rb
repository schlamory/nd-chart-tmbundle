#!/usr/bin/env ruby

require "erb"


class Patient
  attr_accessor :first_name, :last_name, :dob, :medications
  TEMPLATE_DIR = File.expand_path("../../../templates/patient",__FILE__)
  TEMPLATE_PATH = TEMPLATE_DIR + "/patient.yml"
  MEDICATIONS_TEMPLATE_PATH = TEMPLATE_DIR + "/medications.yml"
  PROBLEMS_TEMPLATE_PATH = TEMPLATE_DIR + "/problems.yml"

  def render_file(path)
    ERB.new(File.open(path,'r').read,nil,'<>').result binding
  end

  def source_file
    __FILE__
  end

  def medications
    @medications ||= []
  end

end

# puts Patient::TEMPLATE_PATH

p = Patient.new
p.first_name = "Amory"
p.last_name = "Schlender"

puts p.render_file Patient::MEDICATIONS_TEMPLATE_PATH


#
# # build data class
# class Listings
#   PRODUCT = { :name => "Chicken Fried Steak",
#               :desc => "A well messages pattie, breaded and fried.",
#               :cost => 9.95 }
#
#   attr_reader :product, :price
#
#   def initialize( product = "", price = "" )
#     @product = product
#     @price = price
#   end
#
#   def foo
#     'foo'
#   end
#
#   def build
#     b = binding
#     # create and run templates, filling member data variables
#     template = <<-END_PRODUCT
#     <%= PRODUCT[:name] %>
#     <%= PRODUCT[:desc] %>
#     <%= foo %>
#     END_PRODUCT
#     @product = ERB.new(template).result b
#     ERB.new(<<-'END_PRICE'.gsub(/^\s+/, ""), 0, "", "@price").result b
#       <%= PRODUCT[:name] %> -- <%= PRODUCT[:cost] %>
#       <%= PRODUCT[:desc] %>
#     END_PRICE
#   end
# end
#
# # setup template data
# listings = Listings.new
# listings.build
#
# puts listings.product + "\n" + listings.price