require 'nd/util'
require 'nd/patient'
require 'nd/serializable'

module Nd
  class Visit < Nd
    attr_accessor :date, :patient

    def date
      @date ||= Date.today
    end

  end

end