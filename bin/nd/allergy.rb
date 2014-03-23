require 'nd/serializable'

class Nd::Allergy < Nd::Serializable
  attr_accessor :item, :reaction
end