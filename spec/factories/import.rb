module Factories
  class Import
    include Asyncable
    attr_accessor :status

    def async_operation
    end

    def save
    end
  end
end
