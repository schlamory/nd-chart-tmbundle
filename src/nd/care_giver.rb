require 'nd/serializable'

# tab-completions:
#   caregiver =>
# -
#   name:
#   relationship:
#   phone:
#   email:
#   note:

class Nd::CareGiver < Nd::Serializable
  attr_accessor :name, :phone, :email, :relationship, :note
end
