require 'errors/standard_error'

module Api
  module Concerns
    module Updatable
      extend ActiveSupport::Concern

      included do
        @set_model_actions ||= []
        @set_model_actions << :update unless @set_model_actions.include? :update

        before_action :set_model, only: @set_model_actions
      end
      
      def update
        if @model.present?
          if @model.update(model_params)
            success_handler @model
          else
            raise @model.errors
          end
        else
          raise ::Errors::ModelNotFound
        end
      end
    end
  end
end
