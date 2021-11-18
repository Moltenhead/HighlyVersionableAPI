require 'errors/standard_error'

module Api
  module Concerns
    module RandomPickable
      extend ActiveSupport::Concern

      def random_pick
        @model = model_class.order("RANDOM()").first
        if @model.present?
          success_handler @model
        else
          raise ::Errors::ModelEmpty
        end
      end
    end
  end
end
