module Api
  class ApplicationController < ::ApplicationController
    ''' ---------------- '''
    ''' STATIC SHORTCUTS '''
    ''' ---------------- '''
    def model_class
      self.class.get_model_class
    end

    def permitted_params
      self.class.get_permitted_params
    end
    
    ''' ------- '''
    ''' PRIVATE '''
    ''' ------- '''
    private
      def set_model
        @model = model_class.find_by(id: params[:id])
      end

      def model_params
        params.require(model_class.to_s.downcase.to_sym).permit(*permitted_params)
      end

    ''' ------ '''
    ''' STATIC '''
    ''' ------ '''
    class << self
      def model_class(klass) # Class shorthand
        @model_klass = klass
      end
      def get_model_class
        @model_klass
      end

      def permitted_params(*params_list)
        @permitted_params = params_list
      end
      def get_permitted_params
        @permitted_params
      end

      # concern include utilities
      def include_common_concerns(*concerns_sym_list)
        concerns_sym_list.each do |sym|
          include "Api::Concerns::#{sym}".constantize
        end
      end

      def include_versioned_concerns(version, *concerns_sym_list)
        concerns_sym_list.each do |sym|
          include "Api::V#{version}::Concerns::#{sym}".constantize
        end
      end
    end
  end
end