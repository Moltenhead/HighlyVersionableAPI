require 'errors/standard_error'

module Api
  module V1
    module Concerns
      module IbanValidation
        extend ActiveSupport::Concern
        
        def valid_iban?(iban = params[:name], region = params[:region])
          raise ::Api::V1::Errors::NilIban.new if iban.nil?
          raise ::Api::V1::Errors::NotStringIban.new unless iban.is_a? String

          validation_method_name = "valid_#{region.downcase}_iban?".to_sym
          raise ::Api::V1::Errors::IbanRegionNoMatch.new unless respond_to? validation_method_name
          raise ::Api::V1::Errors::InvalidIban.new unless send(validation_method_name, iban)

          true
        end

        # Schema for validation method is `valid_#{iban.region.downcase}_iban?`
        # - those could be stored in another file and required
        def valid_france_iban?(iban)
          # needing a real checksum and propably an API call somewhere to truly validate authenticity
          /FR ?[\d]{2} ?[\d]{5} ?[\d]{5} ?[A-Z0-9]{11} ?[\d]{2}/ =~ iban
        end

        def valid_uk_iban?(iban)
          # needing a real checksum and propably an API call somewhere to truly validate authenticity
          /GB ?[\d]{2} ?[A-Z]{4} ?[\d]{4} ?[\d]{4} ?[\d]{4} ?[\d]{2}/ =~ iban
        end
      end
    end

    module Errors
      class NilIban < ::Errors::StandardError
        def initialize
          super(
            title: "Nil IBAN",
            status: 422,
            detail: "You must provide an Iban."
          )
        end
      end

      class NotStringIban < ::Errors::StandardError
        def initialize
          super(
            title: "Not String IBAN",
            status: 422,
            detail: "IBAN must be a string."
          )
        end
      end

      class IbanRegionNoMatch < ::Errors::StandardError
        def initialize
          super(
            title: "No Iban Region Match",
            status: 422,
            detail: "The given region has no IBAN validation method."
          )
        end
      end

      class InvalidIban < ::Errors::StandardError
        def initialize
          super(
            title: "Invalid Iban",
            status: 422,
            detail: "The given IBAN is invalid."
          )
        end
      end
    end
  end
end
