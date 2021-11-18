require 'errors/standard_error'

module Api
  module Concerns
    module Creatable
      extend ActiveSupport::Concern

      def create
        @model = model_class.new(model_params)

        if @model.save
          success_handler(@model, :created)
        else
          raise @model.errors
        end
      end
    end
  end
end
