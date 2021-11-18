require 'errors/standard_error'

module Api
  module Concerns
    module Destroyable
      extend ActiveSupport::Concern

      included do
        @set_model_actions ||= []
        @set_model_actions << :destroy unless @set_model_actions.include? :destroy

        before_action :set_model, only: @set_model_actions
      end
      
      def destroy
        if @model.present?
          if @model.destroy
            succes_handler({ message: 'Model successfully destroyed' })
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
