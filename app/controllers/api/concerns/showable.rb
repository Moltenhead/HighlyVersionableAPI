require 'errors/standard_error'

module Api
  module Concerns
    module Showable
      extend ActiveSupport::Concern

      included do
        @set_model_actions ||= []
        @set_model_actions << :show unless @set_model_actions.include? :show

        before_action :set_model, only: @set_model_actions
      end
      
      def show
        if @model.present?
          success_handler @model
        else
          raise ::Errors::ModelNotFound
        end
      end
    end
  end
end
