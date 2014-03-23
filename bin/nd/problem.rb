require 'nd/serializable'

# tab-completions
#   prob =>
# -
#   diagnosis:
#   icd9:
#   note:

class Nd::Problem < Nd::Serializable
  attr_accessor :diagnosis, :icd9, :note
end