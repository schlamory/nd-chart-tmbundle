require 'nd/serializable'

class Nd::Problem < Nd::Serializable
  attr_accessor :diagnosis, :icd9, :note
end