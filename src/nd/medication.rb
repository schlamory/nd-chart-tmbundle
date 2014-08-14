require 'nd/serializable'

# tab-completions:
#   med =>
# -
#   name:
#   dose:
#   note:

class Nd::Medication < Nd::Serializable
  attr_accessor :name, :dose, :note
end
