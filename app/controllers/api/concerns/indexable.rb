module Api
  module Concerns
    module Indexable
      extend ActiveSupport::Concern
      
      def index
        @models = model_class.all
        paginate status: 200, json: @models, adapter: :json_api
      end
    end
  end
end
