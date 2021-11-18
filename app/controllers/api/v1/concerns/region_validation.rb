require 'errors/standard_error'

module Api
  module V1
    module Concerns
      module RegionValidation
        extend ActiveSupport::Concern
        
        def valid_regions
          self.class.get_valid_regions
        end

        def valid_region?(region = params[:region])
          raise ::Api::V1::Errors::NilRegion.new if region.nil?
          raise ::Api::V1::Errors::StringRegion.new unless region.is_a? String
          raise ::Api::V1::Errors::InvalidRegion.new unless valid_regions.include? region.to_sym

          true
        end

        module ClassMethods
          def valid_regions(*valid_regions_sym_list)
            @valid_regions = valid_regions_sym_list
          end

          def get_valid_regions
            @valid_regions
          end
        end
      end
    end

    module Errors
      class NilRegion < ::Errors::StandardError
        def initialize
          super(
            title: "Nil Region",
            status: 422,
            detail: "You must provide a region."
          )
        end
      end

      class NotStringRegion < ::Errors::StandardError
        def initialize
          super(
            title: "Not String Region",
            status: 422,
            detail: "Region must be a string."
          )
        end
      end

      class InvalidRegion < ::Errors::StandardError
        def initialize
          super(
            title: "Invalid Region",
            status: 422,
            detail: "The given region is invalid."
          )
        end
      end
    end
  end
end
