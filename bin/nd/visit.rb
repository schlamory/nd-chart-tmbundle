require 'nd/util'
require 'nd/patient'
require 'nd/serializable'

module Nd
  class Visit
    attr_accessor :date, :patient

    def date
      @date ||= Date.today
    end

    def patient_age
      patient.age_on_date date
    end

  end

end
