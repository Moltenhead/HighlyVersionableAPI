module Api
  module V1
    class ApplicationController < ::Api::ApplicationController
      # cf api/v1/concerns
      include_versioned_concerns 1, *%i[
        ResponseHandler
      ]
    end
  end
end
