require 'nd/serializable'

class Nd::Medication < Nd::Serializable
  attr_accessor :name, :dose, :note
end
