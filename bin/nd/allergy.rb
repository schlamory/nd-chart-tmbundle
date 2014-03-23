require 'nd/serializable'

# tab-completions:
#   allergy =>
# -
#   item:
#   reaction:

class Nd::Allergy < Nd::Serializable
  attr_accessor :item, :reaction
end

