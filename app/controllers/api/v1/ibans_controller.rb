module Api
  module V1
    class IbansController < ApplicationController
      # Define which model it should handle
      model_class ::Iban
      # Define what CRUD actions are present within this controller - cf : controllers/api/concerns
      include_common_concerns *%i[
        Indexable
        Showable
        RandomPickable
        Creatable
        Updatable
        Destroyable
      ]
      # limits which params are passed for update or create
      permitted_params *%i[
        name
        region
      ]

      # validations are concerns, this way you can cherry pick which to include in other API versions if no changes are needed
      # - cf : controllers/api/v1/concerns
      include_versioned_concerns 1, *%i[
        IbanValidation
        RegionValidation
      ]
      # Define valid regions
      valid_regions *%i[
        FRANCE
        UK
      ]

      # Handling attribute validation in the controller for better API versionability       
      before_action :validate_mutation_params, only: [:create, :update]

      private
        ''' ---------- '''
        ''' OVERWRITES '''
        ''' ---------- '''
        def set_model
          return if (@model = model_class.find_by(id: params[:id])).present?
          
          @model = model_class.find_by(name: params[:id])
        end

        def model_params
          hash = super
          hash[:name] = hash[:name].gsub(/\s+/, "")
          hash
        end


        ''' ----- '''
        ''' HOOKS '''
        ''' ----- '''
        def validate_mutation_params
          valid_region?
          valid_iban?
        end
    end
  end
end
